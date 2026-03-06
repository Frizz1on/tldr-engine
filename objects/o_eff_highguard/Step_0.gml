if (!instance_exists(target)) {
    instance_destroy();
    exit;
}


x = target.x;
y = target.y - 32 + float_offset;


float_offset += 0.2 * float_dir;
if (abs(float_offset) > 3)
    float_dir *= -1;


if (party_getdata(target.name, "highguard_turns") <= 0) {
    instance_destroy();
}