trigger_code = function() {

    cutscene_create();
    cutscene_player_canmove(false);
    cutscene_party_follow(false);

  
   for (var i = 0; i < array_length(global.party_names); i++) {
    var inst = party_get_inst(global.party_names[i]);

    cutscene_set_variable(inst, "state", "walk"); 
    cutscene_set_variable(inst, "image_speed", 0.2);
}

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



    cutscene_audio_play(snd_whip_hard);

    // Spawn Larry & Berry
 /*   cutscene_func(function() {
        var y = party_get_inst("reggie").y;
        instance_create(-64, y, o_larry);
        instance_create(room_width + 64, y, o_berry);
    }); */

    cutscene_sleep(10);

    cutscene_dialogue([
        "{char(reggie, 1)}* ..."
    ]);

    cutscene_sleep(5);
	cutscene_func(function() {

	      audio_play(mus_prefight)
	    })

    cutscene_dialogue([
        "{char(larry, 1)}* HEY! BERRY! I THINK WE HAVE SOME INTRUDERS.",
        "{char(berry, 1)}* IT SURE WOULD SEEM SO.",
        "{char(larry, 1)}* I've had enough of you lightfolk passing through here and disrupting the wildlife.",
        "{char(ralsei, 1)}* ??? I think there's a misunderstanding."
    ]);

	

	 cutscene_dialogue([
        "{char(berry, 1)}* Oh there's a misunderstanding alright.",
        "{char(berry, 1)}* You think you can just go wherever you like whenever you like.",
        "{char(susie, 1)}* No one said anything like that"
    ]);

    cutscene_dialogue([
        "{char(berry, 1)}* Well it doesn't matter to me.",
        "{char(larry, 1)}* TURN ON THE LIGHTS AND-",
        "{char(berry, 1)}* SOUND THE ALARMS"
    ]);

   cutscene_audio_play(snd_alarmlong);


cutscene_sleep(20);

cutscene_func(function() {

    cutscene_player_canmove(true);
    cutscene_party_follow(true);

    audio_stop_all(); 

    enc_start(new enc_set_larry_berry());
	instance_deactivate_object(static_shader)

});

cutscene_play();
}