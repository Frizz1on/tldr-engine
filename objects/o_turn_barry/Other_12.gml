/// @description box is created — pick Berry's pattern
// When Larry is still alive, Berry only uses shield_wall or shield_crush.
// half_flood is solo-only: filling half the box is fair 1v1 but oppressive
// when Larry is simultaneously attacking from the other angle.

// Find Larry's enemy index
var _larry_alive = false;
for (var _i = 0; _i < array_length(o_enc.encounter_data.enemies); _i++) {
    if is_instanceof(o_enc.encounter_data.enemies[_i], enemy_larry) {
        if enc_enemy_isfighting(_i)
            _larry_alive = true;
        break;
    }
}

if (_larry_alive) {
    // Partner present — pick from paired-safe patterns only
    pattern = choose("shield_wall", "shield_crush");
} // else: leave pattern undefined, parent picks from full pattern_pool (includes half_flood)

event_inherited();
