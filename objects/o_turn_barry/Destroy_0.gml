event_inherited();

if (instance_exists(wall_inst)) instance_destroy(wall_inst);

with (o_enc_bullet) {
    if (variable_instance_exists(id, "owner_turn") && owner_turn == other.id)
        instance_destroy();
}
