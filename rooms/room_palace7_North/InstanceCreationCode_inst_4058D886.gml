trigger_code = function() {
    cutscene_create();
    cutscene_dialogue([
        "* ...",
        "* It was, though.",
        "* She has been pati3nt.",
        "* Do you remember the last time you felt completely awake?",
		"* The last time you felt alive?"
    ]);
    cutscene_wait_dialogue_finish();
    cutscene_func(method(self, function() { triggered = true; }));
    cutscene_play();
}