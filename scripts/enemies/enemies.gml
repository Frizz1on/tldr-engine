
function enemy_larry() : enemy() constructor {
    name = "Larry"
    obj  = o_actor_larry
    turn_object = o_turn_larry


    hp        = 680
    max_hp    = 680
    attack    = 14
    defense   = 4
    carrying_money = 120

    mercy     = 0
    mercy_add_pity_percent = 12
    can_spare = true
    freezable = false   

    s_idle  = spr_ex_e_sguy_idle
    s_hurt  = spr_ex_e_sguy_hurt
    s_spare = spr_ex_e_sguy_spare

    acts = [
        {
            name: "Check",
            party: [],
            desc: "Read the room",
            exec: function() {
                encounter_scene_dialogue(
                    "* LARRY - ATK 14 DEF 4{s(10)}{br}{resetx}" +
                    "* A knight in heavy plate with a sword and tower shield.{br}{resetx}" +
                    "* The buzzer on his helm has been going off{br}" +
                    "for so long he can't hear it anymore."
                )
            }
        },
        {
            name: "Bad Joke",
            party: ["kris"],
            desc: "Reggie tries his luck",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)

                cutscene_func(enc_enemy_add_spare, [slot, 35])
                cutscene_func(function(u) {
                    var o = party_get_inst(u)
                    o.sprite_index = asset_get_index($"spr_b{u}_idle")
                }, [user])

                cutscene_dialogue([
                    "{char(reggie, 1)}* Hey big fella. You know your hat's ringin'?",
                    "{char(larry, 1)}* ...",
                    "{char(reggie, 1)}* Maybe try pickin' up.",
                ])
                cutscene_dialogue(
                    "* Larry did not laugh.{s(10)}{br}{resetx}" +
                    "* But his shoulders dropped a little."
                )

                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        },
        {

            name: "Relate",
            party: ["susie"],
            desc: "Amari reaches out",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)

                cutscene_func(enc_enemy_add_spare, [slot, 28])
                cutscene_dialogue([
                    "{char(susie, 1)}* Hey. You look like someone who also gets told to move along a lot.",
                    "{char(larry, 1)}* ...",
                    "{char(susie, 1)}* I'm not- that wasn't an insult. It was- forget it.",
                    "{char(larry, 1)}* ...I understood.",
                ])
                cutscene_dialogue("* Larry felt {col(c_aqua)}acknowledged{col(w)}.")

                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        },
        {

            name: "Stand Ground",
            party: ["ralsei"],
            desc: "Hold the line",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)

                cutscene_func(enc_enemy_add_spare, [slot, 45])
                cutscene_func(function(u) {
                    var o = party_get_inst(u)
                    o.sprite_index = asset_get_index($"spr_b{u}_spell")
                }, [user])
                cutscene_dialogue([
                    "{char(ralsei, 1)}* Stay back. I'll handle this.",
                    "{char(larry, 1)}* ...",
                    "{char(ralsei, 1)}* You're not getting through unless it's over me.",
                ])
                cutscene_sleep(16)
                cutscene_func(function(index) {
                    var __e_obj = o_enc.encounter_data.enemies[index].actor_id
                    enc_enemy_set_tired(index, true)
                    instance_create(
                        o_text_hpchange,
                        __e_obj.x, __e_obj.s_get_middle_y(), __e_obj.depth - 100,
                        { draw: "tired" }
                    )
                }, [slot])
                cutscene_dialogue(
                    "* Larry hesitated.{s(10)}{br}{resetx}" +
                    "* Something about it got to him."
                )
                cutscene_set_partysprite(user, "idle")
                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        },
    ]

    acts_special = {

        susie: {
            exec: function(enemy_slot) {
                enc_enemy_add_spare(enemy_slot, 18)
                cutscene_dialogue(
                    "{char(susie, 1)}* That armour looks heavy. Aren't you tired?"
                )
            }
        },
        ralsei: {
            exec: function(enemy_slot) {
                enc_enemy_add_spare(enemy_slot, 22)
                cutscene_dialogue(
                    "{char(ralsei, 1)}* We don't want to fight you. We really don't."
                )
            }
        },
    }

    recruit = new enemy_recruit_larry()

    dialogue = function(slot) {
        var me = o_enc.encounter_data.enemies[slot]
        if me.mercy >= 100
            return array_shuffle([
                "* Larry lowers his sword slightly.",
                "* Larry stares at the floor.",
                "* The alarm on Larry's helm finally stops.",
            ])[0]
        if me.hp < me.max_hp * 0.35
            return array_shuffle([
                "* LARRY: You hit hard for trespassers.",
                "* LARRY: BERRY — they're not stopping!",
                "* LARRY: I've held this post for thirty years...",
                "* LARRY: ...This isn't going the way I planned.",
            ])[0]
        return array_shuffle([
            "* LARRY: HALT! THIS AREA IS CLOSED.",
            "* LARRY: TURN BACK OR FACE CONSEQUENCES.",
            "* LARRY: I AM WITHIN MY RIGHTS HERE.",
            "* LARRY: BERRY, YOU SEEING THIS?",
            "* LARRY: I'VE GIVEN YOU FAIR WARNING.",
        ])[0]
    }
}


