event_inherited()

var o = o_actor_larry

if pattern == "sword_sweep" {

    if timer == 6 {
        o.sword_active   = true
        o.sword_angle    = (sweep_dir > 0) ? -70 : 70
        o.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y())
        o.depth          = o.depth_override
      //  o.sprite_index   = spr_e_larry_swing_ready
    }

    if timer >= 6 && timer < timer_end - 25 {
        var t = (timer - 6) / (timer_end - 31)
        o.sword_angle = lerp(-70 * sweep_dir, 70 * sweep_dir, t)

        if (timer - 6) % 20 == 0 && slash_count < 7 {

            var fire_angle = o.sword_angle + 90 * sweep_dir
            var sx = o.x - sprite_get_xoffset(o.sprite_index) + 8
            var sy = o.y - sprite_get_yoffset(o.sprite_index) + 22

            for (var spread = -1; spread <= 1; spread++) {
                var inst = instance_create(
                    o_enc_bullet,
                    sx + lengthdir_x(18, o.sword_angle),
                    sy + lengthdir_y(18, o.sword_angle),
                    DEPTH_ENCOUNTER.BULLETS_OUTSIDE
                )
                inst.direction   = fire_angle + spread * 15
                inst.speed       = 4.5
                inst.image_angle = inst.direction
            }

            slash_count++
        //    audio_play(snd_larry_slash) 
        }
    }

    if timer == timer_end - 22 {
        o.sword_active   = false
      //  o.sprite_index   = enemy_struct.s_idle
        o.depth_override = undefined
        sweep_dir       *= -1
        instance_destroy()
    }
}


else if pattern == "alarm_burst" {

    if timer == 6 {
      //  o.sprite_index   = spr_e_larry_alarm
        o.depth_override = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y - guipos_y())
        o.depth          = o.depth_override
        //audio_play(snd_larry_alarm)
    }


    if timer >= 6
        o.buzzer_flash = max(0, sine(8, timer * 0.15))


    if timer >= 20 && timer < 75 && timer % 6 == 0 {
        var tx = o_enc_box.x + 8 + random(o_enc_box.sprite_w * 0.6)
        var inst = instance_create(o_enc_bullet, tx, o_enc_box.y - 14, DEPTH_ENCOUNTER.BULLETS_OUTSIDE)
        inst.direction   = 270
        inst.speed       = 4 + random(1)
        inst.image_angle = 270
    }


    if timer >= 75 && timer < 100
        o.buzzer_flash = max(0, sine(20, timer * 0.08))

    if timer == 100 //audio_play(snd_larry_alarm)

    if timer >= 105 && timer < 165 && timer % 5 == 0 {
        var tx = o_enc_box.x + o_enc_box.sprite_w * 0.4 + random(o_enc_box.sprite_w * 0.55)
        var inst = instance_create(o_enc_bullet, tx, o_enc_box.y - 14, DEPTH_ENCOUNTER.BULLETS_OUTSIDE)
        inst.direction   = 270
        inst.speed       = 5 + random(1.5)
        inst.image_angle = 270
    }

    if timer >= timer_end - 20 {
        o.buzzer_flash   = 0
      //  o.sprite_index   = enemy_struct.s_idle
        o.depth_override = undefined
        burst_wave       = 0
        instance_destroy()
    }
}

