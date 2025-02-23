extends Container

var stage = 0
var meter: Node2D = null

const POWER_WINDUP_STAGE = 1
const ACC_WINDUP_STAGE = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PitchingMeterPower.material.set_shader_parameter("goingLeft", false)
	$PitchingMeterAccuracy.material.set_shader_parameter("goingLeft", true)
	meter = $PitchingMeterPower

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_progress(amount: float) -> void:
	if meter == null:
		print("could not find meter in stage %d" % stage)
		return
	meter.material.set_shader_parameter("progress", amount)	

func _on_pitcher_new_pitching_stage(stage: Variant) -> void:
	self.stage = stage
	if stage == Pitcher.PitchStage.WAIT:
		_on_pitcher_reset()
		return
	
	if meter and meter.has_node("Audio"):
		meter.get_node("Audio").stop()
	
	if stage == Pitcher.PitchStage.WINDUP_1:
		meter = $PitchingMeterPower
		meter.get_node("Audio").play()
	elif stage == Pitcher.PitchStage.WINDUP_2:
		meter = $PitchingMeterAccuracy
		meter.get_node("Audio").play()
		$ConfirmAudio.play()
	elif stage == Pitcher.PitchStage.PITCHING:
		$ConfirmAudio.play()
	else:	
		meter = null

func _on_pitcher_reset() -> void:
	$PitchingMeterPower.material.set_shader_parameter("progress", 0)
	$PitchingMeterAccuracy.material.set_shader_parameter("progress", 0)
	meter = $PitchingMeterPower
