/// @description poll each frame — fire the post-fight cutscene once o_enc is gone
if (fired) exit;

// Don't do anything until enc_start has actually been called
if (!battle_started) exit;

// Wait until o_enc is fully gone (win sequence complete)

// Also wait until no cutscene is running — the engine's win cutscene
// (party walk-back, exp screen) runs after o_enc destroys itself.
// cutscene_isvalid returns true while a cutscene instance is alive.
if (cutscene_isvalid()) exit;

fired = true;

// ── POST-FIGHT CUTSCENE ───────────────────────────────────────────────────────
cutscene_create();
cutscene_player_canmove(false);
cutscene_party_follow(false);

cutscene_sleep(200);

// Larry and Berry should still be standing where they were — the engine's win
// sequence only moves actor_id instances tied to encounter_data, not our
// manually-spawned overworld instances.
cutscene_dialogue([
    "{char(larry, 1)}* Hold on.",
    "{char(berry, 1)}* ...",
    "{char(berry, 1)}* You're permitted.",
    "{char(larry, 1)}* BERRY. They're PERMITTED.",
    "{char(ralsei, 1)}* I— what does that mean?",
    "{char(berry, 1)}* It means you're allowed to be here.",
    "{char(susie, 1)}* Allowed by WHO?"
]);

cutscene_dialogue([
    "{char(larry, 1)}* That is not something we're going to get into.",
    "{char(berry, 1)}* We apologise for the trouble.",
    "{char(larry, 1)}* ...Sorry.",
    "{char(ralsei, 1)}* Wait— you can't just—",
    "{char(reggie, 1)}* Ralsei.",
    "{char(reggie, 1)}* Let it go."
]);
cutscene_wait_dialogue_finish();
cutscene_sleep(10);

// Larry and Berry fade out and are destroyed — they will not reappear
cutscene_func(function() {
    if (instance_exists(global.__larry_inst))
        animate(global.__larry_inst.image_alpha, 0, 45, anime_curve.linear, global.__larry_inst, "image_alpha");
    if (instance_exists(global.__barry_inst))
        animate(global.__barry_inst.image_alpha, 0, 45, anime_curve.linear, global.__barry_inst, "image_alpha");
});
cutscene_sleep(50);

cutscene_func(function() {
    if (instance_exists(global.__larry_inst))  instance_destroy(global.__larry_inst);
    if (instance_exists(global.__barry_inst))  instance_destroy(global.__barry_inst);
    if (instance_exists(global.__alarm_flash)) instance_destroy(global.__alarm_flash);
});

cutscene_sleep(15);

// ── PARTY NOTICES THEIR OUTFITS ───────────────────────────────────────────────
// The static shader was deactivated when the encounter started — the party
// can now see each other clearly for the first time.
cutscene_dialogue([
    "{char(susie, 1)}* ...",
    "{char(susie, 1)}* Did anyone else notice we are dressed absolutely insane right now.",
    "{char(ralsei, 1)}* I... I hadn't thought about it.",
    "{char(susie, 1)}* Your little cape thing is one thing but— Reggie. What are you wearing.",
    "{char(reggie, 1)}* ...",
    "{char(reggie, 1)}* It's a hat.",
    "{char(susie, 1)}* Take it off.",
    "{char(reggie, 1)}* I can't.",
    "{char(susie, 1)}* What.",
    "{char(reggie, 1)}* I've tried. It won't come off.",
    "{char(ralsei, 1)}* ...Oh.",
    "{char(susie, 1)}* That's actually terrifying.",
    "{char(reggie, 1)}* Yeah.",
    "{char(reggie, 1)}* ...Let's just find a way out."
]);
cutscene_wait_dialogue_finish();

cutscene_func(function() {
    cutscene_player_canmove(true);
    cutscene_party_follow(true);
    instance_destroy(global.__postfight_watcher);
});

cutscene_play();
