/// @description snap bullet to target speed after warning pause
// Used by: o_turn_lb_seq shield_wall and alarm_burst patterns
if (variable_instance_exists(id, "target_spd"))
    speed = target_spd;
