/// @description draw half-screen warning flash for half_flood attack
if (pattern != "half_flood") exit;
if (flash_alpha <= 0) exit;
if (!instance_exists(o_enc_box)) exit;

var _bx  = o_enc_box.x;
var _by  = o_enc_box.y;
var _bhw = o_enc_box.width  * 0.5;
var _bhh = o_enc_box.height * 0.5;

var _x1 = (flash_half == 0) ? (_bx - _bhw) : _bx;
var _x2 = (flash_half == 0) ? _bx           : (_bx + _bhw);
var _y1 = _by - _bhh;
var _y2 = _by + _bhh;

draw_set_color(c_red);
draw_set_alpha(flash_alpha);
draw_rectangle(_x1, _y1, _x2, _y2, false);
draw_set_alpha(1);
