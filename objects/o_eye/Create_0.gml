depth = DEPTH_UI.CONSOLE;

// ── Target room — change this to your tutorial room ───────────────
target_room = room_tutorial_intro;

// ── Saved profile struct — populated as questions are answered ────
global.eye_profile = {
    dream_aware     : undefined,
    fav_color       : "",
    fav_hobby       : "",
    fav_food        : "",
    return_valuable : undefined,
    share_knowledge : undefined,
    heroic          : undefined,
    alignment       : "",     // "assist" or "oppose" — only if heroic=false
    teamwork        : undefined,
    refusal_name    : "",
    meta_aware      : undefined,
    codename        : "",
    final_accept    : undefined,
    // Lie seed — sometimes we'll use the wrong answer later
    _lie_dream      : false,
    _lie_meta       : false,
};

// ── State machine ─────────────────────────────────────────────────
// States: each maps to a phase of the sequence
enum EYE_STATE {
    BOOT,
    EYE_FADEIN,
    CONTACT,
    UNEASE,
    Q_DREAM,
    Q_DREAM_REACT,
    Q_COLOR,
    Q_HOBBY,
    Q_FOOD,
    MORAL_SHIFT,
    Q_VALUABLE,
    Q_KNOWLEDGE,
    Q_HEROIC_LEAD,     // NEW
    Q_HEROIC,
    Q_ALIGNMENT_LEAD,  // NEW
    Q_ALIGNMENT,
    Q_TEAMWORK,
    Q_REFUSAL,
    META_PAUSE,
    Q_META,
    Q_META_REACT,
    Q_CODENAME,
    FINAL_PAUSE,
    Q_FINAL,
    FLOOD,
    BLACKOUT,
    TRANSITION,
}

state       = EYE_STATE.BOOT;
state_timer = 0;   // frames spent in current state
_next_state = -1;  // queued transition

// ── Visual state ──────────────────────────────────────────────────
bg_color      = c_black;
bg_alpha      = 1;           // background fill alpha
fg_color      = c_white;     // text and eye colour

eye_alpha     = 0;
eye_x         = 320;
eye_y         = 180;
eye_xscale    = 1;
eye_yscale    = 1;
eye_twitch    = 0;           // twitch offset
eye_distort   = 0;           // grows during moral section
_eye_pulse_t  = 0;

// Colour inversion (day/night flip)
inverted      = false;       // true after dream question
_inv_progress = 0;           // 0=black bg, 1=white bg

// ── Text lines drawn manually ─────────────────────────────────────
line_text  = "";
line_alpha = 0;
line_y     = 200;

// ── Yes/No choice state ───────────────────────────────────────────
choice_visible   = false;
choice_selection = 0;   // 0=left, 1=right
choice_label_a   = "YES";
choice_label_b   = "NO";
choice_result    = -1;

// ── Text input (colour, hobby, food, refusal) ─────────────────────
input_active  = false;
input_string  = "";
input_maxlen  = 20;
input_label   = "";
input_hint    = "Begin typing, then press Enter.";

// ── Codename — uses o_ui_naming ───────────────────────────────────
naming_active = false;
naming_done   = false;

// ── ACCEPT EVERYTHING flood ───────────────────────────────────────
flood_lines   = [];    // array of {text, x, y, rot, alpha, speed_y}
flood_timer   = 0;
flood_covered = false;

// ── Shiro whisper lines (rare, appear during flood) ───────────────
_shiro_lines = [
    "THE ANGEL SEES",
    "YOU WILL WAKE",
    "DO NOT RESIST",
    "SHE IS WAITING",
    "THE DREAM IS ENDING",
];
_shiro_spawned = 0;


codename_active   = false;
codename_string   = "";
codename_maxlen   = 8;
codename_row      = 0;
codename_col      = 0;
codename_done     = false;

codename_keyboard = [
    ["A","B","C","D","E","F","G","H","I","J"],
    ["K","L","M","N","O","P","Q","R","S","T"],
    ["U","V","W","X","Y","Z","DEL","END"],
];

// ── Questions list — processed in sequence ───────────────────────
// Built as a simple ordered array of state transitions
// (see Step_0 for the state machine logic)

// ── Keyboard input capture ────────────────────────────────────────
keyboard_string = "";


// ════════════════════════════════════════════════════════════════════
//  HELPER FUNCTIONS (defined as methods on this instance)
// ════════════════════════════════════════════════════════════════════


// Instantly set new text and fade it in
_show_line = method(self, function(txt, target_y = 200) {
    line_text  = txt;
    line_alpha = 0;
    line_y     = target_y;
    animate(0, 1, 22, anime_curve.linear, id, "line_alpha");
});

// Fade current text out, swap, fade in — synchronous, no call_later
// Call this then check state_timer >= t + 38 before showing next line
_fade_out = method(self, function() {
    animate(line_alpha, 0, 14, anime_curve.linear, id, "line_alpha");
});

// _goto_state: NEVER use delay — always use state_timer in the state itself
_goto_state = method(self, function(new_state) {
    state       = new_state;
    state_timer = 0;
});
    

// Show a yes/no choice
_show_choice = method(self, function(label_a = "YES", label_b = "NO") {
    choice_label_a   = label_a;
    choice_label_b   = label_b;
    choice_selection = 0;
    choice_result    = -1;
    choice_visible   = true;
});

// Begin text input mode
_begin_input = method(self, function(label, maxlen = 20, hint = "Begin typing, then press Enter.") {
    input_label   = label;
    input_hint    = hint;
    input_string  = "";
    input_maxlen  = maxlen;
    input_active  = true;
    keyboard_string = "";
});

// Save profile to JSON file
_save_profile = method(self, function() {
    var _path = working_directory + "eye_profile.json";
    var _f    = file_text_open_write(_path);
    file_text_write_string(_f, json_stringify(global.eye_profile));
    file_text_close(_f);
});

// Spawn one flood line
_spawn_flood_line = method(self, function(is_shiro = false) {
    var _text = is_shiro
        ? _shiro_lines[_shiro_spawned++ mod array_length(_shiro_lines)]
        : "ACCEPT EVERYTHING";
    var _spawn_from_top = (irandom(1) == 0);
    var _spawn_y = (_spawn_from_top ? -1 : 1) * (240 + random(80));

    array_push(flood_lines, {
        text   : _text,
        x      : random(640),
        y      : _spawn_y,
        rot    : random_range(-8, 8),
        alpha  : 0,
        spd    : random_range(0.6, 1.8) * (_spawn_from_top ? 1 : -1),
        col    : is_shiro ? make_color_rgb(180, 60, 60) : c_white,
        scale  : random_range(0.8, 1.4),
    });
});