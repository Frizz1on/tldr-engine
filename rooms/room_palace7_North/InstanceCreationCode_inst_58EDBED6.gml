trigger_code = function() {
    cutscene_create();
    cutscene_dialogue([
        "* yOu are not the dreameR.",
        "* you have never been the dreameR.",
        "* She w4tches the ones who alm0st remember.",
        "* You almost remember.",
        "* ThE angEl doEs not wAit bEcausE shE is kInd.",
        "*shE kn0ws yOu wiLl aRrivE."
    ]);
    cutscene_wait_dialogue_finish();
    cutscene_func(method(self, function() { triggered = true; }));
    cutscene_play();
}