event_inherited();
timer_end        = undefined;
allow_same_turns = true;
pattern_pool     = ["laser_lock", "ping_cross"];

// laser_lock state
lock_x    = 0;
ray_insts = [];   // raycast line instances, destroyed when bullets fire

// ping_cross state
// (no persistent state needed — everything is computed per-frame)
