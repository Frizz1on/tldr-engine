/// @description box is created — pick patterns for both phases
event_inherited();   // parent assigns pattern from pattern_pool; we override below

// Pick Larry's pattern for phase 0
larry_pattern = array_shuffle(larry_pattern_pool)[0];

// Pick Berry's pattern for phase 1 — avoid same pattern twice in a row if possible
var shuffled = array_shuffle(berry_pattern_pool);
berry_pattern = shuffled[0];
