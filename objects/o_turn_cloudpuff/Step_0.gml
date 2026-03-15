event_inherited();
if (!instance_exists(o_enc_box)) exit;
if (!variable_struct_exists(enemy_struct, "actor_id")) exit;
var o = enemy_struct.actor_id;
if (!instance_exists(o)) exit;

var _bx  = o_enc_box.x;
var _by  = o_enc_box.y;

/// GUST RINGS — 3 rings of bullets expanding outward from box centre
if (pattern == "gust_rings") {
    if (timer == 1) {
        o.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y());
        o.depth = o.depth_override;
        ring_count = 0;
    }
    // Fire a ring of 6 bullets every 35 frames, 3 times total
    if (timer == 20 || timer == 55 || timer == 90) {
        var _ring_bullets = 6;
        for (var _i = 0; _i < _ring_bullets; _i++) {
            var _ang = (_i / _ring_bullets) * 360;
            var _b = instance_create_depth(_bx, _by,
                DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
            _b.direction   = _ang;
            _b.speed       = random_range(2.5, 3.5);
            _b.image_angle = _ang;
        }
        ring_count++;
    }
    if (timer >= 140) {
        o.depth_override = undefined;
        instance_destroy();
    }
}

/// LIGHT GUST — one small ring of 4 bullets (group-safe)
else if (pattern == "light_gust") {
    if (timer == 1) {
        o.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y());
        o.depth = o.depth_override;
    }
    if (timer == 25) {
        for (var _i = 0; _i < 4; _i++) {
            var _ang = (_i / 4) * 360 + 45;
            var _b = instance_create_depth(_bx, _by,
                DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
            _b.direction   = _ang;
            _b.speed       = random_range(2, 3);
            _b.image_angle = _ang;
        }
    }
    if (timer >= 80) {
        o.depth_override = undefined;
        instance_destroy();
    }
}