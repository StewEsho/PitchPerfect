extends Sprite2D

signal crosshair_position_response(pos: Vector2)

@export var variance: float = 100
@export var cursor_speed: float = 5
var variance_sq = variance * variance  # cached to speed up perf
var target_pos: Vector2
var cos_x_salt = randfn(0, 2.0 * PI)
var sin_x_salt = randfn(0, 2.0 * PI)

var is_crosshair_shaking: bool = true
	
var astream: AudioStreamPlayer2D

func set_variance(v: float) -> void:
	# so that we can draw our variance circle
	variance = v
	get_parent().set_crosshairs_variance(v)
	variance_sq = v * v

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_variance(variance)  # to setup side-effects
	astream = $Audio

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_crosshair_shaking:
		if astream.volume_db > -10:
			astream.volume_db -= 0.5
		elif astream.playing:
			astream.stop()
		return
	elif !astream.playing:
		astream.play()
	
	target_pos = get_viewport().get_mouse_position()
	var x = cursor_speed * (Time.get_ticks_msec() / 1000.0)
	target_pos += Vector2(sin(x + sin_x_salt), cos(x + cos_x_salt)).normalized() * variance * sin(x * 2)
	# idea: have humming "wub" sfx play, with its volume gaining the more velocity there is in this frame
	
	var pitch_weight = (target_pos - position).length() / (variance * 2)
	
	position = (position + target_pos) * .5
	
	var volume_weight = (position-get_viewport().get_mouse_position()).length() / variance
	astream.volume_db = lerp(5.0, -5.0, volume_weight - (0.5 * pitch_weight)) + 2
	astream.pitch_scale = lerp(1.0, 1.2, pitch_weight - volume_weight)

func _on_pitcher_request_crosshair_position() -> void:
	is_crosshair_shaking = false
	crosshair_position_response.emit(position)

func _on_pitcher_reset() -> void:
	is_crosshair_shaking = true
	cos_x_salt = randfn(0, 2.0 * PI)
	sin_x_salt = randfn(0, 2.0 * PI)
