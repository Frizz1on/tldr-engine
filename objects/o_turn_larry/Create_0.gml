vent_inherited()

timer_end        = 230
pattern_pool     = ["sword_sweep", "alarm_burst"]
allow_same_turns = false

// sword_sweep state
sweep_dir   =  1    // +1 = left arc, -1 = right arc. Alternates each use.
slash_count =  0

// alarm_burst state
burst_wave  =  0    // which wave we're on (0 or 1)