extends Container

var stage = 0
var meter: Node2D = null

const POWER_WINDUP_STAGE = 1
const ACC_WINDUP_STAGE = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PitchingMeterPower.material.set_shader_parameter("goingLeft", false)
	$PitchingMeterAccuracy.material.set_shader_parameter("goingLeft", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_progress(amount: float) -> void:
	if meter == null:
		print("could not find meter in stage %d" % stage)
		return
	meter.material.set_shader_parameter("progress", amount)	

func _on_pitcher_new_pitching_stage(stage: Variant) -> void:
	if meter:
		if meter.has_node("Audio"):
			meter.get_node("Audio").stop()
		$ConfirmAudio.play()
		if randf() < 0.5:
			$AudioPerfect.play() # TODO: only if we hit Sweetspot (within 0.05)
	
	self.stage = stage
	if stage == POWER_WINDUP_STAGE:
		meter = $PitchingMeterPower
	elif stage == ACC_WINDUP_STAGE:
		meter = $PitchingMeterAccuracy
	else:	
		meter = null
	
	if meter:
		if meter.has_node("Audio"):
			meter.get_node("Audio").play()


func _on_pitcher_reset() -> void:
	$PitchingMeterPower.material.set_shader_parameter("progress", 0)
	$PitchingMeterAccuracy.material.set_shader_parameter("progress", 0)