function enemy_berry() : enemy() constructor {
    name = "Berry"
    obj  = o_actor_barry
    turn_object = o_turn_barry

    hp        = 760
    max_hp    = 760
    attack    = 11
    defense   = 7
    carrying_money = 140

    mercy     = 0
    mercy_add_pity_percent = 8
    can_spare = true
    freezable = true

    s_idle  = spr_ex_e_sguy_idle
    s_hurt  = spr_ex_e_sguy_hurt
    s_spare = spr_ex_e_sguy_spare


    acts = [
        {
            name: "Check",
            party: [],
            desc: "Read the room",
            exec: function() {
                encounter_scene_dialogue(
                    "* BERRY - ATK 11 DEF 7{s(10)}{br}{resetx}" +
                    "* A knight carrying two tower shields and no sword.{br}{resetx}" +
                    "* The buzzer on her helm is silent.{br}{resetx}" +
                    "* Seems she turned it off."
                )
            }
        },
        {

            name: "Joke (Again)",
            party: ["kris"],
            desc: "He's on a roll (he isn't)",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)

                var larry_slot = -1
                for (var i = 0; i < array_length(o_enc.encounter_data.enemies); i++) {
                    if is_instanceof(o_enc.encounter_data.enemies[i], enemy_larry) {
                        larry_slot = i; break
                    }
                }
                var larry_joked = (larry_slot >= 0 && enc_enemy_isfighting(larry_slot)
                    && o_enc.encounter_data.enemies[larry_slot].mercy >= 35)

                var gain = larry_joked ? 50 : 20
                cutscene_func(enc_enemy_add_spare, [slot, gain])

                if larry_joked {
                    cutscene_dialogue([
                        "{char(reggie, 1)}* Hey Berry. What do you call a knight with two shields and no sword?",
                        "{char(berry, 1)}* ...",
                        "{char(reggie, 1)}* Prepared.",
                        "{char(berry, 1)}* ......hh.",
                    ])
                    cutscene_dialogue("* Berry made a sound. It might have been a laugh.")
                } else {
                    cutscene_dialogue([
                        "{char(reggie, 1)}* You ever smile under that visor?",
                        "{char(berry, 1)}* ...",
                        "{char(reggie, 1)}* I'm gonna take that as a maybe.",
                    ])
                    cutscene_dialogue("* Berry did not confirm.")
                }

                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        },
        {
            name: "Back Off",
            party: ["susie"],
            desc: "Amari tries intimidation",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)

                cutscene_func(enc_enemy_add_spare, [slot, 40])
                cutscene_dialogue([
                    "{char(susie, 1)}* You want to -- I mean. I'm not scared of you.",
                    "{char(berry, 1)}* ...",
                    "{char(susie, 1)}* Okay I'm a little scared. Happy?",
                    "{char(berry, 1)}* ...",
                    "{char(susie, 1)}* ...That came out weird. I just mean I respect the shields.",
                ])
                cutscene_dialogue(
                    "* Berry lowered one shield by a fraction of an inch.{br}{resetx}" +
                    "* Progress."
                )

                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        },
        {
            name: "Honest",
            party: ["ralsei"],
            desc: "Kris tries something",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)

                cutscene_func(enc_enemy_add_spare, [slot, 55])
                cutscene_func(function(u) {
                    var o = party_get_inst(u)
                    o.sprite_index = asset_get_index($"spr_b{u}_hurt")
                }, [user])
                cutscene_dialogue([
                    "{char(ralsei, 1)}* We are not criminals. We're just trying to get through.",
                    "{char(berry, 1)}* ...",
                    "{char(ralsei, 1)}* We're just as confused about our situation as you are..",
                ])
                cutscene_sleep(20)
                cutscene_dialogue(
                    "* Berry met Kris's eyes for a moment.{br}{resetx}" +
                    "* Something shifted."
                )
                cutscene_set_partysprite(user, "idle")
                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        },
    ]

    acts_special = {
        susie: {
            exec: function(enemy_slot) {
                enc_enemy_add_spare(enemy_slot, 15)
                cutscene_dialogue(
                    "{char(susie, 1)}* ...Two shields. That's kind of a lot."
                )
            }
        },
        ralsei: {
            exec: function(enemy_slot) {
                enc_enemy_add_spare(enemy_slot, 20)
                cutscene_dialogue(
                    "{char(ralsei, 1)}* Please. We're not here to cause trouble."
                )
            }
        },
    }


    dialogue = function(slot) {
        var me = o_enc.encounter_data.enemies[slot]
        if me.mercy >= 100
            return array_shuffle([
                "* Berry stands motionless.",
                "* Berry looks straight ahead.",
                "* The gap in Berry's visor is very still.",
            ])[0]
        if me.hp < me.max_hp * 0.35
            return array_shuffle([
                "* Berry: ...",
                "* Berry shifts her stance.",
                "* Berry's second shield rises.",
                "* Berry: You're better than expected.",
            ])[0]
        return array_shuffle([
            "* Berry: No passage.",
            "* Berry: Turn around.",
            "* Berry: ...",
            "* Berry: Final warning.",
            "* Berry: I will not ask again.",
        ])[0]
    }
}