var _t     = _ray_timer / ray_life;
var _alpha = 0;
if (_t < 0.3)
    _alpha = _t / 0.3;           // ramp in
else if (_t < 0.7)
    _alpha = 1;                   // hold
else
    _alpha = 1 - ((_t - 0.7) / 0.3);  // ramp out

_alpha = clamp(_alpha * 0.75, 0, 1);  // cap at 0.75 so it reads as a warning, not full red

var _ex = x + lengthdir_x(ray_length, ray_angle);
var _ey = y + lengthdir_y(ray_length, ray_angle);

draw_set_color(c_red);
draw_set_alpha(_alpha);
draw_line_width(x, y, _ex, _ey, ray_width);

// Soft glow — second wider pass at lower alpha
draw_set_alpha(_alpha * 0.3);
draw_line_width(x, y, _ex, _ey, ray_width * 3);

draw_set_alpha(1);
draw_set_color(c_white);
