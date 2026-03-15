if (mode == "windup" && timer < 25 && use_line_telegraph) {
    draw_set_alpha(0.55);
    draw_set_color(c_red);
    draw_line_width(x, y, x + lengthdir_x(1400, direction), y + lengthdir_y(1400, direction), 2);
}

if (!(mode == "windup" && use_line_telegraph)) {
    for (var i = 0; i < trail_max; i++) {
        var trail_alpha = (1 - (i / trail_max)) * 0.4 * image_alpha;
        draw_sprite_ext(sprite_index, image_index, trail_x[i], trail_y[i], image_xscale, image_yscale, image_angle, c_red, trail_alpha);
    }
}

draw_self();

draw_set_alpha(1);
draw_set_color(c_white);
