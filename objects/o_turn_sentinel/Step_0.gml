event_inherited();
if (!instance_exists(o_enc_box)) exit;
if (!variable_struct_exists(enemy_struct, "actor_id")) exit;
var o = enemy_struct.actor_id;
if (!instance_exists(o)) exit;

var _bx  = o_enc_box.x;
var _by  = o_enc_box.y;
var _bhw = o_enc_box.width  * 0.5;
var _bhh = o_enc_box.height * 0.5;
var _bl  = _bx - _bhw;
var _br  = _bx + _bhw;
var _bt  = _by - _bhh;
var _bb  = _by + _bhh;

/// LASER SWEEP — 3 horizontal laser lines sweep top to bottom
if (pattern == "laser_sweep") {
    if (timer == 1) {
        o.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y());
        o.depth = o.depth_override;
    }
    // Fire 3 lasers staggered across the box height, sweeping downward
    var _offsets = [-0.25, 0, 0.25];
    for (var _li = 0; _li < 3; _li++) {
        var _fire_t = 20 + _li * 28;
        if (timer == _fire_t) {
            var _ly = _by + o_enc_box.height * _offsets[_li];
            // Warning marker first
            var _warn = instance_create_depth(_bl + 2, _ly,
                DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
            _warn.speed = 0; _warn.att = 0; _warn.destroy = false;
            _warn.image_xscale = 0.5;
            alarm[_li] = 22;   // Alarm 0/1/2 fire the real laser
        }
    }
    if (timer >= 130) {
        o.depth_override = undefined;
        instance_destroy();
    }
}

/// PING BURST — 2 fast bullets aimed at the soul (group-safe, short)
else if (pattern == "ping_burst") {
    if (timer == 1) {
        o.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y());
        o.depth = o.depth_override;
    }
    if (timer == 15 || timer == 45) {
        if (instance_exists(o_enc_soul)) {
            var _aim = point_direction(o.x, o.y, o_enc_soul.x, o_enc_soul.y);
            for (var _i = -1; _i <= 1; _i += 2) {
                var _b = instance_create_depth(o.x, o.y,
                    DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
                _b.direction   = _aim + _i * 20;
                _b.speed       = random_range(3, 4.5);
                _b.image_angle = _b.direction;
            }
        }
    }
    if (timer >= 80) {
        o.depth_override = undefined;
        instance_destroy();
    }
}