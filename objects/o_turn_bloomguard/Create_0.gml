event_inherited();
timer_end        = undefined;
allow_same_turns = true;
pattern_pool     = ["thorn_wave", "thorn_sniper", "thorn_bloom"];

// thorn_wave state
wave_xs    = [];
wave_shift = 0;

// thorn_sniper state
sniper_aim  = 0;
sniper_rays = [];   // raycast instances

// thorn_bloom state
bloom_x = 0;
bloom_y = 0;

