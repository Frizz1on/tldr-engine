trigger_code = function() {

      land_id = 11
    //
    // Place an o_dev_marker with m_type = "jump_land" and m_id = land_id
    // on the far side of each gap as the landing spot.
    //
    // The trigger resets after each crossing so the player can go back and forth.

    var _id   = land_id;
    var _land = marker_getpos("jump_land", _id);

    if (is_undefined(_land)) {
        show_debug_message("jump trigger: no marker (jump_land, " + string(_id) + ")");
        triggered = false;
        exit;
    }

    cutscene_create();
    cutscene_player_canmove(false);
    cutscene_party_follow(false);

    var _names = global.party_names;

    // Entire active party jumps together.
    cutscene_func(function() { audio_play(snd_jump); });
    cutscene_actor_move(party_get_inst(_names[0]), [
        new actor_movement_jump(_land.x, _land.y)
    ], 0, false);
    cutscene_wait_until(function() {
        with (o_actor_mover) { if (pos == 0) return false; }
        return true;
    });

    cutscene_func(function() {
        cutscene_player_canmove(true);
    });

    // Followers jump shortly after the leader without pausing player movement.
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

    cutscene_func(function() {
        cutscene_party_follow(true);
        cutscene_party_interpolate();
    });

    // Reset so the player can cross back over this gap
    cutscene_func(method(self, function() {
        triggered = false;
    }));

    cutscene_play();
}
