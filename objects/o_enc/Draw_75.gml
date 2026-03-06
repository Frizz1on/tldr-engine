if (flash_alpha > 0) {
    draw_set_color(flash_color);
    draw_set_alpha(flash_alpha);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    
    draw_set_alpha(1);
}