extends Control

var main_scene = preload("res://assets/scenes/main.tscn").instantiate()

func _input(event: InputEvent) -> void:
	if not event.is_echo() and event.is_action_pressed("pitch"):
		get_tree().root.add_child(main_scene)
		get_node("/root/TitleScreen").free()
