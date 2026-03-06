var target = get_leader();

if (instance_exists(target)) {
    var dist = point_distance(x, y, target.x, target.y);
    var target_speed = (dist > 180) ? 8 : (dist < 100 ? 1.2 : 4.5);
    
    speed = lerp(speed, target_speed, 0.4);
    var target_dir = point_direction(x, y, target.x, target.y);
    direction += angle_difference(target_dir, direction) * 0.05;
    image_angle = direction;
}

timer++;
var attack_cycle = 70;
var pulse_start = 50;

if (timer % attack_cycle >= pulse_start) {
    var pulse_val = sin(current_time / 50) * 0.2;
    image_xscale = 2 + pulse_val;
    image_yscale = 2 + pulse_val;
    image_blend = merge_color(c_red, c_white, 0.5 + pulse_val);
} else {
    image_xscale = lerp(image_xscale, 2, 0.1);
    image_yscale = image_xscale;
    image_blend = c_red;
}

if (timer % attack_cycle == 0) {
    attack_mode = !attack_mode;
    if (!instance_exists(target)) exit;

   if (attack_mode == 0) {

    var p_vx = target.x - target.xprevious; 
    var p_vy = target.y - target.yprevious;
    var predict_x = target.x + (p_vx * 15);
    var predict_y = target.y + (p_vy * 15);
    var base_dir = point_direction(x, y, predict_x, predict_y);

    for (var i = 0; i < 4; i++) {
        var angle_offset = (i - 1.5) * 12; 
        var b = instance_create(o_spawn_diamond, x, y, depth + 1);
        with (b) {
            direction = base_dir + angle_offset;
            mode = "instant";
            speed = 8;             
            max_speed = 12;        
        }
    }


    shotgun_dir = base_dir;  
    alarm[0] = 8;          

    audio_play(snd_crow, 0, 1, 0.9);
}
    else {
        cross_toggle = !cross_toggle;
        var cx = camera_get_view_x(view_camera[0]);
        var cy = camera_get_view_y(view_camera[0]);
        var cw = camera_get_view_width(view_camera[0]);
        var ch = camera_get_view_height(view_camera[0]);

        var spawn_data = (cross_toggle) ? 
            [{sx: target.x, sy: cy, sd: 270}, {sx: target.x, sy: cy + ch, sd: 90}, {sx: cx, sy: target.y, sd: 0}, {sx: cx + cw, sy: target.y, sd: 180}] :
            [{sx: cx, sy: cy, sd: 0}, {sx: cx+cw, sy: cy, sd: 0}, {sx: cx, sy: cy+ch, sd: 0}, {sx: cx+cw, sy: cy+ch, sd: 0}];

        for(var i=0; i<array_length(spawn_data); i++) {
            var b = instance_create(o_spawn_diamond, spawn_data[i].sx, spawn_data[i].sy, depth+1);
            with (b) {
			    direction = spawn_data[i].sd;
			    mode = "windup";
    
			    speed = 6;           
			    max_speed = 18;       
			    accel = 0.6;  
                if (!other.cross_toggle) tracking_type = "point"; 
                else tracking_type = (direction == 0 || direction == 180) ? "y" : "x";
            }
        }
        audio_play(snd_whip_hard, 0, 1, 1.2);
    }
}