if (!surface_exists(application_surface)) exit;

shader_set(sh_soft_fog);

shader_set_uniform_f(
    u_resolution,
    surface_get_width(application_surface),
    surface_get_height(application_surface)
);

shader_set_uniform_f(u_time, current_time / 1000.0);

// IMPORTANT:
// Draw at 0,0 WITHOUT stretching
draw_surface(application_surface, 0, 0);

shader_reset();