show_debug_message(sprite_index);
if (mode == "windup" && timer < 25) {
    draw_set_alpha(0.5);
    draw_set_color(c_red);
    draw_line_width(x, y, x + lengthdir_x(1400, direction), y + lengthdir_y(1400, direction), 2);
}

// projecitle sprite is broken for some reason so this does nothing
for (var i = 0; i < trail_max; i++) {
    var trail_alpha = (1 - (i / trail_max)) * 0.4 * image_alpha;
    draw_sprite_ext(sprite_index, image_index, trail_x[i], trail_y[i], image_xscale, image_yscale, image_angle, c_red, trail_alpha);
}

draw_self(); 
show_debug_message(image_xscale);
show_debug_message(image_yscale);

draw_set_alpha(1);
draw_set_color(c_white);