trigger_code = function() {
    cutscene_create();
    cutscene_dialogue([
        "* You found this.",
        "* You came north but.",
        "* The sign was not for you."
    ]);
    cutscene_wait_dialogue_finish();
    cutscene_func(method(self, function() { triggered = true; }));
    cutscene_play();
}