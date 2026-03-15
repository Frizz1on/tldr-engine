/// @description box is created — pick Larry's pattern
// When Berry is still alive, Larry only uses sword_sweep.
// sword_stakes is solo-only: it's too oppressive alongside Berry attacking at the same time.
// When Larry is alone, both patterns are available.

// Find Berry's enemy index
var _berry_alive = false;
for (var _i = 0; _i < array_length(o_enc.encounter_data.enemies); _i++) {
    if is_instanceof(o_enc.encounter_data.enemies[_i], enemy_berry) {
        if enc_enemy_isfighting(_i)
            _berry_alive = true;
        break;
    }
}

if (_berry_alive) {
    pattern = "sword_sweep";  
} 

event_inherited();


