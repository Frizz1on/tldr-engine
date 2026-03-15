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
                }, [u])
                cutscene_dialogue([
                    "{char(ralsei, 1)}* I got this.",
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
        reggie: {
            exec: function(enemy_slot) {
                enc_enemy_add_spare(enemy_slot, 25)
                cutscene_dialogue(
                    "{char(reggie, 1)}* Y'all ever think about just... takin' the day off?"
                )
            }
        },
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
                "* You hit hard for trespassers.",
                "*  BERRY they're not stopping!",
                "* I've held this post for thirty years...",
                "*  ...This isn't going the way I planned.",
            ])[0]
        return array_shuffle([
            "* HALT! THIS AREA IS CLOSED.",
            "* TURN BACK OR FACE CONSEQUENCES.",
            "* I AM WITHIN MY RIGHTS HERE.",
            "*  BERRY, YOU SEEING THIS?",
            "*  I'VE GIVEN YOU FAIR WARNING.",
        ])[0]
    }
}

function enemy_berry() : enemy() constructor {
    name = "Berry"
    obj  = o_actor_barry
    turn_object =o_turn_barry
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
            // FIX: was party: ["kris"] — changed to "reggie"
            name: "Joke",
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
                    "* ..."
                )
                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        },
        {
            name: "Honest",
            party: ["ralsei"],
            desc: "Kris loses patience",
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
                    "{char(ralsei, 1)}* We're just as confused about our situation as you are.",
                ])
                cutscene_sleep(20)
                cutscene_dialogue(
                    "* Berry met Kris' eyes for a moment.{br}{resetx}" +
                    "* Something shifted."
                )
                cutscene_set_partysprite(user, "idle")
                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        },
    ]
    acts_special = {
        reggie: {
            // FIX: added reggie entry to match Joke (Again) party assignment
            exec: function(enemy_slot) {
                enc_enemy_add_spare(enemy_slot, 18)
                cutscene_dialogue(
                    "{char(reggie, 1)}* You're real good at standin' still. I admire that."
                )
            }
        },
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
            ])[0]
        if me.hp < me.max_hp * 0.35
            return array_shuffle([
                "* You're better than expected.",
            ])[0]
        return array_shuffle([
            "* No passage.",
            "* Turn around.",
            "*  ...",
            "*  Final warning.",
            "*  I will not ask again.",
        ])[0]
    }
}

