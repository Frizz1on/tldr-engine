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

if (pattern == "gust_hunt") {
    if (timer == 1) {
        o.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y());
        o.depth = o.depth_override;
    }

    var _warn_times = [20, 52, 84];
    for (var _i = 0; _i < array_length(_warn_times); _i++) {
        var _tw = _warn_times[_i];
        var _tf = _tw + 12;

        if (timer == _tw) {
            var _side = choose(0, 1, 2, 3);
            if (_side == 0) {
                warn_x = _bl - 10;
                warn_y = clamp(o_enc_soul.y, _bt + 20, _bb - 20);
            } else if (_side == 1) {
                warn_x = _br + 10;
                warn_y = clamp(o_enc_soul.y, _bt + 20, _bb - 20);
            } else if (_side == 2) {
                warn_x = clamp(o_enc_soul.x, _bl + 20, _br - 20);
                warn_y = _bt - 10;
            } else {
                warn_x = clamp(o_enc_soul.x, _bl + 20, _br - 20);
                warn_y = _bb + 10;
            }

            var _warn = instance_create_depth(warn_x, warn_y,
                DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
            _warn.speed = 0;
            _warn.att = 0;
            _warn.destroy = false;
            _warn.image_xscale = 0.6;
            _warn.image_yscale = 0.6;
        }

        if (timer == _tf) {
            var _aim = point_direction(warn_x, warn_y, o_enc_soul.x, o_enc_soul.y);
            for (var _s = -1; _s <= 1; _s++) {
                var _b = instance_create_depth(warn_x, warn_y,
                    DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
                _b.direction   = _aim + _s * 10;
                _b.speed       = 3.8 + (_i * 0.2);
                _b.image_angle = _b.direction;
            }
        }
    }

    if (timer >= 118) {
        o.depth_override = undefined;
        instance_destroy();
    }
}
else if (pattern == "light_gust") {
    if (timer == 1) {
        o.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y());
        o.depth = o.depth_override;
    }

    if (timer == 24 || timer == 56) {
        warn_x = clamp(o_enc_soul.x, _bl + 24, _br - 24);
        warn_y = clamp(o_enc_soul.y, _bt + 24, _bb - 24);
        var _w = instance_create_depth(warn_x, warn_y,
            DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
        _w.speed = 0;
        _w.att = 0;
        _w.destroy = false;
        _w.image_xscale = 0.7;
        _w.image_yscale = 0.7;
    }

    if (timer == 36 || timer == 68) {
        for (var _i2 = 0; _i2 < 6; _i2++) {
            var _ang = (_i2 / 6) * 360;
            var _b2 = instance_create_depth(warn_x, warn_y,
                DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
            _b2.direction   = _ang;
            _b2.speed       = 3;
            _b2.image_angle = _ang;
        }
    }

    if (timer >= 88) {
        o.depth_override = undefined;
        instance_destroy();
    }
}
