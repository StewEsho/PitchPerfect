extends Control

var crosshairs_variance: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func _on_pitcher_update_pitch_windup(stage: Variant, value: Variant) -> void:
	$PitchingMeter.update_progress(stage, value)

func set_crosshairs_variance(variance: float) -> void:
	crosshairs_variance = variance

func _draw():
	# todo: pass in variance to the crosshairs script
	#  likely need a seperate script to handle all of this,
	#  or, just have a way to send from crosshairs back here
	if $Crosshair.is_crosshair_shaking:
		draw_circle(get_viewport().get_mouse_position(), crosshairs_variance, Color(Color.AQUA, 0.25), true, -1, true)
