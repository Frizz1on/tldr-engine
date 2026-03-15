/// @description slide wall in after 28-frame warning pause (set in Step_0 at timer == 6)
if (!instance_exists(wall_inst)) exit;

var _bl = o_enc_box.x - o_enc_box.width * 0.5;
var _br = o_enc_box.x + o_enc_box.width * 0.5;

// Wall stops at 60% across — leaves a clear 40% gap on the opposite side
var _end_x = (crush_dir > 0)
    ? _bl + o_enc_box.width * 0.60
    : _br - o_enc_box.width * 0.60;

animate(wall_inst.x, _end_x, 55, anime_curve.cubic_out, wall_inst, "x");
