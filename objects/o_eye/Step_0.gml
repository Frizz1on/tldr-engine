state_timer++;
_eye_pulse_t += 0.04;

// Eye twitch
if (irandom(120) == 0)
    eye_twitch = random_range(-3, 3);
else
    eye_twitch = lerp(eye_twitch, 0, 0.15);

eye_yscale = 1 + eye_distort * 0.4 + sin(_eye_pulse_t * 0.7) * 0.02;
eye_xscale = 1 + eye_distort * 0.15;

// Inversion
if (inverted)
    _inv_progress = min(1, _inv_progress + 0.018);
else
    _inv_progress = max(0, _inv_progress - 0.018);

bg_color = merge_colour(c_black, c_white, _inv_progress);
fg_color = merge_colour(c_white, c_black, _inv_progress);

// Text input capture
if (input_active) {
    if (keyboard_check_pressed(vk_backspace)) {
        if (string_length(input_string) > 0)
            input_string = string_delete(input_string, string_length(input_string), 1);
    } else if (keyboard_check_pressed(vk_return) || keyboard_check_pressed(vk_enter)) {
        if (string_length(input_string) > 0)
            input_active = false;
    } else {
        for (var _k = 32; _k < 127; _k++) {
            if (keyboard_check_pressed(_k)) {
                var _ch = chr(_k);
                if (!keyboard_check(vk_shift)) _ch = string_lower(_ch);
                if (string_length(input_string) < input_maxlen)
                    input_string += _ch;
            }
        }
    }
}

// Yes/No input
if (choice_visible) {
    if (InputPressed(INPUT_VERB.LEFT) || InputPressed(INPUT_VERB.RIGHT))
        choice_selection = 1 - choice_selection;
    var _confirm = InputPressed(INPUT_VERB.SELECT)
        || keyboard_check_pressed(vk_enter)
        || keyboard_check_pressed(vk_return)
        || keyboard_check_pressed(vk_space)
        || keyboard_check_pressed(ord("Z"));
    if (_confirm) {
        choice_result  = choice_selection;
        choice_visible = false;
    }
}

// ── STATE MACHINE ─────────────────────────────────────────────────
// Line swap rhythm: fade_out at T, show_line at T+18, next beat >= T+50
// Question gaps: ~90 frames between each question

