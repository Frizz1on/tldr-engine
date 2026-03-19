
state_timer++;
_eye_pulse_t += 0.04;

// ── Eye twitch (always running) ───────────────────────────────────
if (irandom(120) == 0)
    eye_twitch = random_range(-3, 3);
else
    eye_twitch = lerp(eye_twitch, 0, 0.15);

eye_yscale = 1 + eye_distort * 0.4 + sin(_eye_pulse_t * 0.7) * 0.02;
eye_xscale = 1 + eye_distort * 0.15;

// ── Inversion progress ────────────────────────────────────────────
if inverted
    _inv_progress = min(1, _inv_progress + 0.018);
else
    _inv_progress = max(0, _inv_progress - 0.018);

bg_color = merge_colour(c_black, c_white, _inv_progress);
fg_color = merge_colour(c_white, c_black, _inv_progress);

// ── Text input capture ────────────────────────────────────────────
if input_active {
    var _ks = keyboard_check_pressed(vk_anykey);
    if keyboard_check_pressed(vk_backspace) {
        if string_length(input_string) > 0
            input_string = string_delete(input_string, string_length(input_string), 1);
    } else if keyboard_check_pressed(vk_return) || keyboard_check_pressed(vk_enter) {
        if string_length(input_string) > 0
            input_active = false;   // Step_0 in each state checks !input_active to advance
    } else {
        // Capture printable characters
        for (var _k = 32; _k < 127; _k++) {
            if keyboard_check_pressed(_k) {
                var _ch = chr(_k);
                if (!keyboard_check(vk_shift)) _ch = string_lower(_ch);
                if string_length(input_string) < input_maxlen
                    input_string += _ch;
            }
        }
    }
}

// ── Yes/No input ──────────────────────────────────────────────────
if choice_visible {
    if InputPressed(INPUT_VERB.LEFT) || InputPressed(INPUT_VERB.RIGHT)
        choice_selection = 1 - choice_selection;
    if InputPressed(INPUT_VERB.SELECT) {
        choice_result  = choice_selection;
        choice_visible = false;
    }
}

// ════════════════════════════════════════════════════════════════════
//  STATE MACHINE
// ════════════════════════════════════════════════════════════════════

