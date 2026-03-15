event_inherited();
if (!instance_exists(o_enc_box)) exit;
if (!variable_struct_exists(enemy_struct, "actor_id")) exit;

var o = enemy_struct.actor_id;
if (!instance_exists(o)) exit;
if (!instance_exists(o_enc_soul)) exit;

var _bx  = o_enc_box.x;
var _by  = o_enc_box.y;
var _bhw = o_enc_box.width  * 0.5;
var _bhh = o_enc_box.height * 0.5;
var _bl  = _bx - _bhw;
var _br  = _bx + _bhw;
var _bt  = _by - _bhh;
var _bb  = _by + _bhh;

var _lock_times = [18, 52, 86];

if (pattern == "laser_lock") {
    if (timer == 1) {
        o.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y());
        o.depth = o.depth_override;
    }

    for (var _i = 0; _i < array_length(_lock_times); _i++) {
        var _t_warn = _lock_times[_i];
        var _t_fire = _t_warn + 14;

        if (timer == _t_warn) {
            lock_x = clamp(o_enc_soul.x, _bl + 24, _br - 24);
            var _w = instance_create_depth(lock_x, _bt + 8,
                DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
            _w.speed = 0;
            _w.att = 0;
            _w.destroy = false;
            _w.image_xscale = 0.7;
            _w.image_yscale = 0.7;
        }

        if (timer == _t_fire) {
            for (var _s = -2; _s <= 2; _s++) {
                var _b = instance_create_depth(lock_x + _s * 11, _bt - 4,
                    DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
                _b.direction   = 270;
                _b.speed       = 5 + abs(_s) * 0.25;
                _b.image_angle = 270;
            }
        }
    }

    if (timer >= 124) {
        o.depth_override = undefined;
        instance_destroy();
    }
}
else if (pattern == "ping_cross") {
    if (timer == 1) {
        o.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y());
        o.depth = o.depth_override;
    }

    if (timer == 16 || timer == 44 || timer == 72) {
        var _aim_l = point_direction(_bl - 8, _by, o_enc_soul.x, o_enc_soul.y);
        var _aim_r = point_direction(_br + 8, _by, o_enc_soul.x, o_enc_soul.y);

        var _wl = instance_create_depth(_bl + 6, _by, DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
        _wl.speed = 0; _wl.att = 0; _wl.destroy = false;
        _wl.image_angle = _aim_l;

        var _wr = instance_create_depth(_br - 6, _by, DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
        _wr.speed = 0; _wr.att = 0; _wr.destroy = false;
        _wr.image_angle = _aim_r;
    }

    if (timer == 28 || timer == 56 || timer == 84) {
        var _aim_l2 = point_direction(_bl - 8, _by, o_enc_soul.x, o_enc_soul.y);
        var _aim_r2 = point_direction(_br + 8, _by, o_enc_soul.x, o_enc_soul.y);

        for (var _k = -1; _k <= 1; _k++) {
            var _blt = instance_create_depth(_bl - 8, _by + _k * 10,
                DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
            _blt.direction   = _aim_l2 + _k * 8;
            _blt.speed       = 3.7;
            _blt.image_angle = _blt.direction;

            var _brt = instance_create_depth(_br + 8, _by + _k * 10,
                DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
            _brt.direction   = _aim_r2 - _k * 8;
            _brt.speed       = 3.7;
            _brt.image_angle = _brt.direction;
        }
    }

    if (timer >= 104) {
        o.depth_override = undefined;
        instance_destroy();
    }
}
