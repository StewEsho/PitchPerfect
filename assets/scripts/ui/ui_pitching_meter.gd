extends Container


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_progress(amount: float) -> void:
	print("update_progress %f" % amount)
	$PitchingMeterFull.material.set_shader_parameter("progress", amount)
