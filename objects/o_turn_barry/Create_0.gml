event_inherited()

timer_end        = 245   // Berry's turn is longer — she's patient
pattern_pool     = ["shield_wall", "shield_crush"]
allow_same_turns = false

// shield_wall state
column_timer = 0
column_x_offset = 0   // shifts each column slightly to prevent pure memorisation

// shield_crush state
wall_inst     = noone
volley_count  = 0
crush_dir     = 1     // which side the sliding wall comes from