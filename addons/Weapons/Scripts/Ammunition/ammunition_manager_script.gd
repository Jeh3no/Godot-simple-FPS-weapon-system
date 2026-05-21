extends Node3D

var ammo_dict : Dictionary[String, int] = { #key = ammo type, value = ammo start number
	"LightAmmo" : 68,
	"MediumAmmo" : 60,
	"HeavyAmmo" : 10,
	"ShellAmmo" : 128,
	"ExplosiveAmmo" : 3,
}

var max_nb_per_ammo_dict : Dictionary[String, int] = { #key = ammo type, value = ammo max number
	"LightAmmo" : 136,
	"MediumAmmo" : 240,
	"HeavyAmmo" : 40,
	"ShellAmmo" : 512,
	"ExplosiveAmmo" : 8,
}
	
