# Disposable engine facing test

This directory is development evidence; do not distribute it as the gameplay mod.
For v0.7, expect native armor/weapons/shields/helmets to show. Toad resolves to
normal human Afei and Feidie has no UFO decoration. Older log text such as
`disc=true` records the test slot's route, not proof of a rendered UFO.

Build with the bundled Python and `build_harness.py`. Copy the resulting
`mod_afeix_facing_playtest.zip` beside the current production mod in the game's
`data` directory, with Legacy Script Hooks loaded. The installed Chinese mod in
this environment already includes Hooks 21.1; a second Hooks ZIP is unnecessary.

Start the game, select **Scenarios**, then the first entry: **AFEIX Facing Art
Test** (id 0, normally Combat Basics). No campaign or save is created. Close the
game and remove only this dev ZIP after testing to restore the original scenario.

The first unit is Afei Normal at square (14,14), with a native enemy on its right
and a custom enemy on its left. Nine more allies show Damou, Mocha, Toad Afei,
Jiahao Afei, Feidie Afei, Bottle, Keke, Wangdazhi and one native comparison.
The current harness equips sword, shield and mail, with selected full-helm
comparison slots. Custom heads sit above armor and below equipped helmets.

Suggested checks:

1. Capture initial battlefield and compare right-facing allies with the mirrored
   custom enemy. Check all 10 ally turn-order portraits and native size comparison.
2. Select Afei's sword attack, target the enemy on the left, and inspect turning
   during the attack and restoration afterward. Repeat against the right enemy.
3. Move an unengaged custom ally to a free tile and check its sprite and UI portrait.
4. Confirm Toad and Feidie use human art without UFO, and equipment remains visible.
5. Read `log.html` for `AFEIX_FACING_TEST` and new script exceptions. The generated
   READY log and layer assertions prove initialization only, not visual quality.

The test adapter bypasses only campaign origin/route selection for actors marked
`afeixPlaytestBrush`. Rendering, equipment layering, turn logic, injury and death
remain the installed production implementations. Thus this is a tactical renderer
check, not a full campaign/save/load or progression validation.
