extends Node3D

@export var pitch_progress_time: float = 1.0 # number of seconds to reach full power

var pitch_power = 0.0

enum PITCH_STAGE {WAIT, WINDUP_1, WINDUP_2, PITCHING, POST_PITCH}
var pitch_stage: PITCH_STAGE = PITCH_STAGE.WAIT

var pitch_progress: float = 0.0

signal update_pitch_windup(stage, value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target_stage := pitch_stage
	match pitch_stage:
		PITCH_STAGE.WAIT:
			if Input.is_action_just_pressed("pitch"):
				print("starting pitching")
				target_stage = PITCH_STAGE.WINDUP_1
		PITCH_STAGE.WINDUP_1:
			var rate := delta / pitch_progress_time
			pitch_progress += rate
			update_pitch_windup.emit(pitch_stage, pitch_progress)
			if (pitch_progress >= 1.0) or Input.is_action_just_pressed("pitch"):
				pitch_power = minf(pitch_progress, 1)
				target_stage = PITCH_STAGE.WINDUP_2
		_:
			print("undefined behavior")
	pitch_stage = target_stage
