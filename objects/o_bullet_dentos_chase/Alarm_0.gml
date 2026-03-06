var dir = shotgun_dir;

for (var i = 0; i < 4; i++) {
    var angle_offset = (i - 1.5) * 12;
    
    var b = instance_create(o_spawn_diamond, x, y, depth + 1);
    
    with (b) {
        direction = dir + angle_offset;
        mode = "instant";
        speed = 10;
        max_speed = 14;
    }
}