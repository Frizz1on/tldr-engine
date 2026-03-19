draw_set_font(loc_font("main"));
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// Freeze frame during soul shatter
if (state == 0) {
    draw_sprite_ext(freezeframe,     0, 0, 0, 1, 1, 0, c_white, 1);
    draw_sprite_ext(freezeframe_gui, 0, 0, 0, 1, 1, 0, c_white, 1);
}

// Dim overlay after shatter
if (state >= 2) {
    draw_set_color(c_black);
    draw_set_alpha(image_alpha * 0.85);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);

    // GAME OVER title (centered, full-strength alpha as it settles in)
    var _go_scale = 2;
    var _go_w = sprite_get_width(spr_ui_gameover) * _go_scale;
    var _go_x = (_gw - _go_w) * 0.5;
    var _go_y = 40;
    var _go_alpha = clamp(image_alpha * 1.25, 0, 1);
    draw_sprite_ext(spr_ui_gameover, 0, _go_x, _go_y, _go_scale, _go_scale, 0, c_white, _go_alpha);
}

// Eye — visible from state 3 onward
if (state >= 3 && eye_alpha > 0) {
    var _ew = 44 * eye_xscale;
    var _eh = 20 * eye_yscale;
    var _ex = eye_x + eye_twitch;
    var _ey = eye_y;

    draw_set_color(c_white);
    draw_set_alpha(eye_alpha);
    draw_ellipse(_ex - _ew, _ey - _eh, _ex + _ew, _ey + _eh, false);

    // Pupil
    draw_set_color(c_black);
    draw_ellipse(_ex - 9, _ey - 9, _ex + 9, _ey + 9, false);
    draw_set_color(c_white);
    draw_set_alpha(1);
}

// Choice UI
if (state == 4 || state == 5) {
    draw_set_alpha(ui_alpha);
    if (selection == 0) draw_set_color(c_yellow); else draw_set_color(c_white);
    draw_text_transformed(160, 360, choice[0], 2, 2, 0);
    if (selection == 1) draw_set_color(c_yellow); else draw_set_color(c_white);
    draw_text_transformed(380, 360, choice[1], 2, 2, 0);
    draw_set_color(c_white);

    // Soul cursor
    draw_set_alpha(ui_alpha * 0.5);
    draw_sprite_ext(spr_ui_soul_blur, 0, soulx, souly, 2, 2, 0, c_white, 1);
    draw_set_alpha(1);
}

// Fader
draw_sprite_ext(spr_pixel, 0, 0, 0, 640, 480, 0, c_white, fader_alpha);

// Reset draw state for anything rendered after this event
draw_set_color(c_white);
draw_set_alpha(1);
