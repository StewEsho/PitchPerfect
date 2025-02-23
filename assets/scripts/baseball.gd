extends RigidBody3D

@export var min_speed = 2.0
@export var max_speed = 10.0

var is_pitched: bool = false
var initial_parent: Node3D
var initial_position: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_parent = get_parent()
	initial_position = position
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_pitched:
		$model.rotate(
			Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized(), 
			deg_to_rad(randf_range(-25, 25)))

func reset() -> void:
	is_pitched = false
	linear_velocity = Vector3.ZERO
	if initial_parent != get_parent():
		get_parent().remove_child.call_deferred(self)
		initial_parent.add_child.call_deferred(self)
	position = initial_position

func _on_pitcher_throw_pitch(target: Vector2, power: float, new_parent: Node3D) -> void:
	is_pitched = true
	var curr_pos = global_position
	get_parent().remove_child(self)
	new_parent.add_child(self)
	global_position = curr_pos
	
	var cam: Camera3D = get_viewport().get_camera_3d()
	var camera_origin = cam.project_ray_origin(Vector2.ZERO)
	var target_pos: Vector3 = camera_origin + cam.project_ray_normal(target) * 1000
	linear_velocity = (target_pos - global_position).normalized() * lerp(min_speed, max_speed, power)


func _on_pitcher_reset() -> void:
	reset()
