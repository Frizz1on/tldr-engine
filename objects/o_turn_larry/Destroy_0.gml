event_inherited();

for (var _i = 0; _i < array_length(stake_inst); _i++) {
    if (instance_exists(stake_inst[_i])) instance_destroy(stake_inst[_i]);
}

with (o_enc_bullet) {
    if (variable_instance_exists(id, "owner_turn") && owner_turn == other.id)
        instance_destroy();
}
