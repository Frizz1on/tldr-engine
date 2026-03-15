event_inherited();

if (!instance_exists(o_enc_box)) exit;
if (!variable_struct_exists(enemy_struct, "actor_id")) exit;
var o = enemy_struct.actor_id;
if (!instance_exists(o)) exit;

// o_enc_box.x/.y = CENTRE of the box
var _bx  = o_enc_box.x;
var _by  = o_enc_box.y;
var _bhw = o_enc_box.width  * 0.5;
var _bhh = o_enc_box.height * 0.5;
var _bl  = _bx - _bhw;
var _br  = _bx + _bhw;
var _bt  = _by - _bhh;
var _bb  = _by + _bhh;

/// PHALANX RAIN
if (pattern == "shield_wall") {
    if (timer == 6) {
        o.shield_raise   = 2;
        o.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y());
        o.depth          = o.depth_override;
        volley_dir       = choose(-1, 1);  // +1 = fire left-to-right, -1 = right-to-left
        column_timer     = 0;
    }

    if (timer >= 12 && timer < 210) {
        column_timer++;
        // Fire rate starts slow and tightens slightly over time
        var _fire_rate = 28 - min(8, timer div 55);
        if (column_timer % _fire_rate == 0) {
            var _volley = column_timer div _fire_rate;

            // Alternating Y positions — two rows offset by half the spacing.
            // This produces the zigzag ladder in the diagram:
            //   even volleys:  upper row  (~33% down the box)
            //   odd  volleys:  lower row  (~67% down the box)
            // The player moves up/down to thread between them.
            var _row_y = (_volley mod 2 == 0)
                ? _bt + o_enc_box.height * 0.33
                : _bt + o_enc_box.height * 0.67;

            // Spawn just outside the edge the attack fires from
            var _spawn_x = (volley_dir > 0) ? _bl - 8 : _br + 8;
            var _dir     = (volley_dir > 0) ? 0 : 180;   // 0 = right, 180 = left

            var _b = instance_create_depth(_spawn_x, _row_y,
                DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
            _b.direction   = _dir;
            _b.speed       = random_range(3.5, 5);
            _b.image_angle = _dir;

            // Flip firing side every 8 volleys so the attack doesn't always come from one side
            if (_volley > 0 && _volley mod 8 == 0) volley_dir *= -1;
        }
    }

    if (timer >= 230) {
        o.shield_raise   = 0;
        o.depth_override = undefined;
        instance_destroy();
    }
}

/// BULLDOZER SWEEP
else if (pattern == "shield_crush") {
    if (timer == 6) {
        wall_volley_row  = 0;
        o.shield_raise   = 1;
        o.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y());
        o.depth          = o.depth_override;
        var _start_x = (crush_dir > 0) ? _bl - 70 : _br + 70;
        wall_inst = instance_create_depth(
            _start_x, _by,
            DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
        wall_inst.image_xscale = 3;
        wall_inst.image_yscale = 7;
        wall_inst.destroy      = false;
        wall_inst.att          = 0;
        wall_side = crush_dir;
        alarm[1] = 28;
    }
    if (timer >= 55 && timer < 175 && timer % 20 == 0) {
        if (!instance_exists(wall_inst)) exit;
        var _fire_dir = (wall_side > 0) ? 0 : 180;
        var _spawn_x  = (wall_side > 0) ? _bl + 2 : _br - 2;
        for (var _r = 0; _r < 3; _r++) {
            if (_r == 1 && (wall_volley_row mod 2 == 0)) continue;
            var _ry = _bt + 10 + _r * (_bhh * 0.85);
            var _b  = instance_create_depth(_spawn_x, _ry,
                DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
            _b.direction   = _fire_dir + random_range(-6, 6);
            _b.speed       = random_range(3, 4);
            _b.image_angle = _fire_dir;
        }
        wall_volley_row++;
    }
    if (timer == 175 && instance_exists(wall_inst)) {
        var _retreat_x = (crush_dir > 0) ? _bl - 70 : _br + 70;
        animate(wall_inst.x, _retreat_x, 35, anime_curve.cubic_in, wall_inst, "x");
    }
    if (timer == 215 && instance_exists(wall_inst))
        instance_destroy(wall_inst);
    if (timer >= 240) {
        if (instance_exists(wall_inst)) instance_destroy(wall_inst);
        o.shield_raise   = 0;
        o.depth_override = undefined;
        crush_dir        *= -1;
        instance_destroy();
    }
}

/// HALF FLOOD (solo only — Other_12 prevents this when Larry is alive)
else if (pattern == "half_flood") {
    if (timer == 1) {
        flash_half  = irandom(1);
        flash_alpha = 0;
        flash_phase = 0;
        o.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y());
        o.depth          = o.depth_override;
    }
    if (flash_phase == 0 || flash_phase == 2) {
        var _base_t = (flash_phase == 0) ? timer : timer - 135;
        flash_alpha = max(0, sine(1, _base_t * 0.16)) * 0.65;
        if (timer == ((flash_phase == 0) ? 62 : 197)) { flash_alpha = 0; flash_phase++; }
    }
    if (flash_phase == 1 || flash_phase == 3) {
        var _base_t = (flash_phase == 1) ? timer - 63 : timer - 198;
        var _hx_min = (flash_half == 0) ? _bl : _bx;
        var _hx_max = (flash_half == 0) ? _bx : _br;
        if (_base_t >= 0 && _base_t < 55 && _base_t % 10 == 0) {
            for (var _k = 0; _k < 2; _k++) {
                var _b1 = instance_create_depth(
                    random_range(_hx_min + 6, _hx_max - 6), _bt - 4,
                    DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
                _b1.direction = 270; _b1.speed = random_range(3.5, 5.5);
                _b1.image_angle = 270;
                var _b2 = instance_create_depth(
                    random_range(_hx_min + 6, _hx_max - 6), _bb + 4,
                    DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
                _b2.direction = 90; _b2.speed = random_range(3.5, 5.5);
                _b2.image_angle = 90;
            }
        }
        if (timer == ((flash_phase == 1) ? 133 : 268)) {
            flash_half  = 1 - flash_half;
            flash_alpha = 0;
            flash_phase = (flash_phase == 1) ? 2 : 4;
        }
    }
    if (flash_phase == 4 || timer >= 280) {
        flash_alpha      = 0;
        o.depth_override = undefined;
        instance_destroy();
    }
}
