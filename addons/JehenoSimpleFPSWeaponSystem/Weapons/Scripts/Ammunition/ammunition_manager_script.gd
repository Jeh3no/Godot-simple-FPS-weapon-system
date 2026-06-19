extends Node3D

enum AMMO_TYPES
{
	LIGHTAMMO, MEDIUMAMMO, HEAVYAMMO, SHELLAMMO, EXPLOSIVEAMMO
}

var ammo_dict : Dictionary[AMMO_TYPES, int] = { #key = ammo type, value = ammo start number
	AMMO_TYPES.LIGHTAMMO : 68,
	AMMO_TYPES.MEDIUMAMMO : 60,
	AMMO_TYPES.HEAVYAMMO : 10,
	AMMO_TYPES.SHELLAMMO : 128,
	AMMO_TYPES.EXPLOSIVEAMMO : 3,
}

var max_nb_per_ammo_dict : Dictionary[AMMO_TYPES, int] = { #key = ammo type, value = ammo max number
	AMMO_TYPES.LIGHTAMMO : 136,
	AMMO_TYPES.MEDIUMAMMO : 240,
	AMMO_TYPES.HEAVYAMMO : 40,
	AMMO_TYPES.SHELLAMMO  : 512,
	AMMO_TYPES.EXPLOSIVEAMMO : 8,
}
	
