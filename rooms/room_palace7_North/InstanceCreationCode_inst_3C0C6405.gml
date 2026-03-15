trigger_code = function() {
    cutscene_create();
    cutscene_dialogue([
        "* The dream kn0ws your face better than you d0.",
        "* Someone painted these walls before you arrived.",
        "* Someone who knew you were c0ming.",
        "* Cl4rity is not a gift.",
        "* It the final breath."
    ]);
    cutscene_wait_dialogue_finish();
    cutscene_func(method(self, function() { triggered = true; }));
    cutscene_play();
}