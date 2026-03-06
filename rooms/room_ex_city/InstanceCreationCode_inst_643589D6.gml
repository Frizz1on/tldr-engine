count = 0
trigger_code = function() { 
	cutscene_create()
	if count == 0 {
		cutscene_dialogue([
			  "{char(reggie, 1)}* No reason for us to go back there."
		])
    }
    else {
		cutscene_dialogue([
			"* Theres a monster there.",
		])
	}
	cutscene_func(function() {
		actor_move(get_leader(), new actor_movement(20, 0, 30,,, DIR.LEFT, false))
	})
    
	cutscene_sleep(20)
	cutscene_set_variable(id, "triggered", false)
	cutscene_party_interpolate()
	cutscene_play()
	
	count++
}