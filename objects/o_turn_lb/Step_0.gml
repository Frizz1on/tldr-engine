event_inherited();

if (!instance_exists(o_enc_box)) exit;

// ── Box geometry (o_enc_box.x / .y = CENTRE) ─────────────────────────────────
var _bx  = o_enc_box.x;
var _by  = o_enc_box.y;
var _bhw = o_enc_box.width  * 0.5;
var _bhh = o_enc_box.height * 0.5;
var _bl  = _bx - _bhw;
var _br  = _bx + _bhw;
var _bt  = _by - _bhh;
var _bb  = _by + _bhh;

// ── Resolve actor references ──────────────────────────────────────────────────
var larry_struct = noone;
var berry_struct = noone;
for (var _i = 0; _i < array_length(o_enc.encounter_data.enemies); _i++) {
    if is_instanceof(o_enc.encounter_data.enemies[_i], enemy_larry)
        larry_struct = o_enc.encounter_data.enemies[_i];
    if is_instanceof(o_enc.encounter_data.enemies[_i], enemy_berry)
        berry_struct = o_enc.encounter_data.enemies[_i];
}
var lo = (larry_struct != noone && instance_exists(larry_struct.actor_id))
    ? larry_struct.actor_id : noone;
var bo = (berry_struct != noone && instance_exists(berry_struct.actor_id))
    ? berry_struct.actor_id : noone;

phase_timer++;

