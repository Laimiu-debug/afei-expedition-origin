const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
let checks = 0;
function check(value) { assert.ok(value); ++checks; }
function Module() { this.value = null; this.ids = []; }
Module.prototype.notifyBackendEntityEntersFirstSlot = function(id, callback) {
    this.ids.push(id);
    if (this.deferred) this.pending = callback;
    else callback(this.value);
    return 'native-return';
};
const context = {TacticalScreenTurnSequenceBarModule:Module};
vm.runInNewContext(fs.readFileSync('src/ui/mods/afeix/douyu_turnbar.js','utf8'), context);
const bar = new Module(); let calls = 0, received;
const callback = data => {++calls;received=data;};
bar.value = {id:2}; check(bar.notifyBackendEntityEntersFirstSlot(2, callback)==='native-return');
check(calls===1 && received===bar.value && bar.ids[0]===2);
bar.value = {AfeixRemovedFirstSlot:true}; bar.notifyBackendEntityEntersFirstSlot(3, callback);
check(calls===1 && bar.ids[1]===3);
bar.value = null; bar.notifyBackendEntityEntersFirstSlot(4, callback);
check(calls===2 && received===null);
bar.value = undefined; bar.notifyBackendEntityEntersFirstSlot(5, callback);
check(calls===3 && received===undefined);
bar.value = {AfeixRemovedFirstSlot:false}; bar.notifyBackendEntityEntersFirstSlot(6, callback);
check(calls===4 && received===bar.value);
bar.deferred = true; bar.value = {id:7};
bar.notifyBackendEntityEntersFirstSlot(7, callback);
const staleReply = bar.pending;
bar.afeixInvalidateFirstSlot(); staleReply(bar.value);
check(calls===4);
bar.notifyBackendEntityEntersFirstSlot(8, callback); bar.pending({id:8});
check(calls===5 && received.id===8);
const otherBar = new Module(); otherBar.deferred = true;
otherBar.notifyBackendEntityEntersFirstSlot(9, callback);
bar.afeixInvalidateFirstSlot(); otherBar.pending({id:9});
check(calls===6 && received.id===9);
console.log('TESTS_PASSED='+checks);
