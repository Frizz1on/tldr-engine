// ═══════════════════════════════════════════════════════════════════
//  TWILIGHT EFFECT — Room Start code
//  Place in the sky town night rooms' Room Start.
//  Controls:
//    twilight_darkness  0.0–1.0  how dark the overlay is (0.55 = dusk)
//    firefly_count      how many fireflies to spawn
// ═══════════════════════════════════════════════════════════════════
var _twilight_col = make_color_rgb(20, 18, 45);
var _tint_alpha   = 0.35;   // how strongly the blue tint shows on characters


// ── Darkness overlay ─────────────────────────────────────────────
if (!instance_exists(o_eff_lighting_controller))
    instance_create(o_eff_lighting_controller);

with (o_eff_lighting_controller) {
    lighting_override = true;
    lighting_alpha    = 0;                           // start transparent
    lighting_darken   = 0.7;                         // how much geometry darkens
    color             = make_color_rgb(20, 18, 45);  // deep blue-purple twilight tint
    fade_mode         = [bm_zero, bm_src_colour];
    under_lighting    = true;

    // Fade the overlay in over ~3 seconds
    animate(0, 0.55, 180, anime_curve.linear, id, "lighting_alpha");
}
// ── Spawn fireflies ───────────────────────────────────────────────
var _firefly_count = 18;
var _cx = camera_get_view_x(view_camera[0]);
var _cy = camera_get_view_y(view_camera[0]);
var _cw = camera_get_view_width(view_camera[0]);
var _ch = camera_get_view_height(view_camera[0]);

for (var _i = 0; _i < array_length(global.party_names); _i++) {
    var _inst = party_get_inst(global.party_names[_i]);
    if (!instance_exists(_inst)) continue;
    // Blend the sprite toward the twilight colour
    // image_blend multiplies the sprite's colours — merging toward the tint
    animate(_inst.image_blend, _twilight_col, 180, anime_curve.linear, _inst, "image_blend");
}

for (var _i = 0; _i < _firefly_count; _i++) {
    instance_create(
        o_firefly,
        _cx + random(_cw * 1.5) - _cw * 0.25,
        _cy + random(_ch * 1.2) - _ch * 0.1,
        0
    );
}