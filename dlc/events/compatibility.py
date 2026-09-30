"""Fail closed on project package identity clashes or unsupported queue expressions."""
from pathlib import Path
import json
import re

REGISTER = re.compile(r'::mods_registerMod\(\s*"([^"\n]+)"')
QUEUE = re.compile(r'::mods_queue\(\s*"([^"\n]+)"\s*,\s*(null|"[^"\n]*")\s*,')
IDENTITY = re.compile(r'\bthis\.m\.ID\s*(?:=|<-)\s*"([^"\n]+)"')


def inspect_packages(base, dlc):
    roots = [base / "src"] + sorted(p / "src" for p in (base / "dlc").iterdir() if (p / "src").is_dir())
    registered, declarations, own_ids, foreign_ids = {}, [], {}, {}
    own = dlc / "src"
    if all(root.resolve() != own.resolve() for root in roots):
        roots.append(own)

    def label(path):
        return str(path.relative_to(base)) if path.is_relative_to(base) else str(path)
    for root in roots:
        paths = {}
        for path in root.rglob("*"):
            if not path.is_file():
                continue
            name = path.relative_to(root).as_posix().casefold()
            if name in paths:
                raise ValueError(f"Case-insensitive package path collision: {path} / {paths[name]}")
            paths[name] = str(path)
            if path.suffix != ".nut":
                continue
            source = path.read_text(encoding="utf-8-sig")
            # Retain strings while stripping comments, so commented examples do
            # not introduce fictitious dependencies/identities into the audit.
            source = re.sub(r'"(?:\\.|[^"\\])*"|//[^\n]*|/\*[\s\S]*?\*/',
                            lambda m: m[0] if m[0].startswith('"') else "", source)
            target = own_ids if root.resolve() == own.resolve() else foreign_ids
            for identity in IDENTITY.findall(source):
                target.setdefault(identity, []).append(label(path))
            if "!mods_preload" not in path.parts:
                continue
            for mod_id in REGISTER.findall(source):
                if mod_id in registered:
                    raise ValueError(f"Duplicate project Mod ID {mod_id}: {registered[mod_id]} / {path}")
                registered[mod_id] = label(path)
            queues = QUEUE.findall(source)
            if len(queues) != len(re.findall(r"::mods_queue\s*\(", source)):
                raise ValueError(f"Dynamic/unsupported queue expression requires explicit audit: {path}")
            for mod_id, raw in queues:
                before, after, requirements = [], [], []
                for token in ([] if raw == "null" else json.loads(raw).split(",")):
                    match = re.fullmatch(r"\s*([<>]?)([a-zA-Z0-9_]+)(?:\([^()]*\))?\s*", token)
                    if not match:
                        raise ValueError(f"Unsupported queue token {token!r}: {path}")
                    order, other = match.groups()
                    (after if order == ">" else before if order == "<" else requirements).append(other)
                    if other == mod_id:
                        raise ValueError(f"Self dependency/order: {mod_id}")
                declarations.append({"id": mod_id, "before": before, "after": after, "requires": requirements})
        if root.resolve() == own.resolve():
            own_paths = paths
    for root in roots:
        if root.resolve() != own.resolve():
            names = {p.relative_to(root).as_posix().casefold() for p in root.rglob("*") if p.is_file()}
            if set(own_paths) & names:
                raise ValueError("Events DLC overlaps another package: " + repr(sorted(set(own_paths) & names)))
    for identity, paths in own_ids.items():
        if len(paths) != 1 or identity in foreign_ids:
            raise ValueError(f"Events DLC runtime ID collision: {identity}: {paths + foreign_ids.get(identity, [])}")
    for q in declarations:
        if q["id"] not in registered:
            raise ValueError("Queued project Mod is not registered: " + q["id"])
        if q["id"] == "mod_afeix_dlc_events" and (q["before"] or q["after"] != ["mod_afeix_expedition"]
                                                     or q["requires"] != ["mod_afeix_expedition"]):
            raise ValueError("Events DLC must depend/load only after main; audit optional integrations separately")
    # Directed graph over all queued callbacks, including multiple callbacks
    # from the same Mod. Requirements alone do not imply queue order in Hooks.
    edges = {i: set() for i in range(len(declarations))}
    for i, q in enumerate(declarations):
        for j, other in enumerate(declarations):
            if other["id"] in q["after"]:
                edges[i].add(j)
            if other["id"] in q["before"]:
                edges[j].add(i)
    active, done = set(), set()

    def visit(i):
        if i in active:
            raise ValueError("Cyclic project loading order involving " + declarations[i]["id"])
        if i in done:
            return
        active.add(i)
        for j in edges[i]:
            visit(j)
        active.remove(i)
        done.add(i)

    for i in edges:
        visit(i)
    return {"project_mod_ids": sorted(registered), "runtime_ids": sorted(own_ids),
            "path_and_id_collisions": [], "dependency_cycles": [], "queue_declarations": declarations}


def hooks_runner(declarations):
    rows = []
    for q in declarations:
        rows.append("make(" + json.dumps(q["id"]) + "," + json.dumps(q["before"]) + "," + json.dumps(q["after"]) + ")")
    return '''::Math <- { max=function(a,b){return a>b?a:b;} };
::Hooks <- { errorAndThrow=function(message){throw message;} };
dofile("native/hooks_queue_graph.nut");
function make(id,before,after){return {getModID=function(){return id;},getFunctionID=function(){return 0;},
    getLoadBefore=function(){return before;},getLoadAfter=function(){return after;}};}
local queue=[''' + ",".join(rows) + '''];
local graph=::Hooks.ModHooksQueueGraph(queue);
if(graph.getSorted().len()!=queue.len())throw "Queue lost callbacks";
local negative=0;
foreach(q in [[make("self",[],["self"])], [make("a",[],["b"]),make("b",[],["a"])]] ) {
    try {::Hooks.ModHooksQueueGraph(q);} catch(error){negative++;}
}
if(negative!=2)throw "Cycle detector did not reject self/cross cycles";
print("HOOKS_GRAPH_PASSED=3\\n");
'''
