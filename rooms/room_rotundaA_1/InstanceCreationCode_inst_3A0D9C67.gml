trigger_code = function() {
    cutscene_create();
    cutscene_player_canmove(false);
    cutscene_party_follow(false);
	
if (variable_struct_exists(global.save, "larry_berry_defeated")
&&  global.save.larry_berry_defeated) {
    instance_destroy();
    exit;
}


    // Party walking state
    for (var i = 0; i < array_length(global.party_names); i++) {
        var inst = party_get_inst(global.party_names[i]);
        cutscene_set_variable(inst, "state", "walk");
        cutscene_set_variable(inst, "image_speed", 0.2);
    }

    // ── PRE-FIGHT DIALOGUE ───────────────────────────────────────────────────
    cutscene_dialogue([
        "{char(reggie, 1)}* I think we've lost it.",
        "{char(ralsei, 1)}* Yeah... I can't hear it anymore.",
        "{char(ralsei, 1)}* What even was that? No person or animal sounds like that.",
        "{char(susie, 1)}* And it threw stuff at us.",
        "{char(reggie, 1)}* Well, it doesn't matter now. Right now we should be looking for an exit.",
        "{char(ralsei, 1)}* And maybe a light source...",
        "{char(reggie, 1)}* Would be great if I had my phone.",
        "{char(susie, 1)}* Now that you ment-"
    ]);
    cutscene_wait_dialogue_finish();

    // Whip crack — cuts Susie off
    cutscene_audio_play(snd_whip_hard);
    cutscene_sleep(10);

    cutscene_dialogue([
        "{char(reggie, 1)}* ..."
    ]);
    cutscene_wait_dialogue_finish();
    cutscene_sleep(5);

    // ── LARRY & BERRY FADE IN ────────────────────────────────────────────────
    // Spawn them invisible, then fade up so they materialise out of the dark
    cutscene_func(function() {
        var _ry = party_get_inst("kris").y;
        var _ly = party_get_inst("kris").y - 20;
        var _bx = party_get_inst("kris").x + 80;

        global.__larry_inst = instance_create(o_berry, _bx, _ly, 0);
        global.__barry_inst = instance_create(o_berry, _bx, _ry, 0);

        global.__larry_inst.image_alpha = 0;
        global.__barry_inst.image_alpha = 0;
    });

    // Fade both in over 30 frames
    cutscene_func(function() {
        animate(0, 1, 30, anime_curve.linear, global.__larry_inst, "image_alpha");
        animate(0, 1, 30, anime_curve.linear, global.__barry_inst, "image_alpha");
    });
    cutscene_sleep(35);

    // Pre-fight music
    cutscene_func(function() {
        audio_play(mus_prefight);
    });

    cutscene_dialogue([
        "{char(larry, 1)}* HEY! BERRY! I THINK WE HAVE SOME INTRUDERS.",
        "{char(berry, 1)}* IT SURE WOULD SEEM SO.",
        "{char(larry, 1)}* I've had enough of you lightfolk passing through here and disrupting the wildlife.",
        "{char(ralsei, 1)}* ??? I think there's a misunderstanding."
    ]);

    cutscene_dialogue([
        "{char(berry, 1)}* Oh there's a misunderstanding alright.",
        "{char(berry, 1)}* You think you can just go wherever you like whenever you like.",
        "{char(susie, 1)}* No one said anything like that."
    ]);

    cutscene_dialogue([
        "{char(berry, 1)}* Well it doesn't matter to me.",
        "{char(larry, 1)}* TURN ON THE LIGHTS AND-",
        "{char(berry, 1)}* SOUND THE ALARMS"
    ]);
    cutscene_wait_dialogue_finish();


    cutscene_func(function() {
        audio_play(snd_alarmlong);

        // Create the screen flash overlay
        global.__alarm_flash = instance_create(o_flash, 0, 0, DEPTH_UI.FADER - 1);
        global.__alarm_flash.image_alpha = 0;
        global.__alarm_flash.color = c_red;

        // Fade in gently over 18 frames (~0.3s) — soft entry to avoid strobe onset
        animate(0, 0.55, 18, anime_curve.linear, global.__alarm_flash, "image_alpha");
    });
    cutscene_sleep(20);   // wait for fade-in to settle

    // Strobe: 4 red/white pulses over ~120 frames (~2s)
    // Each pulse is a slow toggle — not an instant snap — to stay accessible
    cutscene_func(function() {
        global.__alarm_flash.color = c_white;
        animate(0.55, 0.7, 15, anime_curve.linear, global.__alarm_flash, "image_alpha");
    });
    cutscene_sleep(18);
    cutscene_func(function() {
        global.__alarm_flash.color = c_red;
        animate(0.7, 0.5, 15, anime_curve.linear, global.__alarm_flash, "image_alpha");
    });
    cutscene_sleep(18);
    cutscene_func(function() {
        global.__alarm_flash.color = c_white;
        animate(0.5, 0.7, 15, anime_curve.linear, global.__alarm_flash, "image_alpha");
    });
    cutscene_sleep(18);
    cutscene_func(function() {
        global.__alarm_flash.color = c_red;
        animate(0.7, 0.8, 15, anime_curve.linear, global.__alarm_flash, "image_alpha");
    });
    cutscene_sleep(20);

    // Hold on a solid red — hides the shader-off transition into the battle
    cutscene_func(function() {
        global.__alarm_flash.color = c_red;
        global.__alarm_flash.image_alpha = 1;
    });
    cutscene_sleep(8);

    // ── START ENCOUNTER ──────────────────────────────────────────────────────
    cutscene_func(function() {
        cutscene_player_canmove(true);
        cutscene_party_follow(true);
        audio_stop_all();
        instance_deactivate_object(static_shader);
		

        // Fade the flash overlay OUT now that the enc transition covers the screen
        animate(1, 0, 20, anime_curve.linear, global.__alarm_flash, "image_alpha");

        var _enc = new enc_set_larry_berry();

        // ── POST-FIGHT CUTSCENE via ev_win ───────────────────────────────────
        _enc.ev_win = function() {
            cutscene_create();
			global.save.larry_berry_defeated = true;

            // Short pause before Larry and Berry speak
            cutscene_sleep(30);

            cutscene_dialogue([
                "{char(larry, 1)}* Hold on.",
                "{char(berry, 1)}* ...",
                "{char(berry, 1)}* You're permitted.",
                "{char(ralsei, 1)}* What does that mean?",
                "{char(berry, 1)}* It means you're allowed to be here.",
                "{char(susie, 1)}* By who?"
            ]);

            cutscene_dialogue([
                "{char(berry, 1)}* We apologise for the trouble.",
                "{char(larry, 1)}* ...Sorry.",
                "{char(ralsei, 1)}* You can't just",
            ]);
            cutscene_wait_dialogue_finish();

            cutscene_func(function() {
                if instance_exists(global.__larry_inst)
                    animate(global.__larry_inst.image_alpha, 0, 40, anime_curve.linear, global.__larry_inst, "image_alpha");
                if instance_exists(global.__barry_inst)
                    animate(global.__barry_inst.image_alpha, 0, 40, anime_curve.linear, global.__barry_inst, "image_alpha");
            });
            cutscene_sleep(45);

            cutscene_func(function() {
                if instance_exists(global.__larry_inst)  instance_destroy(global.__larry_inst);
                if instance_exists(global.__barry_inst)  instance_destroy(global.__barry_inst);
                if instance_exists(global.__alarm_flash) instance_destroy(global.__alarm_flash);

		        music_resume(0)
		        music_fade(0, 1, 30)
		        state_add("cutscene_seen")
		    }, [id])
            cutscene_dialogue([
                "{char(susie, 1)}*Now that I can see ...",
                "{char(susie, 1)}* Has anyone else notice we are dressed right now.",
                "{char(ralsei, 1)}* I... I hadn't thought about it.",
                "{char(susie, 1)}* Your knight stuff is one thing but, Why am I a magician? And is Reggie a cowboy?",
                "{char(reggie, 1)}* And this hat",
                "{char(reggie, 1)}*  I can't take it off",
                "{char(susie, 1)}* What.",
                "{char(reggie, 1)}* I've tried. It won't come off.",
                "{char(ralsei, 1)}* ...Oh.",
                "{char(susie, 1)}* That's ...",
                "{char(ralsei, 1)}* ...Let's just find a way out."
            ]);
            cutscene_wait_dialogue_finish();

            cutscene_play();
        };

        enc_start(_enc);
    });

    cutscene_play();
}
