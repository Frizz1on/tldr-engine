// ═══════════════════════════════════════════════════════════════════
//  FIREFLY SPAWNER — Step_0
//  Optional: place one o_firefly_spawner in the room to keep the
//  count replenished as fireflies drift off screen.
// 
// ═══════════════════════════════════════════════════════════════════

var _current = instance_number(o_firefly);
if (_current < target_count && irandom(30) == 0) {
    var _cx = camera_get_view_x(view_camera[0]);
    var _cy = camera_get_view_y(view_camera[0]);
    var _cw = camera_get_view_width(view_camera[0]);
    var _ch = camera_get_view_height(view_camera[0]);

    // Spawn on a random screen edge so they drift inward naturally
    var _side = irandom(3);
    var _fx, _fy;
    if (_side == 0) { _fx = _cx + random(_cw);  _fy = _cy + _ch + 20; }  // bottom
    else if (_side == 1) { _fx = _cx - 20;          _fy = _cy + random(_ch); } // left
    else if (_side == 2) { _fx = _cx + _cw + 20;    _fy = _cy + random(_ch); } // right
    else                 { _fx = _cx + random(_cw);  _fy = _cy - 20; }         // top

instance_create(o_firefly, _fx, _fy, 0);

}