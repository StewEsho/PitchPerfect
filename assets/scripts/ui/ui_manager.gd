extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_umpire_game_over(score: int) -> void:
	$AnimationPlayer.play("hide_hud")
	$BatterUI/Animator.play("Close")
	$LoseScreen.visible = true
	$LoseScreen/Audio.play()

func reset() -> void:
	$AnimationPlayer.play("show_hud")
	$BatterUI/Animator.play("Open")
	$BattersBox.visible = true
	$LoseScreen.visible = false
	$WinScreen.visible = false

func _on_umpire_you_win() -> void:
	$AnimationPlayer.play("hide_hud")
	$BatterUI/Animator.play("Close")
	$WinScreen.visible = true
	$WinScreen/Audio.play()
