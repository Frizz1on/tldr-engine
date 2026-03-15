trigger_code = function() {
    cutscene_create();
    cutscene_dialogue([
        "* When you open it",
        "* you will f1nally underst4nd what you have been dr3aming about.",
        "* ...",

    ]);
    cutscene_wait_dialogue_finish();
    cutscene_func(method(self, function() { triggered = true; }));
    cutscene_play();
}