switch (state) {

    case EYE_STATE.BOOT:
        // Pure black for 2 seconds, then fade eye in
        if state_timer == 120 {
            animate(0, 0.9, 60, anime_curve.linear, id, "eye_alpha");
            _goto_state(EYE_STATE.EYE_FADEIN);
        }
    break;

    case EYE_STATE.EYE_FADEIN:
        if state_timer == 65 {
            _show_line("Hello.");
            _goto_state(EYE_STATE.CONTACT);
        }
    break;

    case EYE_STATE.CONTACT:
        if state_timer == 80  _swap_line("Can you see me?");
        if state_timer == 160 _swap_line("...");
        if state_timer == 210 _swap_line("Good.");
        if state_timer == 280 {
            _swap_line("Before we begin...");
            _goto_state(EYE_STATE.UNEASE, 80);
        }
    break;

    case EYE_STATE.UNEASE:
        if state_timer == 1  _show_line("I need to understand you.");
        if state_timer == 70 _swap_line("Tell me...");
        if state_timer == 130 {
            _show_line("Are you currently dreaming?", 160);
            _show_choice("YES", "NO");
            _goto_state(EYE_STATE.Q_DREAM);
        }
    break;

    case EYE_STATE.Q_DREAM:
        if choice_result != -1 {
            global.eye_profile.dream_aware = (choice_result == 0);
            // Lie seed — 30% chance we'll invert this later
            global.eye_profile._lie_dream = (irandom(2) == 0);
            choice_result = -1;
            _show_line("...", 200);
            // Eye distorts slightly
            animate(eye_distort, 0.15, 20, anime_curve.sine_in_out, id, "eye_distort");
            call_later(25, time_source_units_frames, method(self, function() {
                animate(eye_distort, 0, 20, anime_curve.sine_in_out, id, "eye_distort");
            }));
            _goto_state(EYE_STATE.Q_DREAM_REACT, 30);
        }
    break;

    case EYE_STATE.Q_DREAM_REACT:
        if state_timer == 1  _show_line("That's interesting.", 200);
        if state_timer == 80 {
            // Invert the screen — white bg, black eye for personality questions
            inverted = true;

			if (!audio_is_playing(mus_k))
			audio_play(mus_k, 0, 1, 1, 0);
            _swap_line("What is your favourite colour?", 160);
            _begin_input("favourite colour", 20);
            _goto_state(EYE_STATE.Q_COLOR);
        }
    break;

    // ── TEXT INPUT STATES ─────────────────────────────────────────
    case EYE_STATE.Q_COLOR:
        if !input_active && string_length(input_string) > 0 {
            global.eye_profile.fav_color = input_string;
            _swap_line("What do you enjoy doing?", 160);
            _begin_input("hobby", 30);
            _goto_state(EYE_STATE.Q_HOBBY, 18);
        }
    break;

    case EYE_STATE.Q_HOBBY:
        if !input_active && string_length(input_string) > 0 {
            global.eye_profile.fav_hobby = input_string;
            _swap_line("What is your favourite food?", 160);
            _begin_input("food", 20);
            _goto_state(EYE_STATE.Q_FOOD, 18);
        }
    break;

    case EYE_STATE.Q_FOOD:
        if !input_active && string_length(input_string) > 0 {
            global.eye_profile.fav_food = input_string;
            // Moral shift — eye grows
            animate(eye_distort, 0.3, 60, anime_curve.cubic_in_out, id, "eye_distort");
            _show_line("...", 200);
            _goto_state(EYE_STATE.MORAL_SHIFT, 40);
        }
    break;

    case EYE_STATE.MORAL_SHIFT:
        if state_timer == 1  _show_line("If you found something valuable...", 180);
        if state_timer == 70 {
            _swap_line("Would you return it?", 200);
            _show_choice("YES", "NO");
            _goto_state(EYE_STATE.Q_VALUABLE);
        }
    break;

    case EYE_STATE.Q_VALUABLE:
        if choice_result != -1 {
            global.eye_profile.return_valuable = (choice_result == 0);
            choice_result = -1;
            _show_line("If you possessed rare knowledge...", 170);
            call_later(60, time_source_units_frames, method(self, function() {
                _swap_line("Would you share it?", 200);
                _show_choice("YES", "NO");
            }));
            _goto_state(EYE_STATE.Q_KNOWLEDGE, 60);
        }
    break;

    case EYE_STATE.Q_KNOWLEDGE:
        if choice_result != -1 {
            global.eye_profile.share_knowledge = (choice_result == 0);
            choice_result = -1;
            _show_line("Do you consider yourself...", 180);
            call_later(60, time_source_units_frames, method(self, function() {
                _swap_line("...heroic?", 200);
                _show_choice("YES", "NO");
            }));
            _goto_state(EYE_STATE.Q_HEROIC, 60);
        }
    break;

    case EYE_STATE.Q_HEROIC:
        if choice_result != -1 {
            global.eye_profile.heroic = (choice_result == 0);
            choice_result = -1;
            if !global.eye_profile.heroic {
                // Ask alignment only if not heroic
                _show_line("Would you rather...", 180);
                call_later(50, time_source_units_frames, method(self, function() {
                    _swap_line("...assist, or oppose?", 200);
                    _show_choice("ASSIST", "OPPOSE");
                }));
                _goto_state(EYE_STATE.Q_ALIGNMENT, 50);
            } else {
                global.eye_profile.alignment = "heroic";
                _show_line("Are you good at working with others?", 200);
                _show_choice("YES", "NO");
                _goto_state(EYE_STATE.Q_TEAMWORK);
            }
        }
    break;

    case EYE_STATE.Q_ALIGNMENT:
        if choice_result != -1 {
            global.eye_profile.alignment = (choice_result == 0) ? "assist" : "oppose";
            choice_result = -1;
            _show_line("Are you good at working with others?", 200);
            _show_choice("YES", "NO");
            _goto_state(EYE_STATE.Q_TEAMWORK);
        }
    break;

    case EYE_STATE.Q_TEAMWORK:
        if choice_result != -1 {
            global.eye_profile.teamwork = (choice_result == 0);
            choice_result = -1;
            _show_line("Is there anyone you would refuse to work with?", 160);
            call_later(20, time_source_units_frames, method(self, function() {
                // Add the invasive subtext
            }));
            _begin_input("name", 30);
            _goto_state(EYE_STATE.Q_REFUSAL, 20);
        }
    break;

    case EYE_STATE.Q_REFUSAL:
        if !input_active {
            global.eye_profile.refusal_name = input_string;
            // Long pause — meta shift
            _swap_line("...", 200);
            animate(eye_distort, 0, 30, anime_curve.linear, id, "eye_distort");
            // Eye goes completely still
            _eye_pulse_t = 0;
            _goto_state(EYE_STATE.META_PAUSE, 60);
        }
    break;

    case EYE_STATE.META_PAUSE:
        // Eye is frozen. Long silence.
        if state_timer == 1  _show_line("", 200);
        if state_timer == 90 {
            _show_line("Are you aware...", 180);
        }
        if state_timer == 160 {
            _swap_line("...that your choices are not your own?", 200);
            _show_choice("YES", "NO");
            _goto_state(EYE_STATE.Q_META);
        }
    break;

    case EYE_STATE.Q_META:
        if choice_result != -1 {
            global.eye_profile.meta_aware = (choice_result == 0);
            global.eye_profile._lie_meta  = (irandom(2) == 0);
            choice_result = -1;
            _goto_state(EYE_STATE.Q_META_REACT);
        }
    break;

    case EYE_STATE.Q_META_REACT:
        // No response. Just silence.
        if state_timer == 1  _show_line("...", 200);
        if state_timer == 100 {
            // Re-invert back to black for naming
            inverted = false;
            _swap_line("Give yourself a name.", 180);
            _goto_state(EYE_STATE.Q_CODENAME, 80);
        }
    break;

    case EYE_STATE.Q_CODENAME:
        if state_timer == 1 && !naming_active {
            naming_active = true;
            naming_done   = false;
            var _naming = instance_create(o_ui_naming, 0, 0, DEPTH_UI.CONSOLE - 10);
            _naming.keyboard_maxchars = 8;
            _naming.caller = id;   // we'll check this instance for completion
        }
        // Wait for naming menu to close
        if naming_active && !instance_exists(o_ui_naming) {
            naming_active = false;
            // Retrieve the name from global (naming menu sets global.party_name or similar)
            // For now store whatever was confirmed
            global.eye_profile.codename = (variable_global_exists("last_naming_result"))
                ? global.last_naming_result : "UNKNOWN";
            _show_line("Noted.", 200);
            _goto_state(EYE_STATE.FINAL_PAUSE, 80);
        }
    break;

    case EYE_STATE.FINAL_PAUSE:
        if state_timer == 1   _show_line("", 200);
        if state_timer == 60  _show_line("One final question.", 200);
        if state_timer == 130 _swap_line("", 200);
        if state_timer == 180 {
            _show_line("Will you accept everything that happens from now on?", 190);
            _show_choice("YES", "NO");
            _goto_state(EYE_STATE.Q_FINAL);
        }
    break;

    case EYE_STATE.Q_FINAL:
        if choice_result != -1 {
            global.eye_profile.final_accept = (choice_result == 0);
            choice_result = -1;
            _save_profile();
            line_alpha = 0;
            choice_visible = false;
            _goto_state(EYE_STATE.FLOOD);
        }
    break;

    case EYE_STATE.FLOOD:
        flood_timer++;

        // Fade eye out
        if flood_timer == 1
            animate(eye_alpha, 0, 40, anime_curve.linear, id, "eye_alpha");

        // Spawn flood lines — start slow, accelerate
        var _spawn_rate = max(1, 18 - flood_timer div 20);
        if flood_timer mod _spawn_rate == 0 {
            var _is_shiro = (_shiro_spawned < array_length(_shiro_lines))
                         && (irandom(12) == 0);
            _spawn_flood_line(_is_shiro);
        }

        // Move and fade all flood lines
        for (var _i = 0; _i < array_length(flood_lines); _i++) {
            var _fl = flood_lines[_i];
            _fl.y      += _fl.spd;
            _fl.alpha   = min(1, _fl.alpha + 0.04);
            _fl.rot    += random_range(-0.1, 0.1);
        }

        // Check if screen is covered
        if array_length(flood_lines) > 120 && flood_timer > 300
            _goto_state(EYE_STATE.BLACKOUT, 60);
    break;

    case EYE_STATE.BLACKOUT:
        if state_timer == 1 {
            animate(bg_alpha, 1, 30, anime_curve.linear, id, "bg_alpha");
        }
        if state_timer == 90
            _goto_state(EYE_STATE.TRANSITION);
    break;

    case EYE_STATE.TRANSITION:
        if state_timer == 1 {
            // White flash then room change
            var _fl = instance_create(o_flash, 0, 0, DEPTH_UI.FADER - 1);
            _fl.color = c_white;
            animate(0, 1, 20, anime_curve.linear, _fl, "image_alpha");
        }
        if state_timer == 40
            room_goto(target_room);
    break;
}