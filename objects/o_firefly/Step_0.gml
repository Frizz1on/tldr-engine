// ═══════════════════════════════════════════════════════════════════
//  o_firefly — Step_0
// ═══════════════════════════════════════════════════════════════════

// Drift — slow arc with gentle wobble
_drift_wobble_t += 0.018;
var _wx = cos(_drift_wobble_t) * 0.3;   // wobble offset on drift direction
x += lengthdir_x(_drift_speed, _drift_angle + _wx * 30);
y += lengthdir_y(_drift_speed, _drift_angle + _wx * 15);

// Occasionally nudge drift direction slightly
if (irandom(180) == 0)
    _drift_angle += random_range(-40, 40);

// Pulse alpha — sine wave between _pulse_min and _pulse_max
_pulse_t++;
var _pulse_lerp = (sin((_pulse_t / _pulse_period) * pi * 2) + 1) * 0.5;
image_alpha = lerp(_pulse_min, _pulse_max, _pulse_lerp);

// Destroy when well off screen and pulse is dim (clean exit)
var _cx = camera_get_view_x(view_camera[0]);
var _cy = camera_get_view_y(view_camera[0]);
var _cw = camera_get_view_width(view_camera[0]);
var _ch = camera_get_view_height(view_camera[0]);

var _margin = 80;
if (x < _cx - _margin || x > _cx + _cw + _margin
||  y < _cy - _margin || y > _cy + _ch + _margin) {
    if (image_alpha < 0.1)
        instance_destroy();
}

// Replace destroyed firefly — spawn a new one at a random screen edge
// so the total count stays roughly constant.
// Each firefly independently handles this via irandom gate.
if (irandom(300) == 0 && !instance_exists(id)) exit;  // already destroyed