function enemy_sentinel() : enemy() constructor {
    name       = "Sentinel"
    obj        = o_actor_barry_1
    turn_object = o_turn_sentinel

    hp         = 380
    max_hp     = 380
    attack     = 10
    defense    = 3
    carrying_money = 55
    mercy      = 0
    mercy_add_pity_percent = 15
    can_spare  = true
    freezable  = false

    s_idle  = spr_ex_e_sguy_idle
    s_hurt  = spr_ex_e_sguy_hurt
    s_spare = spr_ex_e_sguy_spare

    acts = [
        {
            name: "Check",
            party: [],
            desc: "Scan the unit",
            exec: function() {
                encounter_scene_dialogue(
                    "* SENTINEL - ATK 10 DEF 3{s(10)}{br}{resetx}" +
                    "* An automated patrol drone. It has been watching this corridor{br}" +
                    "for longer than it can calculate.{br}{resetx}" +
                    "* It doesn't know what it's guarding anymore."
                )
            }
        },
        {
            name: "Stand Down",
            party: ["kris"],
            desc: "Issue a command",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)
                cutscene_func(enc_enemy_add_spare, [slot, 40])
                cutscene_dialogue([
                    "{char(reggie, 1)}* Hey. Stand down.",
                    "* The Sentinel rotates to face Reggie.",
                    "* It holds.",
                    "* It keeps holding.",
                ])
                cutscene_dialogue(
                    "* ...Command not recognised.{s(10)}{br}{resetx}" +
                    "* But it stopped moving for a moment."
                )
                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        },
        {
            name: "Wave",
            party: ["susie"],
            desc: "??",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)
                cutscene_func(enc_enemy_add_spare, [slot, 30])
                cutscene_dialogue([
                    "{char(susie, 1)}* ...",
                    "{char(susie, 1)}* I don't know why I'm doing this.",
                ])
                cutscene_func(function(u) {
                    var o = party_get_inst(u)
                    o.sprite_index = asset_get_index($"spr_b{u}_idle")
                }, [user])
                cutscene_dialogue(
                    "* The Sentinel's scan light flickers once.{br}{resetx}" +
                    "* It might have been a wave back."
                )
                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        },
        {
            name: "Decommission",
            party: ["ralsei"],
            desc: "Put it to rest",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)
                cutscene_func(enc_enemy_add_spare, [slot, 55])
                cutscene_func(function(u) {
                    var o = party_get_inst(u)
                    o.sprite_index = asset_get_index($"spr_b{u}_spell")
                }, [user])
                cutscene_dialogue([
                    "{char(ralsei, 1)}* You've been here a long time, haven't you.",
                    "{char(ralsei, 1)}* It's okay. You don't have to keep going.",
                ])
                cutscene_sleep(20)
                cutscene_func(function(index) {
                    enc_enemy_set_tired(index, true)
                    var __e_obj = o_enc.encounter_data.enemies[index].actor_id
                    instance_create(o_text_hpchange, __e_obj.x, __e_obj.s_get_middle_y(), __e_obj.depth - 100, { draw: "tired" })
                }, [slot])
                cutscene_dialogue("* The Sentinel's light dims to a low idle pulse.")
                cutscene_set_partysprite(user, "idle")
                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        },
    ]
    acts_special = {
        susie: {
            exec: function(enemy_slot) {
                enc_enemy_add_spare(enemy_slot, 20)
                cutscene_dialogue("{char(reggie, 1)}* Just doing your job, huh. I get it.")
            }
        },
        ralsei: {
            exec: function(enemy_slot) {
                enc_enemy_add_spare(enemy_slot, 25)
                cutscene_dialogue("{char(ralsei, 1)}* We're not a threat. Please, just let us through.")
            }
        },
    }
    recruit = new enemy_recruit_sentinel()
    dialogue = function(slot) {
        var me = o_enc.encounter_data.enemies[slot]
        if me.mercy >= 100
            return array_shuffle([
                "* Patrol suspended.",
                "* The Sentinel hovers in place. Its light is soft.",
                "* The Sentinel idles in standby mode.",
            ])[0]
        if me.hp < me.max_hp * 0.35
            return array_shuffle([
                "* Warning: unit integrity is critically low.",
                "* Secondary protocol engaged.",
                "* The Sentinel blocks the route forward.",
            ])[0]
        return array_shuffle([
            "* Intruder detected.",
            "* Halt. This area is restricted.",
            "* The Sentinel scans for movement.",
            "* Access denied.",
            "* Return to authorised zones.",
        ])[0]
    }
}


