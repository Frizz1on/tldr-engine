function enc_set_larry_berry() : enc_set() constructor {
    debug_name = "larry_berry"

    enemies = [
        new enemy_larry(),
        new enemy_berry(),
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
        if larry_low && berry_low
            return choose(
                "* LARRY: Don't — don't stop, Berry.",
                "* The ground shakes slightly with every breath Larry takes.",
                "* Berry has not moved an inch."
            )
        if larry_tired
            return choose(
                "* Larry is staring at the ceiling.",
                "* Larry's grip on his sword loosens.",
                "* LARRY (quietly): Berry, did I used to like this job?"
            )
        if berry_tired
            return choose(
                "* Berry lowers her second shield slightly.",
                "* Berry has stopped watching you. She's watching the wall.",
                "* Berry: ..."
            )
        return choose(
            "* LARRY: HOLD THE LINE BERRY.",
            "* Berry raises both shields.",
            "* LARRY: DON'T LET THEM THROUGH.",
            "* Berry: ...",
            "* The buzzer on Larry's helm screams.",
            "* LARRY: I WILL USE THIS SWORD.",
            "* Berry steps forward one inch. That's a threat.",
            "* LARRY: BERRY ARE YOU EVEN LISTENING."
        )
    }


    _target_calculation = function() {
        var __alive = []
        for (var i = 0; i < array_length(global.party_names); i++) {
            if party_getdata(global.party_names[i], "hp") > 0
                array_push(__alive, global.party_names[i])
        }
        if array_length(__alive) == 0 return -1
        return [array_shuffle(__alive)[0]]
    }
    _target_recalculate_condition = function(__current_targets) {
        return !party_isup(__current_targets[0])
    }
}