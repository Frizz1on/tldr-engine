timer++;

// Eye pulse (always)
_eye_pulse_t += 0.04;
if (irandom(90) == 0)
    eye_twitch = random_range(-2, 2);
else
    eye_twitch = lerp(eye_twitch, 0, 0.15);
eye_yscale = 1 + sin(_eye_pulse_t * 0.7) * 0.025;

// ── States 0-2: soul shatter (unchanged engine behaviour) ─────────
if (state < 3) {
    if (timer == 30)  state = 1;
    if (timer == 31)  sprite_delete(freezeframe);
    if (timer == 50) {
        sprite_index = spr_soul_break;
        audio_play(snd_break1);
    }
    if (timer == 90) {
        audio_play(snd_break2);
        visible = false;
        instance_create(o_eff_soulshard, x-2,  y);
        instance_create(o_eff_soulshard, x,    y+3);
        instance_create(o_eff_soulshard, x+2,  y+6);
        instance_create(o_eff_soulshard, x+8,  y);
        instance_create(o_eff_soulshard, x+10, y+3);
        instance_create(o_eff_soulshard, x+12, y+6);
        var _a = image_blend;
        with (o_eff_soulshard) image_blend = _a;
    }
    if (timer == 140) {
        instance_destroy(o_eff_soulshard);
        visible = true;
        state   = 2;
    }
    if (timer == 200) {
        if (!_is_first_death)
            music_play(mus_defeat, 0, true);
        state = 3;
        // Fade in eye
        animate(0, 0.9, 40, anime_curve.linear, id, "eye_alpha");
    }
    if (timer < 200 && timer > 31) {
        if (InputPressed(INPUT_VERB.SELECT)) confirm_pressed++;
        if (confirm_pressed > 4) {
            event_user(0);
            exit;
        }
    }
}

if (state == 2) {
    if (image_alpha < 1) image_alpha += 0.02;
}

// ── State 3: eye speaks ───────────────────────────────────────────
if (state == 3) {
    if (!dia_created) {
        dia_created = true;
        _eye_phase  = 1;

        var _line = _is_first_death
            ? _death_lines_first[0]
            : array_shuffle(_death_quotes_repeat)[0];

        inst_dialogue = text_typer_create(
            _line,
            320, 300,
            DEPTH_UI.DIALOGUE_UI,
            "{preset(god_text)}{can_skip(false)}{center_x(true)}",
            "{p}{e}",
            { gui: true, caller: id }
        );
        _death_line_index = 1;
    }

    // First death: cycle through three lines
    if (_is_first_death && !instance_exists(inst_dialogue) && _eye_phase == 1) {
        if (_death_line_index < array_length(_death_lines_first)) {
            inst_dialogue = text_typer_create(
                _death_lines_first[_death_line_index],
                320, 300,
                DEPTH_UI.DIALOGUE_UI,
                "{preset(god_text)}{can_skip(false)}{center_x(true)}",
                "{p}{e}",
                { gui: true, caller: id }
            );
            _death_line_index++;
        } else {
            // All lines done — move to choice
            state = 4;
        }
    }

    // Repeat deaths: single line then straight to choice
    if (!_is_first_death && !instance_exists(inst_dialogue) && _eye_phase == 1) {
        state = 4;
    }
}

// ── State 4: choice ───────────────────────────────────────────────
if (state == 4) {
    if (ui_alpha < 1) ui_alpha += 0.05;

    if (InputPressed(INPUT_VERB.LEFT))  selection = 0;
    if (InputPressed(INPUT_VERB.RIGHT)) selection = 1;

    if (InputPressed(INPUT_VERB.SELECT) && ui_alpha > 0.5) {
        timer = 0;
        state = 5;
    }
}

// ── State 5: resolution ───────────────────────────────────────────
if (state == 5 && selection == 0) {
    // RETURN — eye says retry line then reloads
    if (ui_alpha > 0) ui_alpha -= 0.05;
    if (timer == 1) {
        inst_dialogue = text_typer_create(
            _retry_line,
            320, 300,
            DEPTH_UI.DIALOGUE_UI,
            "{preset(god_text)}{can_skip(false)}{center_x(true)}",
            "{p}{e}",
            { gui: true, caller: id }
        );
        music_stop(0);
    }
    if (timer > 1 && !instance_exists(inst_dialogue)) {
        audio_play(snd_dtrans_lw);
        fader_alpha += 0.04;
        if (fader_alpha >= 1.2)
            event_user(0);   // Other_10: load save and go
    }
}

if (state == 5 && selection == 1) {
    // GIVE UP — eye says goodbye then ends game
    if (ui_alpha > 0) ui_alpha -= 0.05;
    image_alpha = 0;
    if (timer == 1) {
        music_stop(0);
        inst_dialogue = text_typer_create(
            _give_up_line,
            320, 300,
            DEPTH_UI.DIALOGUE_UI,
            "{preset(god_text)}{can_skip(false)}{center_x(true)}",
            "{p}{e}",
            { gui: true, caller: id }
        );
    }
    if (timer > 1 && !instance_exists(inst_dialogue)) {
        state = 6;
        music_play(mus_darkness, 0, 0);
    }
}

if (state == 6) {
    if (!music_isplaying(0))
        game_end();
}

// Soul position lerp for choice display
if (selection == 0)
    soulx = lerp(soulx, 160 + string_width(choice[0]), 0.4);
if (selection == 1)
    soulx = lerp(soulx, 380 + string_width(choice[1]), 0.4);
