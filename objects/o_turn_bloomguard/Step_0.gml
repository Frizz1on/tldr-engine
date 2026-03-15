event_inherited();
timer++;

if (!instance_exists(o_enc_box)) exit;
if (!variable_struct_exists(enemy_struct,"actor_id")) exit;

var o = enemy_struct.actor_id;
if (!instance_exists(o)) exit;


var _bx  = o_enc_box.x;
var _by  = o_enc_box.y;
var _bhw = o_enc_box.width  * 0.5;
var _bhh = o_enc_box.height * 0.5;

var _bl = _bx - _bhw;
var _br = _bx + _bhw;
var _bt = _by - _bhh;
var _bb = _by + _bhh;



/// THORN WAVE
/// sweeping columns forcing the player to move

if (pattern == "thorn_wave") {

    if (timer == 1) {

        o.depth_override =
        DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y());

        o.depth = o.depth_override;

        wave_shift = irandom_range(-40,40);
    }


    if (timer > 15 && timer < 140 && timer % 20 == 0) {

        wave_shift += random_range(-25,25);

        var _cols = 6;

        for (var i=0; i<_cols; i++) {

            var _x = _bl + o_enc_box.width * ((i+0.5)/_cols);
            _x += wave_shift;

            var b = instance_create_depth(
                _x,
                _bb + 8,
                DEPTH_ENCOUNTER.BULLETS_OUTSIDE,
                o_enc_bullet
            );

            b.direction = 270;
            b.speed = random_range(3.5,5);

            b.image_angle = 270;

            // sideways drift for unpredictability
            b.hspeed = random_range(-0.7,0.7);
        }
    }


    if (timer > 160) {
        o.depth_override = undefined;
        instance_destroy();
    }
}




/// THORN SNIPER
/// predictive shots toward player movement

else if (pattern == "thorn_sniper") {

    if (timer == 1) {

        o.depth_override =
        DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y());

        o.depth = o.depth_override;
    }


    if (timer == 30 || timer == 70 || timer == 110) {

        if (instance_exists(o_enc_soul)) {

            var px = o_enc_soul.x + o_enc_soul.hspeed * 12;
            var py = o_enc_soul.y + o_enc_soul.vspeed * 12;

            var aim = point_direction(o.x,o.y,px,py);

            for (var i=-2; i<=2; i++) {

                var b = instance_create_depth(
                    o.x,
                    o.y,
                    DEPTH_ENCOUNTER.BULLETS_OUTSIDE,
                    o_enc_bullet
                );

                b.direction = aim + i * 12;
                b.speed = random_range(4,6);
                b.image_angle = b.direction;
            }
        }
    }


    if (timer > 150) {
        o.depth_override = undefined;
        instance_destroy();
    }
}




/// THORN BLOOM
/// arena-centered radial thorn explosions

else if (pattern == "thorn_bloom") {

    if (timer == 1) {

        o.depth_override =
        DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y());

        o.depth = o.depth_override;

        bloom_count = 0;
    }


    if (timer % 35 == 0 && bloom_count < 4) {

        var cx = random_range(_bl + 20,_br - 20);
        var cy = random_range(_bt + 20,_bb - 20);

        for (var i=0;i<10;i++) {

            var dir = i * 36;

            var b = instance_create_depth(
                cx,
                cy,
                DEPTH_ENCOUNTER.BULLETS_OUTSIDE,
                o_enc_bullet
            );

            b.direction = dir;
            b.speed = random_range(3,4.5);
            b.image_angle = dir;
        }

        bloom_count++;
    }


    if (timer > 160) {
        o.depth_override = undefined;
        instance_destroy();
    }
}
