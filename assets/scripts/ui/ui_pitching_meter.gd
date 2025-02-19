extends Container


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PitchingMeterPower.material.set_shader_parameter("goingLeft", false)
	$PitchingMeterAccuracy.material.set_shader_parameter("goingLeft", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_progress(stage: int, amount: float) -> void:
	var meter: Node = null
	if stage <= 1:
		meter = $PitchingMeterPower
	elif stage == 2:
		meter = $PitchingMeterAccuracy
	
	if meter == null:
		print("could not find meter in stage %d" % stage)
	meter.material.set_shader_parameter("progress", amount)	