// ── 2. BLOOMGUARD ────────────────────────────────────────────────────────────
// A territorial plant creature from the palace gardens. Slow, stubborn,
// surprisingly polite if you're gentle back.
// Attacks: "thorn_wave" (solo) / "thorn_sniper" (group-safe)
function enemy_bloomguard() : enemy() constructor {
    name       = "Bloomguard"
    obj        = o_actor_bloomguard
    turn_object = o_turn_bloomguard

    hp         = 460
    max_hp     = 460
    attack     = 9
    defense    = 5
    carrying_money = 60
    mercy      = 0
    mercy_add_pity_percent = 12
    can_spare  = true
    freezable  = true

    s_idle  = spr_ex_e_sguy_idle
    s_hurt  = spr_ex_e_sguy_hurt
    s_spare = spr_ex_e_sguy_spare

    acts = [
        {
            name: "Check",
            party: [],
            desc: "Observe it carefully",
            exec: function() {
                encounter_scene_dialogue(
                    "* BLOOMGUARD - ATK 9 DEF 5{s(10)}{br}{resetx}" +
                    "* A large plant-based guardian that has been growing in the palace{br}" +
                    "gardens for an indeterminate amount of time.{br}{resetx}" +
                    "* It looks after the other plants. It does not want you near them."
                )
            }
        },
        {
            name: "Compliment",
            party: ["kris"],
            desc: "Say something nice",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)
                cutscene_func(enc_enemy_add_spare, [slot, 35])
                cutscene_dialogue([
                    "{char(reggie, 1)}* You've got a lot of flowers. That's actually impressive.",
                    "* The Bloomguard rustles.",
                    "* Several petals open wider.",
                ])
                cutscene_dialogue("* The Bloomguard seems {col(c_lime)}pleased{col(w)}.")
                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        },
        {
            name: "Back Away",
            party: ["susie"],
            desc: "Give it space",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)
                cutscene_func(enc_enemy_add_spare, [slot, 45])
                cutscene_dialogue([
                    "{char(susie, 1)}* Fine. Fine! I wasn't going near your plants.",
                    "{char(susie, 1)}* They're not even that impressive.",
                    "* ...",
                    "{char(susie, 1)}* Okay they're a little impressive.",
                ])
                cutscene_dialogue("* The Bloomguard lowers its vines slightly.")
                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        },
        {
            name: "Tend",
            party: ["ralsei"],
            desc: "Help with the garden",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)
                cutscene_func(enc_enemy_add_spare, [slot, 60])
                cutscene_func(function(u) {
                    var o = party_get_inst(u)
                    o.sprite_index = asset_get_index($"spr_b{u}_spell")
                }, [user])
                cutscene_dialogue([
                    "{char(ralsei, 1)}* Oh— these ones are a bit wilted. May I?",
                    "* The Bloomguard watches.",
                    "* It does not stop him.",
                ])
                cutscene_sleep(20)
                cutscene_func(function(index) {
                    enc_enemy_set_tired(index, true)
                    var __e_obj = o_enc.encounter_data.enemies[index].actor_id
                    instance_create(o_text_hpchange, __e_obj.x, __e_obj.s_get_middle_y(), __e_obj.depth - 100, { draw: "tired" })
                }, [slot])
                cutscene_dialogue("* The Bloomguard settles. It seems content.")
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
                cutscene_dialogue("{char(reggie, 1)}* Those thorns are something else.")
            }
        },
        susie: {
            exec: function(enemy_slot) {
                enc_enemy_add_spare(enemy_slot, 22)
                cutscene_dialogue("{char(susie, 1)}* I'm not touching anything, okay?")
            }
        },
    }
    recruit = new enemy_recruit_bloomguard()
    dialogue = function(slot) {
        var me = o_enc.encounter_data.enemies[slot]
        if me.mercy >= 100
            return array_shuffle([
                "* The Bloomguard sways gently.",
                "* Its thorns retract.",
                "* Several flowers have opened fully.",
            ])[0]
        if me.hp < me.max_hp * 0.35
            return array_shuffle([
                "* BLOOMGUARD: You shouldn't have come here.",
                "* The Bloomguard's flowers close tight.",
                "* Its vines are trembling.",
            ])[0]
        return array_shuffle([
            "* BLOOMGUARD: Stay back.",
            "* BLOOMGUARD: This garden is not yours.",
            "* The Bloomguard's thorns bristle.",
            "* BLOOMGUARD: I warned you.",
            "* BLOOMGUARD: Leave.",
        ])[0]
    }
}


