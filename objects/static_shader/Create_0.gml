// Object165 Create Event

application_surface_draw_enable(true);

// Uniform handles
u_time            = shader_get_uniform(sh_soft_fog, "u_time");
u_resolution          = shader_get_uniform(sh_soft_fog, "u_resolution");
u_pixel_scale     = shader_get_uniform(sh_soft_fog, "u_pixel_scale");
u_threshold_player = shader_get_uniform(sh_soft_fog, "u_threshold_player");
u_threshold_tile   = shader_get_uniform(sh_soft_fog, "u_threshold_tile");
u_player_pos      = shader_get_uniform(sh_soft_fog, "u_player_pos");
u_player_speed    = shader_get_uniform(sh_soft_fog, "u_player_speed");

// Player reference
player = o_actor_kris;

// Tunables
thresh_player = 0.18;
thresh_tile   = 0.35;
pixel_size    = 4.0;

// Draw last
depth = 100000;