// ══════════════════════════════════════════════════════════════════════════════
//  PHASE 0 — LARRY'S ATTACK
// ══════════════════════════════════════════════════════════════════════════════
if (phase == 0) {
    if (!instance_exists(lo)) { phase = 1; phase_timer = 0; exit; }

    // ── ARC CLEAVE ────────────────────────────────────────────────────────────
    if (larry_pattern == "sword_sweep") {
        if (phase_timer == 6) {
            lo.sword_active   = true;
            lo.sword_angle    = -80 * sweep_dir;
            lo.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (lo.y - guipos_y());
            lo.depth          = lo.depth_override;
            slash_count       = 0;
        }
        if (phase_timer >= 6 && phase_timer < 200) {
            var _t = (phase_timer - 6) / 194;
            lo.sword_angle = lerp(-80 * sweep_dir, 80 * sweep_dir, _t);

            if ((phase_timer - 6) % 22 == 0 && slash_count < 7) {
                var _sx = lo.x + lengthdir_x(20, lo.sword_angle);
                var _sy = lo.y + lengthdir_y(20, lo.sword_angle);
                // Aim at box centre so every slash travels INTO the arena
                var _aim = point_direction(_sx, _sy, _bx, _by);
                for (var _i = -2; _i <= 2; _i++) {
                    var _inst = instance_create_depth(_sx, _sy,
                        DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
                    _inst.direction   = _aim + _i * 14;
                    _inst.speed       = 4.5 + abs(_i) * 0.4;
                    _inst.image_angle = _inst.direction;
                }
                slash_count++;
            }
        }
        if (phase_timer == 222) {
            lo.sword_active   = false;
            lo.depth_override = undefined;
            sweep_dir         *= -1;
            phase = 1; phase_timer = 0;
        }
    }

    // ── SECURITY LOCKDOWN ─────────────────────────────────────────────────────
    else if (larry_pattern == "alarm_burst") {
        if (phase_timer == 6) {
            lo.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (lo.y - guipos_y());
            lo.depth          = lo.depth_override;
            mark_count        = 0;
        }
        if (phase_timer >= 6)
            lo.buzzer_flash = max(0, sine(8, phase_timer * 0.15));

        // Warning phase — stationary markers at top edge
        if (phase_timer >= 20 && phase_timer < 70 && phase_timer % 10 == 0) {
            var _tx = random_range(_bl + 16, _br - 16);
            marker[mark_count] = _tx;
            var _warn = instance_create_depth(_tx, _bt + 4,
                DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
            _warn.speed   = 0;
            _warn.image_angle = 270;
            _warn.att     = 0;
            _warn.destroy = false;
            marker_inst[mark_count] = _warn;
            mark_count++;
        }

        // Drop phase — hang then snap
        if (phase_timer >= 80 && phase_timer < 160 && phase_timer % 8 == 0) {
            if (mark_count > 0) {
                var _idx = irandom(mark_count - 1);
                var _tx  = marker[_idx];
                if (instance_exists(marker_inst[_idx]))
                    instance_destroy(marker_inst[_idx]);
                var _drop = instance_create_depth(_tx, _bt - 2,
                    DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
                _drop.direction  = 270;
                _drop.speed      = 0;
                _drop.image_angle = 270;
                _drop.target_spd  = random_range(7, 10);
                with (_drop) alarm[0] = 20;  // o_enc_bullet Alarm_0: speed = target_spd
            }
        }

        if (phase_timer >= 180) {
            lo.buzzer_flash   = 0;
            lo.depth_override = undefined;
            for (var _i = 0; _i < mark_count; _i++)
                if (instance_exists(marker_inst[_i])) instance_destroy(marker_inst[_i]);
            mark_count = 0;
            phase = 1; phase_timer = 0;
        }
    }
}

// ══════════════════════════════════════════════════════════════════════════════
//  PHASE 1 — BERRY'S ATTACK
// ══════════════════════════════════════════════════════════════════════════════
else if (phase == 1) {
    if (!instance_exists(bo)) { instance_destroy(); exit; }

    // ── PHALANX RAIN ──────────────────────────────────────────────────────────
    if (berry_pattern == "shield_wall") {
        if (phase_timer == 6) {
            bo.shield_raise   = 2;
            bo.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (bo.y - guipos_y());
            bo.depth          = bo.depth_override;
            volley_dir        = choose(-1, 1);
            column_timer      = 0;
        }

        if (phase_timer >= 12 && phase_timer < 210) {
            column_timer++;
            // Fire rate accelerates slightly over time
            var _fire_rate = 30 - min(12, phase_timer div 40);
            if (column_timer % _fire_rate == 0) {
                // Five columns with clear gaps between them
                // Column positions: evenly spaced across the box with safe gaps
                var _gap = o_enc_box.width / 6.0;
                for (var _b = 0; _b < 5; _b++) {
                    // Skip every other column to guarantee a gap the player can stand in
                    if (_b == 2) continue;  // always leave the centre column open
                    var _spawn_x = _bl + _gap * (_b + 1);
                    var _inst = instance_create_depth(
                        _spawn_x,
                        _bt - 20,   // above top edge
                        DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
                    _inst.direction   = 270 + (_b - 2) * 5 * volley_dir;
                    _inst.speed       = 0;
                    _inst.image_angle = 270;
                    _inst.target_spd  = random_range(5, 7);
                    with (_inst) alarm[0] = 22;  // hang then snap
                }
                if (irandom(3) == 0) volley_dir *= -1;
            }
        }

        if (phase_timer >= 235) {
            bo.shield_raise   = 0;
            bo.depth_override = undefined;
            instance_destroy();
        }
    }

    // ── BULLDOZER SWEEP ───────────────────────────────────────────────────────
    else if (berry_pattern == "shield_crush") {
        if (phase_timer == 6) {
            wall_volley_row  = 0;
            bo.shield_raise  = 1;
            bo.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (bo.y - guipos_y());
            bo.depth         = bo.depth_override;

            var _start_x = (crush_dir > 0) ? _bl - 70 : _br + 70;
            wall_inst = instance_create_depth(
                _start_x, _by,   // _by = centre of box
                DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
            wall_inst.image_xscale = 3;
            wall_inst.image_yscale = 7;
            wall_inst.destroy      = false;
            wall_inst.att          = 0;
            wall_side = crush_dir;
            // Pause at edge for 28 frames then slide in via Alarm_1 on THIS object
            alarm[1] = 28;
        }

        // Alternating horizontal rows from the wall side — guaranteed gap opposite
        if (phase_timer >= 55 && phase_timer < 175 && phase_timer % 18 == 0) {
            if (!instance_exists(wall_inst)) exit;
            var _fire_dir = (wall_side > 0) ? 0 : 180;
            var _spawn_x  = (wall_side > 0) ? _bl + 2 : _br - 2;
            // 3 bullets spread across the height with deliberate vertical gaps
            for (var _r = 0; _r < 3; _r++) {
                var _row_y = _bt + 10 + _r * (o_enc_box.height * 0.33);
                var _inst = instance_create_depth(
                    _spawn_x, _row_y,
                    DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
                _inst.direction   = _fire_dir + random_range(-8, 8);
                _inst.speed       = random_range(3, 4.5);
                _inst.image_angle = _fire_dir;
            }
            wall_volley_row++;
        }

        if (phase_timer == 175 && instance_exists(wall_inst)) {
            var _retreat_x = (crush_dir > 0) ? _bl - 70 : _br + 70;
            animate(wall_inst.x, _retreat_x, 35, anime_curve.cubic_in, wall_inst, "x");
        }
        if (phase_timer == 215 && instance_exists(wall_inst))
            instance_destroy(wall_inst);

        if (phase_timer >= 240) {
            if (instance_exists(wall_inst)) instance_destroy(wall_inst);
            bo.shield_raise   = 0;
            bo.depth_override = undefined;
            crush_dir         *= -1;
            instance_destroy();
        }
    }

    // ── HALF-SCREEN FLOOD ─────────────────────────────────────────────────────
    // New attack replacing the buggy alarm_burst port.
    // Phase A (x2): red half-screen flash ticks 3 times → wave from top+bottom
    // floods that side. Repeats for opposite half.
    else if (berry_pattern == "half_flood") {
        if (phase_timer == 1) {
            flash_half  = irandom(1);  // 0 = left half, 1 = right half
            flash_alpha = 0;
            flash_tick  = 0;
            flash_phase = 0;
        }

        // ── Warning ticks (flash_phase 0): 3 red pulses on the chosen half ───
        if (flash_phase == 0) {
            // Pulse in and out 3 times over 60 frames
            flash_alpha = sine(1, phase_timer * 0.16) * 0.7;
            if (phase_timer == 62) {
                flash_alpha = 0;
                flash_phase = 1;
            }
        }

        // ── Flood (flash_phase 1): bullets from top and bottom on that half ──
        if (flash_phase == 1) {
            var _local_t = phase_timer - 63;
            var _half_x_min = (flash_half == 0) ? _bl : _bx;
            var _half_x_max = (flash_half == 0) ? _bx : _br;

            if (_local_t >= 0 && _local_t < 60 && _local_t % 6 == 0) {
                // Top-down bullets
                var _tx = random_range(_half_x_min + 4, _half_x_max - 4);
                var _top = instance_create_depth(_tx, _bt - 4,
                    DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
                _top.direction = 270; _top.speed = random_range(4, 6);
                _top.image_angle = 270;

                // Bottom-up bullets
                var _bx2 = random_range(_half_x_min + 4, _half_x_max - 4);
                var _bot = instance_create_depth(_bx2, _bb + 4,
                    DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
                _bot.direction = 90; _bot.speed = random_range(4, 6);
                _bot.image_angle = 90;
            }

            // Second pass on opposite half after a brief gap
            if (_local_t == 70) {
                flash_half  = 1 - flash_half;
                flash_alpha = 0;
                flash_phase = 2;
            }
        }

        // ── Second warning ticks on opposite half ─────────────────────────────
        if (flash_phase == 2) {
            var _local_t = phase_timer - 134;
            flash_alpha = sine(1, _local_t * 0.16) * 0.7;
            if (_local_t == 62) {
                flash_alpha = 0;
                flash_phase = 3;
            }
        }

        // ── Second flood ──────────────────────────────────────────────────────
        if (flash_phase == 3) {
            var _local_t = phase_timer - 197;
            var _half_x_min = (flash_half == 0) ? _bl : _bx;
            var _half_x_max = (flash_half == 0) ? _bx : _br;

            if (_local_t >= 0 && _local_t < 60 && _local_t % 6 == 0) {
                var _tx = random_range(_half_x_min + 4, _half_x_max - 4);
                var _top = instance_create_depth(_tx, _bt - 4,
                    DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
                _top.direction = 270; _top.speed = random_range(4, 6);
                _top.image_angle = 270;

                var _bx2 = random_range(_half_x_min + 4, _half_x_max - 4);
                var _bot = instance_create_depth(_bx2, _bb + 4,
                    DEPTH_ENCOUNTER.BULLETS_OUTSIDE, o_enc_bullet);
                _bot.direction = 90; _bot.speed = random_range(4, 6);
                _bot.image_angle = 90;
            }
        }

        if (phase_timer >= 270) {
            flash_alpha       = 0;
            bo.depth_override = undefined;
            instance_destroy();
        }
    }
}
