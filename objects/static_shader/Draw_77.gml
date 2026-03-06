/* if (!surface_exists(application_surface)) exit;

if (shader_is_compiled(sh_soft_fog))
{
    shader_set(sh_soft_fog);

    shader_set_uniform_f(u_time, current_time / 1000);

    shader_set_uniform_f(
        u_res,
        surface_get_width(application_surface),
        surface_get_height(application_surface)
    );

    shader_set_uniform_f(u_threshold_player, thresh_player);

    if (instance_exists(player))
    {
        var spd = point_distance(0, 0, player.hspeed, player.vspeed);
        shader_set_uniform_f(u_player_speed, spd);
    }

    draw_surface(application_surface, 0, 0);

    shader_reset();
}
else
{
    draw_surface(application_surface, 0, 0);
}