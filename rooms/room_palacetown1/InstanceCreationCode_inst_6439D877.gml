trigger_code = function() {
    cutscene_create();
    cutscene_player_canmove(false);
    cutscene_party_follow(false);

   
    cutscene_sleep(50);

    // Party drops in from above via jump
    var _land = marker_getpos("jump_land", 0);
    var _names = global.party_names;

    cutscene_func(function() { audio_play(snd_jump); });
    cutscene_actor_move(party_get_inst(_names[0]), [
        new actor_movement_jump(_land.x, _land.y)
    ], 0, false);
    cutscene_wait_until(function() {
        with (o_actor_mover) { if (pos == 0) return false; }
        return true;
    });

    for (var _i = 1; _i < array_length(_names); _i++) {
        var _inst = party_get_inst(_names[_i]);
        if (!instance_exists(_inst)) continue;
        cutscene_sleep(2);
        cutscene_func(function() { audio_play(snd_jump); });
        cutscene_actor_move(_inst, [
            new actor_movement_jump(_land.x, _land.y)
        ], _i, false);
    }

    cutscene_wait_until(function() {
        return !instance_exists(o_actor_mover);
    });

    cutscene_sleep(18);

    // Dialogue
    cutscene_dialogue([
        "{char(reggie, 1)}* Man... that was quite a long fall.",
        "{char(susie, 1)}* Everyone still alive?",
        "{char(ralsei, 1)}* I hope so.",
        "{char(reggie, 1)}* Good enough.",
    ]);
    cutscene_wait_dialogue_finish();

    cutscene_sleep(10);

    // Smoothly restore camera to follow the leader
    cutscene_func(function() {
        camera_unpan(get_leader(), 40, anime_curve.cubic_out);
    });
    cutscene_sleep(42);   // wait for the unpan to finish

    cutscene_func(function() {
        cutscene_player_canmove(true);
        cutscene_party_follow(true);
        cutscene_party_interpolate();
    });

    cutscene_func(method(self, function() {
        triggered = false;
    }));

    cutscene_play();
}