// ── 3. CLOUDPUFF ─────────────────────────────────────────────────────────────
// A soft, ambient cloud creature. Non-confrontational until provoked.
// Drifts through the palace naturally. Very confused by aggression.
// Attacks: "gust_hunt" (solo) / "light_gust" (group-safe)
function enemy_cloudpuff() : enemy() constructor {
    name       = "Cloudpuff"
    obj        = o_actor_cloudpuff
    turn_object = o_turn_cloudpuff

    hp         = 280
    max_hp     = 280
    attack     = 7
    defense    = 0
    carrying_money = 40
    mercy      = 0
    mercy_add_pity_percent = 20
    can_spare  = true
    freezable  = true

    s_idle  = spr_ex_e_sguy_idle
    s_hurt  = spr_ex_e_sguy_hurt
    s_spare = spr_ex_e_sguy_spare

    acts = [
        {
            name: "Check",
            party: [],
            desc: "Try to understand it",
            exec: function() {
                encounter_scene_dialogue(
                    "* CLOUDPUFF - ATK 7 DEF 0{s(10)}{br}{resetx}" +
                    "* A wandering cloud creature native to the sky palace.{br}{resetx}" +
                    "* It doesn't really want to fight.{br}{resetx}" +
                    "* It just doesn't know what else to do when startled."
                )
            }
        },
        {
            name: "Calm Down",
            party: ["kris"],
            desc: "Don't startle it",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)
                cutscene_func(enc_enemy_add_spare, [slot, 40])
                cutscene_dialogue([
                    "{char(reggie, 1)}* Hey. Easy. We're just passing through.",
                    "* The Cloudpuff bobs.",
                    "* It bobs again, slower.",
                ])
                cutscene_dialogue("* It seems to be calming down.")
                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        },
        {
            name: "Float With It",
            party: ["susie"],
            desc: "Just vibe",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)
                cutscene_func(enc_enemy_add_spare, [slot, 35])
                cutscene_dialogue([
                    "{char(susie, 1)}* ...Okay. You know what. I'm just going to stand here.",
                    "* The Cloudpuff drifts closer.",
                    "{char(susie, 1)}* Oh. Hi.",
                ])
                cutscene_dialogue("* The Cloudpuff nuzzles Amari. Sort of.")
                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        },
        {
            name: "Hum",
            party: ["ralsei"],
            desc: "Music soothes",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)
                cutscene_func(enc_enemy_add_spare, [slot, 60])
                cutscene_dialogue([
                    "{char(ralsei, 1)}* ...",
                    "* Ralsei hums something soft.",
                    "* The Cloudpuff's gusts slow to almost nothing.",
                ])
                cutscene_sleep(16)
                cutscene_func(function(index) {
                    enc_enemy_set_tired(index, true)
                    var __e_obj = o_enc.encounter_data.enemies[index].actor_id
                    instance_create(o_text_hpchange, __e_obj.x, __e_obj.s_get_middle_y(), __e_obj.depth - 100, { draw: "tired" })
                }, [slot])
                cutscene_dialogue("* The Cloudpuff drifts in small, lazy circles.")
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
                cutscene_dialogue("{char(reggie, 1)}* You're not so bad.")
            }
        },
        ralsei: {
            exec: function(enemy_slot) {
                enc_enemy_add_spare(enemy_slot, 22)
                cutscene_dialogue("{char(ralsei, 1)}* It's all right. We won't hurt you.")
            }
        },
    }
    recruit = new enemy_recruit_cloudpuff()
    dialogue = function(slot) {
        var me = o_enc.encounter_data.enemies[slot]
        if me.mercy >= 100
            return array_shuffle([
                "* The Cloudpuff drifts in place.",
                "* It makes a very small, soft sound.",
                "* The Cloudpuff has stopped gusting.",
            ])[0]
        if me.hp < me.max_hp * 0.35
            return array_shuffle([
                "* The Cloudpuff looks miserable.",
                "* It's raining slightly, just around it.",
                "* CLOUDPUFF: ...pff.",
            ])[0]
        return array_shuffle([
            "* The Cloudpuff gusts nervously.",
            "* CLOUDPUFF: Fwff!",
            "* It doesn't want to be here either.",
            "* CLOUDPUFF: ...",
            "* The Cloudpuff swells and contracts.",
        ])[0]
    }
}


