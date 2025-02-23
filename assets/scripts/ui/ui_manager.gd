extends Control

var ScoreRects: Array[TextureRect] = []

func load_rect(num: int) -> void:
	var tex = load("res://assets/art/ui/score/score_%d.png" % num)
	var rect := TextureRect.new()
	rect.texture = tex
	rect.visible = false
	rect.z_index = 10
	add_child(rect)
	ScoreRects.append(rect)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(9):
		load_rect(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_umpire_game_over(score: int) -> void:
	var screen: ColorRect
	if score < 9:
		screen = $LoseScreen
		ScoreRects[score].visible = true
		$BackgroundMusic.stop()
	else:
		screen = $WinScreen

	$AnimationPlayer.play("hide_hud")
	$BatterUI/Animator.play("Close")
	screen.visible = true
	await get_tree().create_timer(0.75).timeout
	screen.get_node("Audio").play()

func reset() -> void:
	print("PitchingHud::reset()")
	$AnimationPlayer.play("show_hud")
	$BatterUI/Animator.play("Open")
	$BattersBox.visible = true
	$LoseScreen.visible = false
	$WinScreen.visible = false
	$BackgroundMusic.stop()
	for i in range(9):
		ScoreRects[i].visible = false

func _on_umpire_you_win() -> void:
	$AnimationPlayer.play("hide_hud")
	$BatterUI/Animator.play("Close")


func _on_umpire_set_outs_num(num: int) -> void:
	if not $BackgroundMusic.playing and num >= 1:
		$BackgroundMusic.play()
