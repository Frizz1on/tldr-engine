// --- o_turn_bloomguard / Other_12 ---
// When solo: full pool (wave, sniper, bloom).
// When in a group: only sniper — wave covers the whole box and is too
// overwhelming combined with another attack, and bloom requires
// full spatial attention to read.
var _solo = (enc_count_fighting_enemies() <= 1);
if (!_solo) {
    pattern = "thorn_sniper";
} // else: leave undefined, parent picks from full pattern_pool

event_inherited();

