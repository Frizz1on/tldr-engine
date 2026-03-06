/// @description turn ends
instance_destroy(_ex_bullet)

for (var i = 0; i < array_length(global.party_names); ++i) {
    var n = global.party_names[i];

    var hg = party_getdata(n, "highguard_turns");
    if (hg > 0) {
        party_setdata(n, "highguard_turns", hg - 1);
    }
}