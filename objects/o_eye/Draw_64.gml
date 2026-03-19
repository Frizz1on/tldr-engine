var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// Background fill
draw_set_color(bg_color);
draw_set_alpha(1);
draw_rectangle(0, 0, _gw, _gh, false);

// FLOOD STATE: draw all flood lines
if (state == EYE_STATE.FLOOD || state == EYE_STATE.BLACKOUT) {
    draw_set_font(loc_font("main"));
    for (var _i = 0; _i < array_length(flood_lines); _i++) {
        var _fl = flood_lines[_i];
        draw_set_color(_fl.col);
        draw_set_alpha(_fl.alpha);
        var _tw = string_width(_fl.text) * _fl.scale;
        draw_text_transformed(
            _fl.x - _tw * 0.5,
            _fl.y,
            _fl.text,
            _fl.scale, _fl.scale,
            _fl.rot
        );
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
    exit;
}

// EYE
if (eye_alpha > 0) {
    draw_set_color(fg_color);
    draw_set_alpha(eye_alpha);
    var _ew = 48 * eye_xscale;
    var _eh = 22 * eye_yscale;
    var _ex = eye_x + eye_twitch;
    var _ey = eye_y;
    draw_ellipse(_ex - _ew, _ey - _eh, _ex + _ew, _ey + _eh, false);
    draw_set_color(bg_color);
    draw_set_alpha(eye_alpha);
    draw_ellipse(_ex - 10, _ey - 10, _ex + 10, _ey + 10, false);
    draw_set_color(fg_color);
}

// MAIN LINE TEXT
var _ly = 200;
if (variable_instance_exists(id, "line_y") && is_real(line_y))
    _ly = line_y;
if (variable_instance_exists(id, "line_text")
&&  is_string(line_text)
&&  string_length(line_text) > 0
&&  variable_instance_exists(id, "line_alpha")
&&  line_alpha > 0) {
    draw_set_font(loc_font("main"));
    draw_set_color(fg_color);
    draw_set_alpha(line_alpha);
    var _tw = string_width(line_text);
    draw_text(_gw * 0.5 - _tw * 0.5, _ly, line_text);
}

// YES / NO CHOICE
if (variable_instance_exists(id, "choice_visible") && choice_visible) {
    draw_set_font(loc_font("main"));
    var _cy = _ly + 40;
    var _ax = _gw * 0.5 - 70;
    var _bx = _gw * 0.5 + 30;

    draw_set_color(fg_color);
    draw_set_alpha((choice_selection == 0) ? 1 : 0.35);
    draw_text(_ax, _cy, choice_label_a);

    draw_set_alpha((choice_selection == 1) ? 1 : 0.35);
    draw_text(_bx, _cy, choice_label_b);

    draw_set_alpha(1);
    var _sx = (choice_selection == 0)
        ? (_ax + string_width(choice_label_a) * 0.5)
        : (_bx + string_width(choice_label_b) * 0.5);
    draw_ellipse(_sx - 4, _cy - 14, _sx + 4, _cy - 6, false);
}

// TEXT INPUT
if (variable_instance_exists(id, "input_active") && input_active) {
    draw_set_font(loc_font("main"));
    draw_set_color(fg_color);

    var _cursor  = (state_timer mod 40 < 20) ? "|" : "";
    var _disp    = input_string + _cursor;
    var _tw      = string_width(_disp);

    draw_set_alpha(1);
    draw_text(_gw * 0.5 - _tw * 0.5, _ly + 36, _disp);

    if (variable_instance_exists(id, "input_hint") && is_string(input_hint) && string_length(input_hint) > 0) {
        draw_set_alpha(0.55);
        draw_text(_gw * 0.5 - string_width(input_hint) * 0.5, _ly + 62, input_hint);
    }

    if (variable_instance_exists(id, "state") && state == EYE_STATE.Q_REFUSAL) {
        draw_set_alpha(0.4);
        var _sub = "They will not hear.";
        draw_text(_gw * 0.5 - string_width(_sub) * 0.5, _ly + 84, _sub);
    }
}

if (variable_instance_exists(id, "codename_active") && codename_active) {
    draw_set_font(loc_font("main"));

    var _gw  = display_get_gui_width();
    var _kx  = 80;    // keyboard left edge
    var _ky  = 250;   // keyboard top edge
    var _spx = 26;    // horizontal spacing
    var _spy = 32;    // vertical spacing

    // Draw entered name
    draw_set_color(fg_color);
    draw_set_alpha(1);
    var _name_disp = codename_string + ((state_timer mod 40 < 20) ? "_" : "");
    var _nw = string_width(_name_disp) * 2;
    draw_text_transformed(_gw * 0.5 - _nw * 0.5, 210, _name_disp, 2, 2, 0);

    // Draw keyboard rows
    for (var _r = 0; _r < array_length(codename_keyboard); _r++) {
        var _row = codename_keyboard[_r];
        for (var _c = 0; _c < array_length(_row); _c++) {
            var _kkey   = _row[_c];
            var _kx_pos = _kx + _c * _spx;
            var _ky_pos = _ky + _r * _spy;
            var _sel    = (_r == codename_row && _c == codename_col);

            draw_set_color(fg_color);
            draw_set_alpha(_sel ? 1 : 0.4);
            draw_text(_kx_pos, _ky_pos, _kkey);

            // Soul indicator above selected key
            if (_sel) {
                draw_set_alpha(1);
                draw_ellipse(
                    _kx_pos + string_width(_kkey) * 0.5 - 3, _ky_pos - 10,
                    _kx_pos + string_width(_kkey) * 0.5 + 3, _ky_pos - 4,
                    false
                );
            }
        }
    }
    draw_set_alpha(1);
}

draw_set_alpha(1);
draw_set_color(c_white);