extends Sprite2D

@export var variance: float = 100
var target_pos: Vector2
var cos_x = randfn(0, 2.0 * PI)
var sin_x = randfn(0, 2.0 * PI)

var is_crosshair_shaking: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# so that we can draw our variance circle
	get_parent().set_crosshairs_variance(variance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_crosshair_shaking:
		return
	
	target_pos = get_viewport().get_mouse_position()
	var x = Time.get_ticks_msec() * 2.0 * PI / 5000.0
	target_pos += Vector2(sin(x + sin_x), cos(x + cos_x)).normalized() * variance * sin(x * 2)
	position = (position + target_pos) * .5
