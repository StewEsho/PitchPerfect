extends Node3D

class_name Pitcher

signal new_pitching_stage(stage)
signal update_pitch_windup(value)
signal throw_pitch(target: Vector2, power: float, parent: Node3D)
signal reset()
signal request_crosshair_position()
signal request_aim_range()

@export var power_duration: float = 1.5 # number of seconds to reach full power
@export var accuracy_duration: float = 1.0
@export var baseball_asset: PackedScene

enum PitchStage {WAIT, WINDUP_1, WINDUP_2, PITCHING, POST_PITCH, GAME_OVER}
var pitch_stage: PitchStage = PitchStage.WAIT
var target_stage = pitch_stage

var target_pitch_pos: Vector2 = Vector2.ZERO
var target_aim_range: float = 0

var has_pressed_pitch_yet: bool = false # to "eat" the input from the title screen
var is_waiting_for_post_pitch: bool = false  # to set timer to wait before continue

class PitchData:
	var stage: PitchStage
	var progress: float
	var time_to_swing: float

# todo: consider movign into array
# then we can keep adding pitches
# idea: many pitches that we can whittle down
var power_pitch := PitchData.new()
var accuracy_pitch := PitchData.new()
var animplayer: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	power_pitch.time_to_swing = power_duration
	accuracy_pitch.time_to_swing = accuracy_duration
	accuracy_pitch.progress = 0.05  # start with a little bit in the tank
	if $CharacterBody3D/Bobble/pitcher_model.has_node("AnimationPlayer"):
		animplayer = $CharacterBody3D/Bobble/pitcher_model/AnimationPlayer;
		animplayer.queue("Idle")		

func windup(delta: float, data) -> bool:
	data.progress += minf(delta / data.time_to_swing, 1.0)
	update_pitch_windup.emit(data.progress)
	# return true to stop progress
	return (data.progress >= 1.0) or Input.is_action_just_pressed("pitch")

func throw_pitch_callback() -> void:
	$Audio.play()
	# throw to a random point within range of the crosshair
	var r_angle: float = randf_range(0, 2 * PI)
	var r_radius: float = randf_range(0, target_aim_range)
	var rx: float = cos(r_angle) * r_radius
	var ry: float = sin(r_angle) * r_radius
	var actual_target_pos: Vector2 = target_pitch_pos + Vector2(rx, ry)
	throw_pitch.emit(actual_target_pos, clamp(power_pitch.progress, 0.0, 1.0), get_parent())

func update_stage(target_stage):
	if pitch_stage == target_stage:
		return
	pitch_stage = target_stage
	new_pitching_stage.emit(pitch_stage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !has_pressed_pitch_yet and Input.is_action_just_pressed("pitch"):
		has_pressed_pitch_yet = true
		return
	
	if is_waiting_for_post_pitch:
		return
		
	match pitch_stage:
		PitchStage.WAIT:
			if Input.is_action_just_pressed("pitch"):
				print("starting pitching")
				target_stage = PitchStage.WINDUP_1
		PitchStage.WINDUP_1:
			if (windup(delta, power_pitch)):
				print("Power: [%f]" % power_pitch.progress)
				target_stage = PitchStage.WINDUP_2
				request_crosshair_position.emit()
		PitchStage.WINDUP_2:
			if (windup(delta, accuracy_pitch)):
				print("Acc: [%f]" % accuracy_pitch.progress)
				target_stage = PitchStage.PITCHING
				request_aim_range.emit()
				# we then listen for `crosshair_position_response` signal
				if animplayer:
					animplayer.stop()
					animplayer.play("Underhand" if power_pitch.progress < 0.5 else "Pitch");
		PitchStage.PITCHING:
			if not is_waiting_for_post_pitch:
				is_waiting_for_post_pitch = true
				target_stage = PitchStage.POST_PITCH
				await get_tree().create_timer(1.0).timeout
				is_waiting_for_post_pitch = false
		PitchStage.POST_PITCH:
			if Input.is_action_just_pressed("pitch"):
				_on_reset()
		PitchStage.GAME_OVER:
			if Input.is_action_just_pressed("pitch"):
				reset.emit()
		_:
			print("undefined behavior")
		
	update_stage(target_stage)

func _on_reset() -> void:
	power_pitch.progress = 0
	accuracy_pitch.progress = 0
	target_stage = PitchStage.WAIT

func _on_crosshair_crosshair_position_response(pos: Vector2) -> void:
	target_pitch_pos = pos

func _on_crosshair_aim_range_response(range: float) -> void:
	target_aim_range = range

func _on_umpire_game_over(score: int) -> void:
	target_stage = PitchStage.GAME_OVER
	has_pressed_pitch_yet = false
