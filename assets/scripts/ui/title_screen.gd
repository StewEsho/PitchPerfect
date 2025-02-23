extends Control

var game_start: bool = false

func _ready() -> void:
	$Game/background.visible = false
	$Game/PitchingHud.visible = false
	$Game.process_mode = Node.PROCESS_MODE_DISABLED

func _input(event: InputEvent) -> void:
	if !game_start and !event.is_echo() and event.is_action_pressed("pitch"):
		game_start = true
		$TitleScreenBg.visible = false
		$TitleScreenRender.visible = false
		$TitleScreenContinue.visible = false
		$Game.process_mode = Node.PROCESS_MODE_INHERIT
		$Game/PitchingHud.visible = true
		$Game/background.visible = true
		
