extends Node3D

signal update_pitch_windup(stage, value)

@export var pitch_progress_time: float = 1.0 # number of seconds to reach full power

enum PitchStage {WAIT, WINDUP_1, WINDUP_2, PITCHING, POST_PITCH}
var pitch_stage: PitchStage = PitchStage.WAIT

class PitchData:
	var stage: PitchStage
	var progress: float
	var time_to_swing: float

# todo: consider movign into array
# then we can keep adding pitches
# idea: many pitches that we can whittle down
var power_pitch := PitchData.new()
var accuracy_pitch := PitchData.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	power_pitch.time_to_swing = pitch_progress_time
	accuracy_pitch.time_to_swing = pitch_progress_time
	accuracy_pitch.progress = 0.05  # start with a little bit in the tank

func windup(delta: float, data) -> bool:
	data.progress += minf(delta / data.time_to_swing, 1.0)
	update_pitch_windup.emit(pitch_stage, data.progress)
	# return true to stop progress
	return (data.progress >= 1.0) or Input.is_action_just_pressed("pitch")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target_stage := pitch_stage
	match pitch_stage:
		PitchStage.WAIT:
			if Input.is_action_just_pressed("pitch"):
				print("starting pitching")
				target_stage = PitchStage.WINDUP_1
		PitchStage.WINDUP_1:
			if (windup(delta, power_pitch)):
				print("Power: [%f]" % power_pitch.progress)
				target_stage = PitchStage.WINDUP_2
		PitchStage.WINDUP_2:
			if (windup(delta, accuracy_pitch)):
				print("Acc: [%f]" % accuracy_pitch.progress)
				target_stage = PitchStage.PITCHING
		PitchStage.PITCHING:
			if Input.is_action_just_pressed("pitch"):
				power_pitch.progress = 0
				accuracy_pitch.progress = 0
				update_pitch_windup.emit(1, power_pitch.progress)
				update_pitch_windup.emit(2, accuracy_pitch.progress)
				target_stage = PitchStage.WAIT
		_:
			print("undefined behavior")
	pitch_stage = target_stage