switch (state) {

// ── BOOT ──────────────────────────────────────────────────────────
case EYE_STATE.BOOT:
    if (state_timer == 120) {
        animate(0, 0.9, 60, anime_curve.linear, id, "eye_alpha");
    }
    if (state_timer == 185)
        _goto_state(EYE_STATE.CONTACT);
break;

// ── CONTACT ───────────────────────────────────────────────────────
case EYE_STATE.CONTACT:
    if (state_timer == 10)  _show_line("Hello.", 200);
    if (state_timer == 100) _fade_out();
    if (state_timer == 118) _show_line("Can you see me?", 200);
    if (state_timer == 210) _fade_out();
    if (state_timer == 228) _show_line("...", 200);
    if (state_timer == 300) _fade_out();
    if (state_timer == 318) _show_line("Good.", 200);
    if (state_timer == 410) _fade_out();
    if (state_timer == 428) _show_line("Before we begin...", 200);
    if (state_timer == 520) _fade_out();
    if (state_timer == 538) _show_line("I need to understand you.", 200);
    if (state_timer == 630) _fade_out();
    if (state_timer == 648) _show_line("Tell me...", 200);
    if (state_timer == 730) _fade_out();
    if (state_timer == 750) _goto_state(EYE_STATE.Q_DREAM);
break;

// ── Q_DREAM ───────────────────────────────────────────────────────
case EYE_STATE.Q_DREAM:
    if (state_timer == 1) {
        _show_line("Are you currently dreaming?", 190);
        _show_choice("YES", "NO");
    }
    if (choice_result != -1) {
        global.eye_profile.dream_aware = (choice_result == 0);
        global.eye_profile._lie_dream  = (irandom(2) == 0);
        choice_result = -1;
        _fade_out();
        animate(eye_distort, 0.15, 20, anime_curve.sine_in_out, id, "eye_distort");
        _goto_state(EYE_STATE.Q_DREAM_REACT);
    }
break;

// ── Q_DREAM_REACT ─────────────────────────────────────────────────
case EYE_STATE.Q_DREAM_REACT:
    if (state_timer == 20) {
        animate(eye_distort, 0, 20, anime_curve.sine_in_out, id, "eye_distort");
        _show_line("That's interesting.", 200);
    }
    if (state_timer == 110) {
        _fade_out();
        inverted = true;
        if (!audio_is_playing(mus_k))
            audio_play(mus_k, 0, 1, 1, 0);
    }
    if (state_timer == 135) _goto_state(EYE_STATE.Q_COLOR);
break;

// ── Q_COLOR ───────────────────────────────────────────────────────
case EYE_STATE.Q_COLOR:
    if (state_timer == 1) {
        _show_line("What is your favourite colour?", 210);
        _begin_input("colour", 20, "Type then press Enter.");
    }
    if (!input_active && string_length(input_string) > 0) {
        global.eye_profile.fav_color = input_string;
        _fade_out();
        _goto_state(EYE_STATE.Q_HOBBY);
    }
break;

// ── Q_HOBBY ───────────────────────────────────────────────────────
case EYE_STATE.Q_HOBBY:
    if (state_timer == 30) {
        _show_line("What do you enjoy doing?", 210);
        _begin_input("hobby", 30, "Type then press Enter.");
    }
    if (state_timer >= 30 && !input_active && string_length(input_string) > 0) {
        global.eye_profile.fav_hobby = input_string;
        _fade_out();
        _goto_state(EYE_STATE.Q_FOOD);
    }
break;

// ── Q_FOOD ────────────────────────────────────────────────────────
case EYE_STATE.Q_FOOD:
    if (state_timer == 30) {
        _show_line("What is your favourite food?", 210);
        _begin_input("food", 20, "Type then press Enter.");
    }
    if (state_timer >= 30 && !input_active && string_length(input_string) > 0) {
        global.eye_profile.fav_food = input_string;
        _fade_out();
        animate(eye_distort, 0.3, 60, anime_curve.cubic_in_out, id, "eye_distort");
        _goto_state(EYE_STATE.Q_VALUABLE);
    }
break;

// ── Q_VALUABLE ────────────────────────────────────────────────────
case EYE_STATE.Q_VALUABLE:
    if (state_timer == 30)  _show_line("If you found something valuable...", 200);
    if (state_timer == 100) _show_line("Would you return it?", 220);
    if (state_timer == 130) _show_choice("YES", "NO");
    if (state_timer >= 130 && choice_result != -1) {
        global.eye_profile.return_valuable = (choice_result == 0);
        choice_result = -1;
        _fade_out();
        _goto_state(EYE_STATE.Q_KNOWLEDGE);
    }
break;

// ── Q_KNOWLEDGE ───────────────────────────────────────────────────
case EYE_STATE.Q_KNOWLEDGE:
    if (state_timer == 30)  _show_line("If you possessed rare knowledge...", 200);
    if (state_timer == 100) _show_line("Would you share it?", 220);
    if (state_timer == 130) _show_choice("YES", "NO");
    if (state_timer >= 130 && choice_result != -1) {
        global.eye_profile.share_knowledge = (choice_result == 0);
        choice_result = -1;
        _fade_out();
        _goto_state(EYE_STATE.Q_HEROIC);
    }
break;

// ── Q_HEROIC ──────────────────────────────────────────────────────
case EYE_STATE.Q_HEROIC:
    if (state_timer == 30)  _show_line("Do you consider yourself...", 200);
    if (state_timer == 100) _show_line("...heroic?", 220);
    if (state_timer == 130) _show_choice("YES", "NO");
    if (state_timer >= 130 && choice_result != -1) {
        global.eye_profile.heroic = (choice_result == 0);
        choice_result = -1;
        _fade_out();
        if (!global.eye_profile.heroic)
            _goto_state(EYE_STATE.Q_ALIGNMENT);
        else {
            global.eye_profile.alignment = "heroic";
            _goto_state(EYE_STATE.Q_TEAMWORK);
        }
    }
break;

// ── Q_ALIGNMENT ───────────────────────────────────────────────────
case EYE_STATE.Q_ALIGNMENT:
    if (state_timer == 30)  _show_line("Would you rather...", 200);
    if (state_timer == 100) _show_line("...assist, or oppose?", 220);
    if (state_timer == 130) _show_choice("ASSIST", "OPPOSE");
    if (state_timer >= 130 && choice_result != -1) {
        global.eye_profile.alignment = (choice_result == 0) ? "assist" : "oppose";
        choice_result = -1;
        _fade_out();
        _goto_state(EYE_STATE.Q_TEAMWORK);
    }
break;

// ── Q_TEAMWORK ────────────────────────────────────────────────────
case EYE_STATE.Q_TEAMWORK:
    if (state_timer == 30)  _show_line("Are you good at working with others?", 210);
    if (state_timer == 80)  _show_choice("YES", "NO");
    if (state_timer >= 80 && choice_result != -1) {
        global.eye_profile.teamwork = (choice_result == 0);
        choice_result = -1;
        _fade_out();
        _goto_state(EYE_STATE.Q_REFUSAL);
    }
break;

// ── Q_REFUSAL ─────────────────────────────────────────────────────
case EYE_STATE.Q_REFUSAL:
    if (state_timer == 30) {
        _show_line("Is there anyone you would refuse to work with?", 200);
        _begin_input("name", 30, "They will not hear.");
    }
    if (state_timer >= 30 && !input_active) {
        global.eye_profile.refusal_name = input_string;
        _fade_out();
        animate(eye_distort, 0, 30, anime_curve.linear, id, "eye_distort");
        _eye_pulse_t = 0;
        _goto_state(EYE_STATE.META_PAUSE);
    }
break;

// ── META_PAUSE ────────────────────────────────────────────────────
case EYE_STATE.META_PAUSE:
    if (state_timer == 60)  _show_line("...", 200);
    if (state_timer == 160) _fade_out();
    if (state_timer == 178) _show_line("Are you aware...", 200);
    if (state_timer == 260) _show_line("...that your choices are not your own?", 220);
    if (state_timer == 300) _show_choice("YES", "NO");
    if (state_timer >= 300 && choice_result != -1) {
        global.eye_profile.meta_aware = (choice_result == 0);
        global.eye_profile._lie_meta  = (irandom(2) == 0);
        choice_result = -1;
        _fade_out();
        _goto_state(EYE_STATE.Q_META_REACT);
    }
break;

// ── Q_META_REACT ──────────────────────────────────────────────────
case EYE_STATE.Q_META_REACT:
    if (state_timer == 30)  _show_line("...", 200);
    if (state_timer == 120) _fade_out();
    if (state_timer == 140) {
        inverted = false;
        _goto_state(EYE_STATE.Q_CODENAME);
    }
break;

// ── Q_CODENAME ────────────────────────────────────────────────────
case EYE_STATE.Q_CODENAME:
    if (state_timer == 30 && !codename_active) {
        _show_line("Give yourself a name.", 160);
    }
    if (state_timer == 90 && !codename_active) {
        codename_active = true;
        codename_string = "";
        codename_row    = 0;
        codename_col    = 0;
        codename_done   = false;
    }

    if (codename_active && !codename_done) {
        // Navigation
        if (InputPressed(INPUT_VERB.RIGHT)) {
            codename_col++;
            var _row_len = array_length(codename_keyboard[codename_row]);
            if (codename_col >= _row_len) codename_col = 0;
        }
        if (InputPressed(INPUT_VERB.LEFT)) {
            codename_col--;
            var _row_len = array_length(codename_keyboard[codename_row]);
            if (codename_col < 0) codename_col = _row_len - 1;
        }
        if (InputPressed(INPUT_VERB.DOWN)) {
            codename_row++;
            if (codename_row >= array_length(codename_keyboard)) codename_row = 0;
            codename_col = min(codename_col, array_length(codename_keyboard[codename_row]) - 1);
        }
        if (InputPressed(INPUT_VERB.UP)) {
            codename_row--;
            if (codename_row < 0) codename_row = array_length(codename_keyboard) - 1;
            codename_col = min(codename_col, array_length(codename_keyboard[codename_row]) - 1);
        }

        // Select
        if (InputPressed(INPUT_VERB.SELECT)
        ||  keyboard_check_pressed(vk_enter)
        ||  keyboard_check_pressed(vk_return)) {
            var _key = codename_keyboard[codename_row][codename_col];
            if (_key == "DEL") {
                if (string_length(codename_string) > 0)
                    codename_string = string_delete(codename_string, string_length(codename_string), 1);
            } else if (_key == "END") {
                if (string_length(codename_string) > 0)
                    codename_done = true;
            } else {
                if (string_length(codename_string) < codename_maxlen)
                    codename_string += _key;
            }
        }

        // Cancel = DEL
        if (InputPressed(INPUT_VERB.CANCEL)) {
            if (string_length(codename_string) > 0)
                codename_string = string_delete(codename_string, string_length(codename_string), 1);
        }
    }

    if (codename_done) {
        codename_active = false;
        global.eye_profile.codename = codename_string;
        _fade_out();
        _goto_state(EYE_STATE.FINAL_PAUSE);
    }
break;

// ── FINAL_PAUSE ───────────────────────────────────────────────────
case EYE_STATE.FINAL_PAUSE:
    if (state_timer == 40)  _show_line("Noted.", 200);
    if (state_timer == 120) _fade_out();
    if (state_timer == 200) _show_line("One final question.", 200);
    if (state_timer == 310) _fade_out();
    if (state_timer == 370) _show_line("Will you accept everything that happens from now on?", 200);
    if (state_timer == 430) _show_choice("YES", "NO");
    if (state_timer >= 430 && choice_result != -1) {
        global.eye_profile.final_accept = (choice_result == 0);
        choice_result = -1;
        _save_profile();
        line_alpha     = 0;
        choice_visible = false;
		audio_stop_all()
        _goto_state(EYE_STATE.FLOOD);
    }
break;

// ── FLOOD ─────────────────────────────────────────────────────────
case EYE_STATE.FLOOD:
    flood_timer++;

    // Placeholder rumble while flood text accelerates (replace with dedicated rumble SFX later)
    if (flood_timer == 1 && flood_rumble_handle == -1) {
        if (audio_is_playing(mus_drone))
            audio_stop_sound(mus_drone);
        flood_rumble_handle = audio_play(mus_drone, 1, 0.35, 0.8);
    }

    // Eye stays visible and warps harder over time.
    eye_distort = min(1.35, eye_distort + 0.01);
    eye_xscale = 1 + eye_distort * 0.35 + sin(_eye_pulse_t * 1.4) * 0.06;
    eye_yscale = 1 + eye_distort * 0.85 + sin(_eye_pulse_t * 1.9) * 0.08;

    // Spawn rate starts very fast and escalates to overwhelming density.
    var _spawn_rate = max(1, 4 - flood_timer div 25);
    if (flood_timer mod _spawn_rate == 0) {
        var _is_shiro = (_shiro_spawned < array_length(_shiro_lines)) && (irandom(8) == 0);
        _spawn_flood_line(_is_shiro);
        _spawn_flood_line(false);
        if (flood_timer > 30)  _spawn_flood_line(false);
        if (flood_timer > 60)  _spawn_flood_line(false);
        if (flood_timer > 90)  _spawn_flood_line(false);
        if (flood_timer > 120) _spawn_flood_line(false);
        if (flood_timer > 150) _spawn_flood_line(false);
    }

    // Move all flood lines
    for (var _i = 0; _i < array_length(flood_lines); _i++) {
        var _fl = flood_lines[_i];
        _fl.y    += _fl.spd * (1 + flood_timer * 0.006);
        _fl.alpha = min(1, _fl.alpha + 0.14);
        _fl.rot  += random_range(-0.65, 0.65);
    }

    // Once dense enough, begin whiteout.
    if (array_length(flood_lines) > 120 && flood_timer > 80)
        flood_covered = true;

    if (flood_covered)
        flood_cover_alpha = min(1, flood_cover_alpha + 0.028);

    if (flood_cover_alpha >= 1)
        _goto_state(EYE_STATE.BLACKOUT);
break;
// ── BLACKOUT ──────────────────────────────────────────────────────
case EYE_STATE.BLACKOUT:
    if (state_timer == 1) {
        if (flood_rumble_handle != -1) {
            audio_stop_sound(flood_rumble_handle);
            flood_rumble_handle = -1;
        }
    }

    flood_final_text_alpha = min(1, flood_final_text_alpha + 0.03);

    if (state_timer >= 70) {
        _goto_state(EYE_STATE.TRANSITION);
    }
break;

case EYE_STATE.TRANSITION:
    if (state_timer == 1) {
        if (flood_rumble_handle != -1) {
            audio_stop_sound(flood_rumble_handle);
            flood_rumble_handle = -1;
        }
        room_goto(target_room);
    }
break;

}
