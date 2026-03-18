// ═══════════════════════════════════════════════════════════════════
//  o_firefly — Create_0
//  Child of o_lb_dl_light_source (so it punches through the darkness).
//  Drifts slowly, pulses in and out, despawns off screen edges.
// ═══════════════════════════════════════════════════════════════════

event_inherited();   // creates o_lb_dl_controller if not present

// Drift direction and speed — still gentle, but a touch livelier
_drift_angle = random(360);
_drift_speed = random_range(0.35, 0.85);
_drift_wobble_t = random(pi * 2);   // phase offset so not all in sync

// Pulse timing
_pulse_period = irandom_range(70, 150);    // slightly faster, natural flicker
_pulse_t      = random(_pulse_period);     // start at random phase
_pulse_min    = random_range(0.02, 0.12);  // dim end of pulse
_pulse_max    = random_range(0.4, 0.85);   // bright end

// Visual — warm yellow-green glow
image_alpha   = 0;
image_blend   = make_color_rgb(
    180 + irandom(40),   // warm yellow-green, slight variation per fly
    220 + irandom(35),
    80  + irandom(40)
);
image_xscale  = random_range(0.75, 1.6);   // smaller fireflies
image_yscale  = image_xscale;

depth = -3999;   // just above the dl_controller
