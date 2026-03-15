var _cx  = camera_get_view_x(view_camera[0]);
var _cy  = camera_get_view_y(view_camera[0]);
var _cw  = camera_get_view_width(view_camera[0]);
var _sw  = sprite_get_width(sprite_index);

if (_sw <= 0) exit;

var _draw_x = x - (_sw * ceil((x - _cx) / _sw));
var _draw_y  = y;

while (_draw_x < _cx + _cw) {
    draw_sprite(sprite_index, image_index, _draw_x, _draw_y);
    _draw_x += _sw;
}
