function enc_set_larry_berry() : enc_set() constructor {
    debug_name = "larry_berry"
    enemies = [
        new enemy_berry(),
		new enemy_larry(),
    ]
    enemies_pos = [
        [-22, -6, true],
        [ 18,  4, true],
    ]
    bgm = mus_battle
    flavor = function() {
        if o_enc.turn_count == 0
            return "* Larry and Berry barred the way!!"
        var larry_tired = false
        var berry_tired = false
        var larry_low   = false
        var berry_low   = false
        for (var i = 0; i < array_length(o_enc.encounter_data.enemies); i++) {
            var e = o_enc.encounter_data.enemies[i]
            if is_instanceof(e, enemy_larry) && enc_enemy_isfighting(i) {
                larry_tired = e.tired
                larry_low   = (e.hp < e.max_hp * 0.35)
            }
            if is_instanceof(e, enemy_berry) && enc_enemy_isfighting(i) {
                berry_tired = e.tired
                berry_low   = (e.hp < e.max_hp * 0.35)
            }
        }
        if larry_tired && berry_tired
            return choose(
                "* Both knights seem to be reconsidering things.",
                "* The alarm on Larry's helm sputters once, then stops.",
                "* Berry shifts her second shield. It's heavy."
            )
        // FIX: removed embedded literal newline — was: "* LARRY: Don't \n don't stop, Berry."
        if larry_low && berry_low
            return choose(
                "* Larry grips his sword with both hands.",
                "* The ground shakes slightly with every breath Larry takes.",
                "* Berry has not moved an inch."
            )
        if larry_tired
            return choose(
                "* Larry is staring at the ceiling.",
                "* Larry's grip on his sword loosens.",
                "* Larry looks toward Berry for reassurance."
            )
        if berry_tired
            return choose(
                "* Berry lowers her second shield slightly.",
                "* Berry has stopped watching you. She's watching the wall.",
                "* Berry stays silent."
            )
        return choose(
            "* Larry signals Berry to brace.",
            "* Berry raises both shields.",
            "* Larry squares up in front of the team.",
            "* Berry stays silent.",
            "* The buzzer on Larry's helm screams.",
            "* Larry raises his sword to shoulder height.",
            "* Berry steps forward one inch. That's a threat.",
            "* Berry does not react to Larry's gestures."
        )
    }
    // FIX: was _target_calculation — engine reads encounter.target_calculation, underscore version was silently ignored
    target_calculation = function() {
        var __alive = []
        for (var i = 0; i < array_length(global.party_names); i++) {
            if party_getdata(global.party_names[i], "hp") > 0
                array_push(__alive, global.party_names[i])
        }
        if array_length(__alive) == 0 return -1
        return [array_shuffle(__alive)[0]]
    }
    // FIX: was _target_recalculate_condition — same issue, engine ignores underscore-prefixed version
    target_recalculate_condition = function(__current_targets) {
        return !party_isup(__current_targets[0])
    }
}

function enc_set_sentinel() : enc_set() constructor {
    debug_name = "sentinel"
    enemies    = [ new enemy_sentinel() ]
    enemies_pos = [ [0, 0, true] ]
    bgm        = mus_battle
    flavor     = function() {
        if o_enc.turn_count == 0 return "* A Sentinel locked on!"
        return choose(
            "* The Sentinel issues a final warning tone.",
            "* Its scan light tracks your every move.",
            "* The Sentinel flags your group as unauthorised.",
            "* The Sentinel's scan light sweeps across the room.",
        )
    }
    target_calculation = ENC_TARGET.RANDOM
}

function enc_set_bloomguard() : enc_set() constructor {
    debug_name = "bloomguard"
    enemies    = [ new enemy_bloomguard() ]
    enemies_pos = [ [0, 0, true] ]
    bgm        = mus_battle
    flavor     = function() {
        if o_enc.turn_count == 0 return "* The Bloomguard bristled!"
        return choose(
            "* BLOOMGUARD: Don't touch anything.",
            "* Its thorns are fully extended.",
            "* BLOOMGUARD: This is your last warning.",
            "* The Bloomguard's flowers are completely closed.",
        )
    }
    target_calculation = ENC_TARGET.RANDOM
}

function enc_set_cloudpuff() : enc_set() constructor {
    debug_name = "cloudpuff"
    enemies    = [ new enemy_cloudpuff() ]
    enemies_pos = [ [0, 0, true] ]
    bgm        = mus_battle
    flavor     = function() {
        if o_enc.turn_count == 0 return "* A startled Cloudpuff appeared!"
        return choose(
            "* CLOUDPUFF: Fwff!",
            "* It puffs up defensively.",
            "* The Cloudpuff bobs with agitation.",
            "* CLOUDPUFF: ...",
        )
    }
    target_calculation = ENC_TARGET.RANDOM
}
function enc_set_sentinel_cloudpuff() : enc_set() constructor {
    debug_name = "sentinel_cloudpuff"
    enemies    = [ new enemy_sentinel(), new enemy_cloudpuff() ]
    enemies_pos = [ [-18, -4, true], [16, 4, true] ]
    bgm        = mus_battle
    flavor     = function() {
        if o_enc.turn_count == 0 return "* A Sentinel and a Cloudpuff were patrolling together!"
        return choose(
            "* The Sentinel broadcasts a hold-position command.",
            "* The Cloudpuff has retreated behind the Sentinel.",
            "* The Sentinel reports the area as secure.",
            "* CLOUDPUFF: Fwff.",
        )
    }
    target_calculation = ENC_TARGET.RANDOM
}

function enc_set_bloomguard_cloudpuff() : enc_set() constructor {
    debug_name = "bloomguard_cloudpuff"
    enemies    = [ new enemy_bloomguard(), new enemy_cloudpuff() ]
    enemies_pos = [ [-18, 0, true], [16, 0, true] ]
    bgm        = mus_battle
    flavor     = function() {
        if o_enc.turn_count == 0 return "* The Bloomguard and a Cloudpuff blocked the path!"
        return choose(
            "* The Cloudpuff hides in the Bloomguard's leaves.",
            "* BLOOMGUARD: Back away from the garden.",
            "* They seem to know each other.",
            "* CLOUDPUFF: ...",
        )
    }
    target_calculation = ENC_TARGET.RANDOM
}
