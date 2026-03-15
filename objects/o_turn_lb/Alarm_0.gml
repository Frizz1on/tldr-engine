/// @description slide Berry's wall in after warning pause
event_inherited();
if (!instance_exists(wall_inst)) exit;

var _bl = o_enc_box.x - o_enc_box.width * 0.5;
var _br = o_enc_box.x + o_enc_box.width * 0.5;

// Stop at 65% across — leaves a 35% gap on the opposite side for the player
var _end_x = (crush_dir > 0)
    ? _bl + o_enc_box.width * 0.65
    : _br - o_enc_box.width * 0.65;

animate(wall_inst.x, _end_x, 60, anime_curve.cubic_out, wall_inst, "x");
