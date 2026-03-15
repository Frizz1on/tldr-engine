
open_override = method(self, function() {
    if (image_index == 1) {
        empty_callback();
		 cutscene_create();
    cutscene_dialogue([
		"* ...",
        "* ...",
		"* H3ll0?",

    ]);
    cutscene_wait_dialogue_finish();
    cutscene_func(method(self, function() { triggered = false; }));
    cutscene_play();
        exit;
		
    }
   


	

    image_index = 1;
    audio_play(snd_locker);
    screen_shake(5);
    state_add(state_group, id);

    var _item = new item_a_angel_sigil();
    var _txt  = string(loc("item_chest_get"), item_get_name(_item)) + "{p}{c}";
    _txt += item_add(_item);
    dialogue_start(_txt);
});
