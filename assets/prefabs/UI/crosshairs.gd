extends Sprite2D

signal crosshair_position_response(pos: Vector2)
signal aim_range_response(range: float)

const POWER_WINDUP_STAGE = 1
const ACC_WINDUP_STAGE = 2
const SWEET_SPOT = 2.0 / 3.0	  # for accuracy meter
const SWEET_SPOT_INV = 3.0 / 2.0

@export var variance: float = 100
@export var cursor_speed: float = 5
@export var min_aim_range: float = 15

var pitching_stage = 0
var aim_range = variance # reduces when looking to pitch
var variance_sq = variance * variance  # cached to speed up perf
var target_pos: Vector2
var cos_x_salt = randfn(0, 2.0 * PI)
var sin_x_salt = randfn(0, 2.0 * PI)
var is_crosshair_shaking: bool = true
var astream: AudioStreamPlayer2D
var mouse_cursor_dot = preload("res://assets/art/crosshair_cursor_dot.png")
var mouse_cursor_empty = preload("res://assets/art/crosshair_cursor_empty.png")

func set_variance(v: float) -> void:
	# so that we can draw our variance circle
	variance = v
	variance_sq = v * v

func set_aim_range(r: float) -> void:
	aim_range = max(min_aim_range, r)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	astream = $Audio
	_on_pitcher_reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	
	if !is_crosshair_shaking:
		if astream.volume_db > -10:
			astream.volume_db -= 0.5
		elif astream.playing:
			astream.stop()
		return
	target_pos = get_viewport().get_mouse_position()
	var x = cursor_speed * (Time.get_ticks_msec() / 1000.0)
	target_pos += Vector2(sin(x + sin_x_salt), cos(x + cos_x_salt)).normalized() * variance * sin(x * 2)
	# idea: have humming "wub" sfx play, with its volume gaining the more velocity there is in this frame
	
	var pitch_weight = (target_pos - position).length() / (variance * 2)
	position = (position + target_pos) * .5
	var volume_weight = (position-get_viewport().get_mouse_position()).length() / variance
	astream.volume_db = lerp(5.0, -5.0, volume_weight - (0.5 * pitch_weight)) -1
	astream.pitch_scale = lerp(1.0, 1.2, pitch_weight - volume_weight)

func _on_pitcher_request_crosshair_position() -> void:
	is_crosshair_shaking = false
	crosshair_position_response.emit(position)
	Input.set_custom_mouse_cursor(mouse_cursor_dot)

func _on_pitcher_request_aim_range() -> void:
	aim_range_response.emit(aim_range)

func _on_pitcher_reset() -> void:
	set_variance(variance)  # to setup side-effects
	set_aim_range(variance)
	is_crosshair_shaking = true
	cos_x_salt = randfn(0, 2.0 * PI)
	sin_x_salt = randfn(0, 2.0 * PI)
	Input.set_custom_mouse_cursor(mouse_cursor_empty)
	astream.play()

func _on_pitcher_new_pitching_stage(stage: Variant) -> void:
	pitching_stage = stage
	
func _draw() -> void:
	if pitching_stage <= 3: # Pitching; stop showing post-
		draw_circle(Vector2.ZERO, aim_range, Color(Color.AQUA, 0.25), true, -1, true)

func _on_pitcher_update_pitch_windup(value: Variant) -> void:
	if pitching_stage == 2:  # accuracy windup
		# aliasing
		var b = variance
		var a = min_aim_range
		# We decrease the aim-range until we hit the minimum at the sweetspot
		# Then, we increase back to maximum range (i.e. variance)
		var coeff = 1 if value < SWEET_SPOT else 2
		aim_range = ((b - a) * SWEET_SPOT_INV * coeff * abs(value - SWEET_SPOT)) + a
