/// @description one-shot post-fight watcher for the Larry & Berry encounter
// Spawned just before enc_start. Sits dormant during the battle.
// Once o_enc is fully destroyed (win screen done, overworld resumed),
// fires the apology cutscene exactly once, then destroys itself.
fired         = false;
battle_started = false;  // set to true by the trigger once enc_start fires
