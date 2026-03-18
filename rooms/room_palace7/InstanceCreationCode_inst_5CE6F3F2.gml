trigger_code = function() {
    cutscene_create();
    cutscene_player_canmove(false);
    cutscene_party_follow(false);

    cutscene_dialogue([
        "{char(susie, 1)}* Is the sun setting?",
        "{char(susie, 1)}* Feel like it's gotten darker.",
    ]);

    cutscene_dialogue([
        "{char(ralsei, 1)}* That happened fast.",
        "{char(susie, 1)}* Maybe sky time is different.",
        "{char(reggie, 1)}* ...Sky time.",
        "{char(susie, 1)}* You know what I mean.",
    ]);
    cutscene_wait_dialogue_finish();

    cutscene_player_canmove(true);
    cutscene_party_follow(true);
    cutscene_play();
}