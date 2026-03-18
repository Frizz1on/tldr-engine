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

/// THORN WAVE
if (pattern == "thorn_wave") {
    if (timer == 1) {
        o.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y());
        o.depth = o.depth_override;
        wave_shift = 0;
        warn_insts = [];
    }
    if (timer >= 20 && timer <= 136) {
        var _local = (timer - 20) mod 24;
        if (_local == 0) {
            // Clean up previous wave's warning markers before placing new ones
            for (var _r = 0; _r < array_length(warn_insts); _r++)
                if (instance_exists(warn_insts[_r])) instance_destroy(warn_insts[_r]);
            warn_insts = [];
            wave_xs = [];
            wave_shift += random_range(-10, 10);
            var _cols = 5;
            var _gap_col = 0;
            var _gap_dist = infinity;
            for (var _i = 0; _i < _cols; _i++) {
                var _cx = _bl + o_enc_box.width * ((_i + 0.5) / _cols) + wave_shift;
                _cx = clamp(_cx, _bl + 12, _br - 12);
                var _d = abs(_cx - o_enc_soul.x);
                if (_d < _gap_dist) { _gap_dist = _d; _gap_col = _i; }
            }
            for (var _i = 0; _i < _cols; _i++) {
                if (_i == _gap_col) continue;
                var _x = _bl + o_enc_box.width * ((_i + 0.5) / _cols) + wave_shift;
                _x = clamp(_x, _bl + 12, _br - 12);
                array_push(wave_xs, _x);
                var _w = instance_create_depth(_x, _bb + 8,
                    DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
                _w.speed = 0; _w.att = 0; _w.destroy = false;
                _w.image_xscale = 0.55; _w.image_yscale = 0.55;
                array_push(warn_insts, _w);
            }
        }
        if (_local == 12) {
            // Destroy warning markers when the real bullets fire
            for (var _r = 0; _r < array_length(warn_insts); _r++)
                if (instance_exists(warn_insts[_r])) instance_destroy(warn_insts[_r]);
            warn_insts = [];
            for (var _j = 0; _j < array_length(wave_xs); _j++) {
                var _b = instance_create_depth(wave_xs[_j], _bb + 8,
                    DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
                _b.direction = 90; _b.speed = 4.1; _b.image_angle = 90;
            }
        }
    }
    if (timer > 154) {
        for (var _r = 0; _r < array_length(warn_insts); _r++)
            if (instance_exists(warn_insts[_r])) instance_destroy(warn_insts[_r]);
        o.depth_override = undefined;
        instance_destroy();
    }
}

/// THORN SNIPER
else if (pattern == "thorn_sniper") {
    if (timer == 1) {
        o.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y());
        o.depth = o.depth_override;
        warn_insts = [];
    }
    if (timer == 26 || timer == 62 || timer == 98) {
        var _px = o_enc_soul.x + o_enc_soul.hspeed * 10;
        var _py = o_enc_soul.y + o_enc_soul.vspeed * 10;
        sniper_aim = point_direction(o.x, o.y, _px, _py);
        var _warn = instance_create_depth(o.x, o.y,
            DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
        _warn.speed = 0; _warn.att = 0; _warn.destroy = false;
        _warn.image_xscale = 0.7; _warn.image_yscale = 0.7;
        _warn.image_angle = sniper_aim;
        array_push(warn_insts, _warn);
        var _ray = instance_create_depth(o.x, o.y,
            DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet_raycast);
        _ray.ray_angle  = sniper_aim;
        _ray.ray_length = 320;
        _ray.ray_life   = 12;
        _ray.ray_width  = 1.5;
        array_push(sniper_rays, _ray);
    }
    if (timer == 38 || timer == 74 || timer == 110) {
        for (var _r = 0; _r < array_length(warn_insts); _r++)
            if (instance_exists(warn_insts[_r])) instance_destroy(warn_insts[_r]);
        warn_insts = [];
        for (var _r = 0; _r < array_length(sniper_rays); _r++)
            if (instance_exists(sniper_rays[_r])) instance_destroy(sniper_rays[_r]);
        sniper_rays = [];
        for (var _k = -1; _k <= 1; _k++) {
            var _b2 = instance_create_depth(o.x, o.y,
                DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
            _b2.direction = sniper_aim + _k * 9;
            _b2.speed = 4.5;
            _b2.image_angle = _b2.direction;
        }
    }
    if (timer > 138) {
        for (var _r = 0; _r < array_length(warn_insts); _r++)
            if (instance_exists(warn_insts[_r])) instance_destroy(warn_insts[_r]);
        for (var _r = 0; _r < array_length(sniper_rays); _r++)
            if (instance_exists(sniper_rays[_r])) instance_destroy(sniper_rays[_r]);
        o.depth_override = undefined;
        instance_destroy();
    }
}

/// THORN BLOOM
else if (pattern == "thorn_bloom") {
    if (timer == 1) {
        o.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y());
        o.depth = o.depth_override;
        warn_insts = [];
    }
    if (timer == 24 || timer == 62 || timer == 100) {
        bloom_x = clamp(o_enc_soul.x + random_range(-24, 24), _bl + 24, _br - 24);
        bloom_y = clamp(o_enc_soul.y + random_range(-24, 24), _bt + 24, _bb - 24);
        var _warn2 = instance_create_depth(bloom_x, bloom_y,
            DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
        _warn2.speed = 0; _warn2.att = 0; _warn2.destroy = false;
        _warn2.image_xscale = 0.8; _warn2.image_yscale = 0.8;
        array_push(warn_insts, _warn2);
    }
    if (timer == 36 || timer == 74 || timer == 112) {
        for (var _r = 0; _r < array_length(warn_insts); _r++)
            if (instance_exists(warn_insts[_r])) instance_destroy(warn_insts[_r]);
        warn_insts = [];
        for (var _n = 0; _n < 10; _n++) {
            var _dir = _n * 36;
            var _b3 = instance_create_depth(bloom_x, bloom_y,
                DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
            _b3.direction = _dir; _b3.speed = 3.6; _b3.image_angle = _dir;
        }
    }
    if (timer > 140) {
        for (var _r = 0; _r < array_length(warn_insts); _r++)
            if (instance_exists(warn_insts[_r])) instance_destroy(warn_insts[_r]);
        o.depth_override = undefined;
        instance_destroy();
    }
}