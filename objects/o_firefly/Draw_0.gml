// ═══════════════════════════════════════════════════════════════════
//  o_firefly — Draw_0
//  Uses a soft glowing circle rather than a sprite.
//  If you have a dedicated glow sprite assign it to sprite_index
//  in Create_0 instead and delete this Draw event entirely.
// ═══════════════════════════════════════════════════════════════════

var _r = 4 * image_xscale;

// Outer soft glow
draw_set_color(image_blend);
draw_set_alpha(image_alpha * 0.25);
draw_circle(x, y, _r * 2.5, false);

// Inner bright core
draw_set_alpha(image_alpha * 0.85);
draw_circle(x, y, _r * 0.8, false);

draw_set_alpha(1);
draw_set_color(c_white);