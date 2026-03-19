depth = DEPTH_UI.CONSOLE;

target_room = room_tutorial_intro;

global.eye_profile = {
    dream_aware     : undefined,
    fav_color       : "",
    fav_hobby       : "",
    fav_food        : "",
    return_valuable : undefined,
    share_knowledge : undefined,
    heroic          : undefined,
    alignment       : "",
    teamwork        : undefined,
    refusal_name    : "",
    meta_aware      : undefined,
    codename        : "",
    final_accept    : undefined,
    _lie_dream      : false,
    _lie_meta       : false,
};

enum EYE_STATE {
    BOOT,
    CONTACT,
    Q_DREAM,
    Q_DREAM_REACT,
    Q_COLOR,
    Q_HOBBY,
    Q_FOOD,
    Q_VALUABLE,
    Q_KNOWLEDGE,
    Q_HEROIC,
    Q_ALIGNMENT,
    Q_TEAMWORK,
    Q_REFUSAL,
    META_PAUSE,
    Q_META_REACT,
    Q_CODENAME,
    FINAL_PAUSE,
    Q_FINAL,
    FLOOD,
    BLACKOUT,
    TRANSITION,
}

state       = EYE_STATE.BOOT;
state_timer = 0;

bg_color      = c_black;
bg_alpha      = 1;
fg_color      = c_white;

eye_alpha     = 0;
eye_x         = 320;
eye_y         = 180;
eye_xscale    = 1;
eye_yscale    = 1;
eye_twitch    = 0;
eye_distort   = 0;
_eye_pulse_t  = 0;

inverted      = false;
_inv_progress = 0;

line_text  = "";
line_alpha = 0;
line_y     = 200;

choice_visible   = false;
choice_selection = 0;
choice_label_a   = "YES";
choice_label_b   = "NO";
choice_result    = -1;

input_active  = false;
input_string  = "";
input_maxlen  = 20;
input_label   = "";
input_hint    = "Begin typing, then press Enter.";

flood_lines            = [];
flood_timer            = 0;
flood_covered          = false;
flood_cover_alpha      = 0;
flood_final_text       = "My love shall become yours";
flood_final_text_alpha = 0;
flood_rumble_handle    = -1;

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

// ── Helper functions ──────────────────────────────────────────────

_show_line = method(self, function(txt, target_y) {
    if (is_undefined(target_y)) target_y = 200;
    line_text  = txt;
    line_alpha = 0;
    line_y     = target_y;
    animate(0, 1, 22, anime_curve.linear, id, "line_alpha");
});

_fade_out = method(self, function() {
    animate(line_alpha, 0, 14, anime_curve.linear, id, "line_alpha");
});

_goto_state = method(self, function(new_state) {
    state       = new_state;
    state_timer = 0;
});

_show_choice = method(self, function(label_a, label_b) {
    if (is_undefined(label_a)) label_a = "YES";
    if (is_undefined(label_b)) label_b = "NO";
    choice_label_a   = label_a;
    choice_label_b   = label_b;
    choice_selection = 0;
    choice_result    = -1;
    choice_visible   = true;
});

_begin_input = method(self, function(label, maxlen, hint) {
    if (is_undefined(maxlen)) maxlen = 20;
    if (is_undefined(hint))   hint   = "Begin typing, then press Enter.";
    input_label   = label;
    input_hint    = hint;
    input_string  = "";
    input_maxlen  = maxlen;
    input_active  = true;
});

_save_profile = method(self, function() {
    var _path = working_directory + "eye_profile.json";
    var _f    = file_text_open_write(_path);
    file_text_write_string(_f, json_stringify(global.eye_profile));
    file_text_close(_f);
});

_spawn_flood_line = method(self, function(is_shiro) {
    if (is_undefined(is_shiro)) is_shiro = false;
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _text = is_shiro
        ? _shiro_lines[_shiro_spawned++ mod array_length(_shiro_lines)]
        : "ACCEPT EVERYTHING";
    var _from_top = (irandom(1) == 0);
    var _entry_y  = _from_top
        ? (-30 - random(50))
        : (_gh + 10 + random(50));
    var _spd = random_range(1.2, 3.5) * (_from_top ? 1 : -1);
    var _line = {
        text  : _text,
        x     : random(_gw),
        y     : _entry_y,
        rot   : random_range(-12, 12),
        alpha : 0,
        spd   : _spd,
        col   : is_shiro ? make_color_rgb(220, 80, 80) : c_white,
        scale : random_range(0.7, 1.8),
    };
    array_push(flood_lines, _line);
});