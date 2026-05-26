extends StaticBody3D

@export var ammo_to_refill : Dictionary[String, int] = {}

@onready var detect_area: Area3D = %DetectArea

func _ready() -> void:
	detect_area.body_entered.connect(Callable(self, "_on_detect_area_body_entered"))
	
func _on_detect_area_body_entered(body : Node3D) -> void:
	if body is PlayerCharacter:
		var play_char = body
		var link_to_ammo_refill : LinkComponent = play_char.get_node("LinkComponent")
		
		if link_to_ammo_refill != null:
			link_to_ammo_refill.ammo_refill_link(ammo_to_refill)
		else:
			push_error("Player character can't refill ammunition, link component node is missing")
			
		queue_free()
