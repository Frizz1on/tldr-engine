function enemy_recruit_sentinel(data = {progress: 0}) : enemy_recruit(data) constructor {
    need    = 2
    level   = 8
    element = "SKY:WATCH"
    like    = "Following Orders"
    sprite  = spr_ex_e_sguy_idle
    bgcolor = c_teal
}
function enemy_recruit_bloomguard(data = {progress: 0}) : enemy_recruit(data) constructor {
    need    = 2
    level   = 9
    element = "SKY:ROOT"
    like    = "Quiet Gardens"
    sprite  = spr_ex_e_sguy_idle
    bgcolor = c_lime
}
function enemy_recruit_cloudpuff(data = {progress: 0}) : enemy_recruit(data) constructor {
    need    = 1
    level   = 6
    element = "SKY:DRIFT"
    like    = "Gentle Breezes"
    sprite  = spr_ex_e_sguy_idle
    bgcolor = c_silver
}
function enemy_recruit_mirrorshade(data = {progress: 0}) : enemy_recruit(data) constructor {
    need    = 2
    level   = 10
    element = "SKY:REFLECT"
    like    = "Being Seen Clearly"
    sprite  = spr_ex_e_sguy_idle
    bgcolor = c_aqua
}
function enemy_recruit_hollowbell(data = {progress: 0}) : enemy_recruit(data) constructor {
    need    = 2
    level   = 11
    element = "ANGEL:CALL"
    like    = "Being Answered"
    sprite  = spr_ex_e_sguy_idle
    bgcolor = c_maroon
}
