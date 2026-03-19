state          = 0;
timer          = 0;
freezeframe    = -1;
freezeframe_gui = -1;
ui_alpha       = 0;
fader_alpha    = 0;
inst_dialogue  = noone;
dia_created    = false;
confirm_pressed = 0;
selection      = -1;
soulx          = 320;
souly          = 360 + 20;
image_alpha    = 0;

// Eye visual state
eye_alpha    = 0;
eye_x        = 320;
eye_y        = 160;
eye_xscale   = 1;
eye_yscale   = 1;
eye_twitch   = 0;
_eye_pulse_t = 0;

// Track deaths — first death gets the full speech, subsequent get a random quote
if (!variable_global_exists("eye_deaths"))
    global.eye_deaths = 0;

_is_first_death = (global.eye_deaths == 0);
global.eye_deaths++;

// First death: three-line intro sequence then choice
// Subsequent deaths: one random quote then choice immediately
_death_lines_first = [
    "It seems a horrible fate has befallen you.",
    "Do not worry, for I have given you endless chances.",
    "I vowed to give you my love, after all.",
];
_death_line_index = 0;

_death_quotes_repeat = [
    "Again?",
    "Back so soon.",
    "I told you I would be here.",
    "Do not be discouraged.",
    "You will find your way.",
    "Each time you fall, I watch.",
    "This too is part of it.",
    "I have not forgotten you.",
    "Rise.",
    "Still here. Still waiting.",
    "The dream does not end with a fall.",
    "You are more resilient than you know.",
    "My patience is without limit.",
    "I told you. Endless chances.",
];

_retry_line    = "Very well then. Shall we return?";
_give_up_line  = "Very well then. I shall see you when you return.";

// Eye phase: 0 = waiting, 1 = speaking, 2 = choice, 3 = resolving
_eye_phase     = 0;
_eye_line_done = false;

// Choice labels
choice = ["RETURN", "GIVE UP"];
