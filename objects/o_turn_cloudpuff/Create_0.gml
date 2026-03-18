event_inherited();
timer_end        = undefined;
allow_same_turns = true;
pattern_pool     = ["gust_hunt", "light_gust"];

// gust_hunt state
warn_x = 0;
warn_y = 0;

// light_gust state — shares warn_x / warn_y above


// --- o_turn_cloudpuff / Other_12 ---
var _solo = (enc_count_fighting_enemies() <= 1);
pattern = _solo ? "gust_hunt" : "light_gust";
event_inherited();
