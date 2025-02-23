extends Node3D

signal batter_hits_ball()

@export_range(1, 9) var jersey_num: int = 2
var is_ready: bool = true

func update_jersey_tex() -> void:
	# we change it on the fly . . .
	var jersey_tex := load("res://assets/textures/batter_%d_tex.png" % jersey_num)
	$model/Armature/Skeleton3D/player_og.get_active_material(0).albedo_texture = jersey_tex

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	is_ready = !$Animator.is_playing()

func swing() -> void:
	$model/AnimationPlayer.stop()
	$model/AnimationPlayer.play("Swing")
	$model/AnimationPlayer.queue("Idle")

func hit_ball() -> void:
	$bat_hit_sfx.play()
	batter_hits_ball.emit()

func _on_batter_lineup_parent_ready() -> void:
	batter_hits_ball.connect(get_parent_node_3d()._on_batter_hits_ball)