// ── 4. MIRRORSHADE ───────────────────────────────────────────────────────────
// A shard of dream glass that has gained awareness. It reflects things
// imperfectly — showing you a version of yourself that isn't quite right.
// Attacks: "shard_ring" (solo) / "single_shard" (group-safe)
function enemy_mirrorshade() : enemy() constructor {
    name       = "Mirrorshade"
    obj        = o_actor_mirrorshade
    turn_object = o_turn_mirrorshade

    hp         = 320
    max_hp     = 320
    attack     = 11
    defense    = 2
    carrying_money = 50
    mercy      = 0
    mercy_add_pity_percent = 18
    can_spare  = true
    freezable  = false

    s_idle  = spr_ex_e_sguy_idle
    s_hurt  = spr_ex_e_sguy_hurt
    s_spare = spr_ex_e_sguy_spare

    acts = [
        {
            name: "Check",
            party: [],
            desc: "Look at it directly",
            exec: function() {
                encounter_scene_dialogue(
                    "* MIRRORSHADE - ATK 11 DEF 2{s(10)}{br}{resetx}" +
                    "* A fragment of the palace's reflective architecture.{br}{resetx}" +
                    "* It shows you things. Not quite accurately.{br}{resetx}" +
                    "* Looking at it too long makes your head hurt."
                )
            }
        },
        {
            name: "Look Away",
            party: ["kris"],
            desc: "Don't give it an audience",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)
                cutscene_func(enc_enemy_add_spare, [slot, 38])
                cutscene_dialogue([
                    "{char(reggie, 1)}* I'm not gonna look.",
                    "* The Mirrorshade flickers.",
                    "* Its reflection dims.",
                ])
                cutscene_dialogue("* Without an audience, it seems uncertain.")
                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        },
        {
            name: "Shout At It",
            party: ["susie"],
            desc: "Reject the reflection",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)
                cutscene_func(enc_enemy_add_spare, [slot, 45])
                cutscene_dialogue([
                    "{char(susie, 1)}* That's NOT what I look like!",
                    "* The Mirrorshade shatters slightly at the edges.",
                    "{char(susie, 1)}* I look WAY cooler than that.",
                ])
                cutscene_dialogue("* The Mirrorshade's image distorts with what might be embarrassment.")
                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        },
        {
            name: "Accept",
            party: ["ralsei"],
            desc: "Sit with the reflection",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)
                cutscene_func(enc_enemy_add_spare, [slot, 60])
                cutscene_func(function(u) {
                    var o = party_get_inst(u)
                    o.sprite_index = asset_get_index($"spr_b{u}_spell")
                }, [user])
                cutscene_dialogue([
                    "{char(ralsei, 1)}* ...",
                    "{char(ralsei, 1)}* That's how you see me?",
                    "{char(ralsei, 1)}* That's okay.",
                ])
                cutscene_sleep(20)
                cutscene_func(function(index) {
                    enc_enemy_set_tired(index, true)
                    var __e_obj = o_enc.encounter_data.enemies[index].actor_id
                    instance_create(o_text_hpchange, __e_obj.x, __e_obj.s_get_middle_y(), __e_obj.depth - 100, { draw: "tired" })
                }, [slot])
                cutscene_dialogue("* The Mirrorshade goes still.{br}{resetx}* Its surface becomes calm.")
                cutscene_set_partysprite(user, "idle")
                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        },
    ]
    acts_special = {
        susie: {
            exec: function(enemy_slot) {
                enc_enemy_add_spare(enemy_slot, 20)
                cutscene_dialogue("{char(susie, 1)}* Yeah, I don't love what I'm seeing either.")
            }
        },
        ralsei: {
            exec: function(enemy_slot) {
                enc_enemy_add_spare(enemy_slot, 25)
                cutscene_dialogue("{char(ralsei, 1)}* A reflection is just a reflection. It doesn't define you.")
            }
        },
    }
    recruit = new enemy_recruit_mirrorshade()
    dialogue = function(slot) {
        var me = o_enc.encounter_data.enemies[slot]
        if me.mercy >= 100
            return array_shuffle([
                "* The Mirrorshade's surface is completely still.",
                "* It reflects nothing now. Just light.",
                "* MIRRORSHADE: ...",
            ])[0]
        if me.hp < me.max_hp * 0.35
            return array_shuffle([
                "* The Mirrorshade is cracked across one corner.",
                "* Its reflection keeps stuttering.",
                "* MIRRORSHADE: You don't want to see this.",
            ])[0]
        return array_shuffle([
            "* The Mirrorshade shows you something.",
            "* MIRRORSHADE: Look closer.",
            "* Your reflection in it is slightly wrong.",
            "* MIRRORSHADE: Doesn't it look familiar?",
            "* The image shifts before you can read it.",
        ])[0]
    }
}


