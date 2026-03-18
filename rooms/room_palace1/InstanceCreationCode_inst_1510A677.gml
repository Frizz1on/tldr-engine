trigger_code = function() {
    cutscene_create();
    cutscene_player_canmove(false);
    cutscene_party_follow(false);

    cutscene_dialogue([
        "{char(ralsei, 1)}* ...",
        "{char(ralsei, 1)}* This is it.",
        "{char(reggie, 1)}* The sky palace.",
        "{char(susie, 1)}* Fredrick knew what he was talking about.",
        "{char(reggie, 1)}* Didn't think he did.",
    ]);


    cutscene_dialogue([
        "{char(reggie, 1)}* Alright. Let's see what's up here.",
    ]);
    cutscene_wait_dialogue_finish();

    cutscene_player_canmove(true);
    cutscene_party_follow(true);
    cutscene_play();
}

