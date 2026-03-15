event_inherited();

timer_end        = undefined;   
allow_same_turns = true;


pattern_pool = ["shield_wall", "shield_crush", "half_flood"];

// shield_wall state
column_timer = 0;
volley_dir   = 1;

// shield_crush state
wall_inst       = noone;
wall_volley_row = 0;
wall_side       = 1;
crush_dir       = 1;

// half_flood state
flash_half  = 0;
flash_alpha = 0;
flash_phase = 0;
