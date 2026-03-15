event_inherited();

allow_same_turns = false;   // engine deduplicates — only one instance survives
timer_end        = undefined; // we manage destruction manually

phase       = 0;            // 0 = Larry, 1 = Berry
phase_timer = 0;            // timer local to current phase

// Larry patterns
larry_pattern_pool = ["sword_sweep", "alarm_burst"];
larry_pattern      = undefined;

// Berry patterns
berry_pattern_pool = ["shield_wall", "shield_crush"];
berry_pattern      = undefined;

// Per-pattern state — Larry
sweep_dir   = 1;
slash_count = 0;
mark_count  = 0;
marker      = array_create(10, 0);
marker_inst = array_create(10, noone);

// Per-pattern state — Berry
column_timer    = 0;
column_x_offset = 0;
volley_dir      = 1;
wall_inst       = noone;
wall_volley_row = 0;
wall_side       = 1;
crush_dir       = 1;

// Flash state for Berry's lockdown attack
flash_half   = 0;     // which half (0 = left, 1 = right)
flash_alpha  = 0;
flash_tick   = 0;
flash_phase  = 0;     // 0=warning ticks, 1=flood
flood_top    = [];
flood_bot    = [];
