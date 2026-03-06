
event_inherited()

var o = o_actor_barry

if pattern == "shield_wall" {

    if timer == 6 {
        o.shield_raise   = 2
        o.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y())
        o.depth          = o.depth_override
        column_x_offset  = random_range(-15, 15)
    }


    if timer >= 12 && timer < timer_end - 30 {
        column_timer++

        if column_timer % 30 == 0 {
            // Shift the column position
            column_x_offset += random_range(-20, 20)
            column_x_offset  = clamp(column_x_offset, -30, 30)

            var base_x = (o_enc_box.x + o_enc_box.sprite_w * 0.5) + column_x_offset

            for (var b = 0; b < 5; b++) {
                var inst = instance_create(
                    o_enc_bullet,
                    base_x + (b - 2) * 14,
                    o_enc_box.y - 10,
                    DEPTH_ENCOUNTER.BULLETS_OUTSIDE
                )
                inst.direction   = 270
                inst.speed       = 3.5
                inst.image_angle = 270
            }
        }
    }

    if timer >= timer_end - 28 {
        o.shield_raise   = 0
        o.depth_override = undefined
        instance_destroy()
    }
}


else if pattern == "shield_crush" {

    if timer == 6 {
        o.shield_raise   = 1
        o.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y())
        o.depth          = o.depth_override

        // Spawn the sliding shield-wall bullet off the appropriate side
        var start_x = (crush_dir > 0)
            ? o_enc_box.x - 60
            : o_enc_box.x + o_enc_box.sprite_w + 60

        var end_x = (crush_dir > 0)
            ? o_enc_box.x + o_enc_box.sprite_w * 0.6    // leaves 40% open on right
            : o_enc_box.x + o_enc_box.sprite_w * 0.4    // leaves 40% open on left

        wall_inst = instance_create(
            o_enc_bullet,
            start_x,
            o_enc_box.y + o_enc_box.sprite_h * 0.5,
            DEPTH_ENCOUNTER.BULLETS_OUTSIDE,
            { image_xscale: 3, image_yscale: 7 }
        )
        animate(start_x, end_x, 55, anime_curve.cubic_out, wall_inst, "x")
       // audio_play(snd_berry_scrape)   // slow stone-scrape SFX
    }

    // While the wall is closing, fire a volley of bullets on the open side
    // — the safe zone is under pressure the whole time.
    if timer >= 30 && timer < 145 && timer % 8 == 0 && volley_count < 14 {
        var safe_x_min = (crush_dir > 0)
            ? wall_inst.x + 10
            : o_enc_box.x + 10
        var safe_x_max = (crush_dir > 0)
            ? o_enc_box.x + o_enc_box.sprite_w - 10
            : wall_inst.x - 10
        safe_x_min = max(safe_x_min, o_enc_box.x + 8)
        safe_x_max = min(safe_x_max, o_enc_box.x + o_enc_box.sprite_w - 8)

        var tx = safe_x_min + random(max(1, safe_x_max - safe_x_min))
        var inst = instance_create(o_enc_bullet, tx, o_enc_box.y - 12, DEPTH_ENCOUNTER.BULLETS_OUTSIDE)
        inst.direction   = 270
        inst.speed       = 4.5
        inst.image_angle = 270
        volley_count++
    }

    // Wall retreats at ~frame 155
    if timer == 155 && instance_exists(wall_inst) {
        var retreat_x = (crush_dir > 0)
            ? o_enc_box.x - 60
            : o_enc_box.x + o_enc_box.sprite_w + 60
        animate(wall_inst.x, retreat_x, 35, anime_curve.cubic_in, wall_inst, "x")
    }
    if timer == 195 && instance_exists(wall_inst) {
        instance_destroy(wall_inst)
    }

    if timer >= timer_end - 20 {
        if instance_exists(wall_inst) instance_destroy(wall_inst)
        o.shield_raise   = 0
        o.depth_override = undefined
        crush_dir       *= -1   // next use comes from the other side
        instance_destroy()
    }
}

