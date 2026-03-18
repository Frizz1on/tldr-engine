/// @description self-destruct timer for warning bullets, OR speed snap for hang-then-snap bullets
// For warning bullets: with (warn_inst) alarm[0] = warn_window_frames;
// For speed-snap bullets: inst.target_spd = N; with (inst) alarm[0] = delay;
if (variable_instance_exists(id, "target_spd"))
    speed = target_spd;
else
    instance_destroy();  // warning bullet cleanup
