event_inherited();

if (!instance_exists(o_enc_box)) exit;
if (!variable_struct_exists(enemy_struct, "actor_id")) exit;
var o = enemy_struct.actor_id;
if (!instance_exists(o)) exit;

// Box geometry (o_enc_box.x/.y = CENTRE)
var _bx  = o_enc_box.x;
var _by  = o_enc_box.y;
var _bhw = o_enc_box.width  * 0.5;
var _bhh = o_enc_box.height * 0.5;
var _bl  = _bx - _bhw;
var _br  = _bx + _bhw;
var _bt  = _by - _bhh;
var _bb  = _by + _bhh;

/// ─── ARC CLEAVE ──────────────────────────────────────────────────────────────
if (pattern == "sword_sweep") {
    if (timer == 6) {
        o.sword_active   = true;
        o.sword_angle    = -80 * sweep_dir;
        o.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y());
        o.depth          = o.depth_override;
        slash_count      = 0;
    }
    if (timer >= 6 && timer < 200) {
        var _t = (timer - 6) / 194.0;
        o.sword_angle = lerp(-80 * sweep_dir, 80 * sweep_dir, _t);
        if ((timer - 6) % 22 == 0 && slash_count < 7) {
            var _sx  = o.x + lengthdir_x(20, o.sword_angle);
            var _sy  = o.y + lengthdir_y(20, o.sword_angle);
            var _aim = point_direction(_sx, _sy, _bx, _by);
            // 3 bullets per slash (was 5) — still a fan, less overwhelming
            for (var _i = -1; _i <= 1; _i++) {
                var _b = instance_create_depth(_sx, _sy,
                    DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
                _b.direction   = _aim + _i * 16;
                _b.speed       = 4.5 + abs(_i) * 0.5;
                _b.image_angle = _b.direction;
            }
            slash_count++;
        }
    }
    if (timer == 218) {
        o.sword_active   = false;
        o.depth_override = undefined;
        sweep_dir        *= -1;
        instance_destroy();  // Larry done — Barry's Step_0 detects this and starts
    }
}

/// ─── SWORD STAKES ────────────────────────────────────────────────────────────
// Larry slams 4 swords into the ground at staggered intervals.
// Each stake sits visible for a moment, then fires a 3-bullet burst straight up.
// The 4 columns are evenly spread with one gap always left open.
else if (pattern == "sword_stakes") {
    // Plant one stake every 30 frames, offset across the box
    // Columns at 15%, 35%, 65%, 85% — leaving the middle 30% as breathing room
    var _cols = [0.15, 0.38, 0.62, 0.85];

    if (timer >= 10 && stake_count < 4) {
        if ((timer - 10) % 30 == 0) {
            var _sx = _bl + o_enc_box.width * _cols[stake_count];
            // Plant at bottom of box — visible as a warning marker
            var _s = instance_create_depth(_sx, _bb - 4,
                DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
            _s.speed       = 0;
            _s.image_angle = 90;   // pointing up
            _s.att         = 0;
            _s.destroy     = false;
            stake_x[stake_count]    = _sx;
            stake_inst[stake_count] = _s;
            stake_fired[stake_count] = false;
            stake_count++;
        }
    }

    // After all 4 are planted, fire each one in sequence (20 frames apart)
    if (stake_count >= 4 && !stakes_done) {
        var _fire_start = 10 + 4 * 30 + 15;   // first fire frame
        for (var _i = 0; _i < 4; _i++) {
            if (timer == _fire_start + _i * 20 && !stake_fired[_i]) {
                stake_fired[_i] = true;
                if (instance_exists(stake_inst[_i]))
                    instance_destroy(stake_inst[_i]);
                // 3-bullet burst: straight up + slight spread
                for (var _j = -1; _j <= 1; _j++) {
                    var _b = instance_create_depth(stake_x[_i], _bb - 4,
                        DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
                    _b.direction   = 90 + _j * 18;    // 90 = up in GML
                    _b.speed       = random_range(3.5, 5);
                    _b.image_angle = _b.direction;
                }
            }
        }
        if (timer == _fire_start + 4 * 20) stakes_done = true;
    }

    if (stakes_done && timer >= 10 + 4*30 + 15 + 4*20 + 30) {
        // Clean up any lingering stake visuals
        for (var _i = 0; _i < stake_count; _i++)
            if (instance_exists(stake_inst[_i])) instance_destroy(stake_inst[_i]);
        o.depth_override = undefined;
        instance_destroy();
    }
}