// ── 5. HOLLOWBELL ────────────────────────────────────────────────────────────
// A palace bell that fell from its tower and never stopped ringing.
// It rings to call things. It doesn't know what it's calling anymore.
// Attacks: "bell_wave" (solo) / "short_ring" (group-safe)
function enemy_hollowbell() : enemy() constructor {
    name       = "Hollowbell"
    obj        = o_actor_hollowbell
    turn_object = o_turn_hollowbell

    hp         = 410
    max_hp     = 410
    attack     = 8
    defense    = 6
    carrying_money = 65
    mercy      = 0
    mercy_add_pity_percent = 14
    can_spare  = true
    freezable  = false

    s_idle  = spr_ex_e_sguy_idle
    s_hurt  = spr_ex_e_sguy_hurt
    s_spare = spr_ex_e_sguy_spare

    acts = [
        {
            name: "Check",
            party: [],
            desc: "Listen carefully",
            exec: function() {
                encounter_scene_dialogue(
                    "* HOLLOWBELL - ATK 8 DEF 6{s(10)}{br}{resetx}" +
                    "* A large ceremonial bell that broke free from the palace tower.{br}{resetx}" +
                    "* It has been ringing ever since. Nobody came.{br}{resetx}" +
                    "* It keeps ringing anyway."
                )
            }
        },
        {
            name: "Ring Back",
            party: ["kris"],
            desc: "Answer it somehow",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)
                cutscene_func(enc_enemy_add_spare, [slot, 40])
                cutscene_dialogue([
                    "* Reggie finds a small stone and taps the Hollowbell once.",
                    "* A clear tone rings out.",
                    "* The Hollowbell goes quiet for a moment.",
                ])
                cutscene_dialogue("* HOLLOWBELL: ...{s(15)}{br}{resetx}* It rings again. Much softer.")
                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        },
        {
            name: "Cover Your Ears",
            party: ["susie"],
            desc: "Tough it out",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)
                cutscene_func(enc_enemy_add_spare, [slot, 28])
                cutscene_dialogue([
                    "{char(susie, 1)}* Would you STOP—",
                    "* The Hollowbell pauses mid-ring.",
                    "* It seems surprised anyone could hear it.",
                ])
                cutscene_dialogue("* The Hollowbell rings once, tentatively, then stops.")
                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        },
        {
            name: "Silence",
            party: ["ralsei"],
            desc: "Give it peace",
            perform_act_anim: false,
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)
                cutscene_func(enc_enemy_add_spare, [slot, 65])
                cutscene_func(function(u) {
                    var o = party_get_inst(u)
                    o.sprite_index = asset_get_index($"spr_b{u}_spell")
                }, [user])
                cutscene_dialogue([
                    "{char(ralsei, 1)}* Whatever you were calling for— it heard you.",
                    "{char(ralsei, 1)}* You can stop now.",
                ])
                cutscene_sleep(25)
                cutscene_func(function(index) {
                    enc_enemy_set_tired(index, true)
                    var __e_obj = o_enc.encounter_data.enemies[index].actor_id
                    instance_create(o_text_hpchange, __e_obj.x, __e_obj.s_get_middle_y(), __e_obj.depth - 100, { draw: "tired" })
                }, [slot])
                cutscene_dialogue(
                    "* The Hollowbell is silent.{br}{resetx}" +
                    "* For the first time in a very long time."
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
                enc_enemy_add_spare(enemy_slot, 20)
                cutscene_dialogue("{char(reggie, 1)}* I heard you. We all did.")
            }
        },
        susie: {
            exec: function(enemy_slot) {
                enc_enemy_add_spare(enemy_slot, 15)
                cutscene_dialogue("{char(susie, 1)}* That is genuinely the loudest thing I've ever encountered.")
            }
        },
    }
    recruit = new enemy_recruit_hollowbell()
    dialogue = function(slot) {
        var me = o_enc.encounter_data.enemies[slot]
        if me.mercy >= 100
            return array_shuffle([
                "* The Hollowbell rings once, very softly.",
                "* It is barely making a sound now.",
                "* HOLLOWBELL: ...",
            ])[0]
        if me.hp < me.max_hp * 0.35
            return array_shuffle([
                "* The Hollowbell's tone is fractured.",
                "* It rings in broken bursts.",
                "* HOLLOWBELL: ...still here.",
            ])[0]
        return array_shuffle([
            "* HOLLOWBELL: DONG.",
            "* The sound fills the room uncomfortably.",
            "* HOLLOWBELL: DONG. DONG.",
            "* The ringing doesn't stop between turns.",
            "* HOLLOWBELL: Can you hear it?",
        ])[0]
    }
}

