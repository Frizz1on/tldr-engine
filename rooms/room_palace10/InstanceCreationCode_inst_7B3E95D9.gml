trigger_code = function() {
    land_id = 0;

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

    cutscene_set_variable(o_camera, "target", noone);

    var _names = global.party_names;

    cutscene_func(function() { audio_play(snd_jump); });
    cutscene_actor_move(party_get_inst(_names[0]), [
        new actor_movement_jump(_land.x, _land.y)
    ], 0, false);
    cutscene_wait_until(function() {
        with (o_actor_mover) { if (pos == 0) return false; }
        return true;
    });

    // Restore control as soon as leader lands — they're off screen so
    // the player can't walk back on camera before the transition fires.
    cutscene_func(function() {
        cutscene_player_canmove(true);
        cutscene_party_follow(true);
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
    cutscene_func(function() {
        fader_fade(0, 1, 12);
    });
    cutscene_sleep(14);

    cutscene_func(method(self, function() {
        room_goto(room_palacetown1);
    }));

    cutscene_play();
}