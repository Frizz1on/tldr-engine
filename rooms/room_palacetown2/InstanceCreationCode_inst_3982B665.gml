interaction_code = function() {
	triggered = false
    cutscene_create();
    cutscene_player_canmove(false);
    cutscene_party_follow(false);
	if triggered == false {
	 cutscene_dialogue([
        "*  Welcome to Cloud City!",
		"* South: Market and farming district.",
		"* East: Residential and park district.",
		"* North: Docks and Bell Tower.",
        "{char(reggie, 1)}* The docks are probably the easiest way to the veil. ",
		"{char(susie, 1)}* Yeah but we should also get information from the locals before leaving.",
		"{char(ralsei, 1)}* There might also be food!",
		"{char(reggie, 1)}* ...",
		"{char(susie, 1)}* ...",
    ]);
	   cutscene_func(function() {
		triggered = true
    },);

	}
	else {
	cutscene_dialogue([
        "*  Welcome to Cloud City!",
		"* South: Market and farming district.",
		"* East: Residential and park district.",
		"* North: Docks and Bell Tower.",
    ]);}

   
		triggered = true
	    cutscene_player_canmove(true);
		cutscene_party_follow(true);
		cutscene_party_interpolate();
	    cutscene_play();

}