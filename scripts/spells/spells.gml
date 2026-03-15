function item_s_thunderzap() : item_spell() constructor {
    name = ["Thunder Zap"]
    desc = "Holy/Elec damage."
    use_type = ITEM_USE.ENEMY
    tp_cost = 50
    
    use = function(spell_user, target, caller = -1, _name) {
        var __e_obj = o_enc.encounter_data.enemies[target].actor_id;
        cutscene_set_variable(o_enc, "waiting", true);
        cutscene_dialogue(string("{0} casts THUNDER ZAP!", party_getname(spell_user)),, false)
        cutscene_sleep(20);
        cutscene_set_partysprite(spell_user, "rudebuster");
        cutscene_wait_until(function(__name) {
            return party_get_inst(__name).image_index >= 6;
        }, [spell_user]);
        cutscene_func(instance_destroy, [o_ui_dialogue]);
        cutscene_func(function() {
            audio_play(snd_flash);
            o_enc.flash_color = make_color_rgb(255, 255, 120);
            o_enc.flash_alpha = 1;
            o_enc.flash_decay = 0.05;
        });
        cutscene_sleep(6);
        cutscene_func(function(target, spell_user) {
            var __magic = party_getdata(spell_user, "magic");
            var __dmg = round(
                max(1, __magic - 8) * 16
                + 40
                + random(12)
            );
            enc_hurt_enemy(target, __dmg, spell_user);
        }, [target, spell_user]);
        cutscene_sleep(10);
        // FIX: reset Susie back to idle — without this she freezes on the last
        // rudebuster frame for the rest of the turn.
        cutscene_set_partysprite(spell_user, "idle");
        cutscene_set_variable(o_enc, "waiting", false);
    };
    use_args = [name[0]];
}

function item_s_highguard() : item_spell() constructor {
    name = ["High Guard"]
    desc = ["Guard Party."]
    use_type = ITEM_USE.EVERYONE
    tp_cost = 65
    
    use = function(spell_user, target, caller, _name) {
        cutscene_set_variable(o_enc, "waiting", true);
        var __atk = party_getdata(spell_user, "attack");
        var __def = party_getdata(spell_user, "defense");
        var __shield_power = __atk + __def;
        for (var i = 0; i < array_length(global.party_names); ++i) {
            var n = global.party_names[i];
            party_setdata(n, "highcharge_turns", 0);
        }
        for (var i = 0; i < array_length(global.party_names); ++i) {
            var n = global.party_names[i];
            party_setdata(n, "highguard_turns", 2);
            party_setdata(n, "highguard_power", __shield_power);
            var inst = party_get_inst(n);
            if (instance_exists(inst)) {
                instance_create(o_eff_highguard, inst.x, inst.y - 32, inst.depth - 5, {
                    target: inst
                });
            }
        }
        cutscene_dialogue(string("{0} casts a shimmering barrier!", party_getname(spell_user)),, false)
        cutscene_sleep(20);
        cutscene_set_variable(o_enc, "waiting", false);
    };
}
