// Tile the cloud sprite horizontally across the full camera width.
// We snap the draw start to the nearest sprite-width boundary to the left of
// the camera, then draw enough copies to cover the view  seamless wrap.
var _cx  = camera_get_view_x(view_camera[0]);
var _cy  = camera_get_view_y(view_camera[0]);
var _cw  = camera_get_view_width(view_camera[0]);
var _sw  = sprite_get_width(sprite_index);
var _sh  = sprite_get_height(sprite_index);

if (_sw <= 0) exit;

// Anchor the first tile so it wraps with the scroll offset
var _draw_x = x - (_sw * ceil((x - _cx) / _sw));
var _draw_y = y;

while (_draw_x < _cx + _cw) {
    draw_sprite(sprite_index, image_index, _draw_x, _draw_y);
    _draw_x += _sw;
}
