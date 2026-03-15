// Parent Step_2 handles: x = xstart + guipos_x() * parallax_dist_x
event_inherited();

// Add an ever-increasing scroll offset on top of the parallax position.
// This makes the clouds drift slowly rightward independent of player movement.
xstart -= scroll_speed;
