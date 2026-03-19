draw_set_font(loc_font("main"));
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// Freeze frame
if (state == 0) {
    draw_sprite_ext(freezeframe,     0, 0, 0, 1, 1, 0, c_white, 1);
    draw_sprite_ext(freezeframe_gui, 0, 0, 0, 1, 1, 0, c_white, 1);
}

// Dim overlay
if (state >= 2) {
    draw_set_color(c_black);
    draw_set_alpha(min(image_alpha * 0.85, 0.85));
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
}

// Eye
if (state >= 3 && eye_alpha > 0) {
    var _ew = 44 * eye_xscale;
    var _eh = 20 * eye_yscale;
    var _ex = _gw * 0.5 + eye_twitch;
    var _ey = _gh * 0.38;
    draw_set_color(c_white);
    draw_set_alpha(eye_alpha);
    draw_ellipse(_ex - _ew, _ey - _eh, _ex + _ew, _ey + _eh, false);
    draw_set_color(c_black);
    draw_ellipse(_ex - 9, _ey - 9, _ex + 9, _ey + 9, false);
    draw_set_color(c_white);
    draw_set_alpha(1);
}

// Choice UI — bottom centre, text_typer dialogue remains visible above it
if (state == 4 || (state == 5 && timer <= 1)) {
    var _cy      = _gh - 80;           // bottom area
    var _cx      = _gw * 0.5;
    var _gap     = 40;
    var _ta      = choice[0];
    var _tb      = choice[1];
    var _ta_w    = string_width(_ta) * 2;
    var _tb_w    = string_width(_tb) * 2;

    draw_set_alpha(ui_alpha);

    // RETURN — left of centre
    if (selection == 0) draw_set_color(c_yellow); else draw_set_color(c_white);
    draw_text_transformed(_cx - _gap - _ta_w, _cy, _ta, 2, 2, 0);

    // GIVE UP — right of centre
    if (selection == 1) draw_set_color(c_yellow); else draw_set_color(c_white);
    draw_text_transformed(_cx + _gap, _cy, _tb, 2, 2, 0);

    draw_set_color(c_white);

    // Soul cursor above selected option
    var _soul_x = (selection == 0)
        ? (_cx - _gap - _ta_w * 0.5)
        : (_cx + _gap + _tb_w * 0.5);
    draw_set_alpha(ui_alpha * 0.6);
    draw_sprite_ext(spr_ui_soul_blur, 0, _soul_x, _cy - 18, 2, 2, 0, c_white, 1);
    draw_set_alpha(1);
}

// Fader
if (fader_alpha > 0) {
    draw_set_color(c_white);
    draw_set_alpha(fader_alpha);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
}

draw_set_color(c_white);
draw_set_alpha(1);