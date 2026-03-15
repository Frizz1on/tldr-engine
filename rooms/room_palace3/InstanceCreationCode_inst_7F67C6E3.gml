trigger_code = function() {

    var _land  = marker_getpos("jump_land", 1);
    var _runup = marker_getpos("jump_run",  0);


    if (is_undefined(_land) || is_undefined(_runup)) {
        show_debug_message("jump intro: missing markers!");
        exit;
    }

    var _reggie = party_get_inst("kris");
    var _susie  = party_get_inst("susie");
    var _ralsei = party_get_inst("ralsei");

    cutscene_create();
    cutscene_player_canmove(false);
    cutscene_party_follow(false);

    // ── OPENING DIALOGUE ─────────────────────────────────────────────────────
    cutscene_dialogue([
        "{char(ralsei, 1)}* ... What in the world. How are we supposed to get past this?",
        "{char(susie, 1)}* Better question is, how did HE get past this?",
    ]);
    cutscene_wait_dialogue_finish();

    // ── REGGIE STEPS BACK ────────────────────────────────────────────────────
    cutscene_dialogue([
        "{char(reggie, 1)}* Hold on."
    ]);
    cutscene_wait_dialogue_finish();

    // Step back to the run-up position
    cutscene_actor_move(_reggie, [
        new actor_movement(_runup.x, _runup.y, 18)
    ], 0, true);  // wait = true

    cutscene_sleep(8);

    // ── REGGIE JUMPS ─────────────────────────────────────────────────────────
    cutscene_func(function(_land) {
        audio_play(snd_jump);
    }, [_land]);

    cutscene_actor_move(_reggie, [
        new actor_movement_jump(_land.x, _land.y)
    ], 0, false);   // wait = false so we can sleep alongside it

    cutscene_wait_until(function() {
        return !instance_exists(o_actor_mover);
    });

    cutscene_sleep(12);

    // ── POST-JUMP DIALOGUE ───────────────────────────────────────────────────
    cutscene_dialogue([
        "{char(ralsei, 1)}* !!!",
        "{char(reggie, 1)}* The wind carries you across.",
        "{char(susie, 1)}* And how did you know that?",
        "{char(reggie, 1)}* I guessed.",
        "{char(ralsei, 1)}* ..."
    ]);
    cutscene_wait_dialogue_finish();

    cutscene_sleep(6);

    // ── SUSIE JUMPS ──────────────────────────────────────────────────────────
    cutscene_func(function() { audio_play(snd_jump); });
    cutscene_actor_move(_susie, [
        new actor_movement_jump(_land.x, _land.y)
    ], 1, false);
    cutscene_wait_until(function() {
        return !instance_exists(o_actor_mover);
    });
    cutscene_sleep(10);

    // ── RALSEI JUMPS ─────────────────────────────────────────────────────────
    cutscene_func(function() { audio_play(snd_jump); });
    cutscene_actor_move(_ralsei, [
        new actor_movement_jump(_land.x, _land.y)
    ], 2, false);
    cutscene_wait_until(function() {
        return !instance_exists(o_actor_mover);
    });
    cutscene_sleep(15);

    // ── TUTORIAL HINT ────────────────────────────────────────────────────────
    cutscene_dialogue([
        "* (You can jump across the marked gaps.)"
    ]);
    cutscene_wait_dialogue_finish();

    // Restore control
    cutscene_player_canmove(true);
    cutscene_party_follow(true);
    cutscene_party_interpolate();

    cutscene_play();
}
