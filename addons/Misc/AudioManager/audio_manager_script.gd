extends AudioStreamPlayer3D

func _on_finished() -> void:
	queue_free()
