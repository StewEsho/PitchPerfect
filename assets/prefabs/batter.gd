extends Node3D

@export_range(1, 9) var jersey_num: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: set jersey texture (polish)
	#$model/Armature/Skeleton3D/player_og.get_active_material(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
