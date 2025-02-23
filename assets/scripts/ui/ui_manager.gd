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
	$AnimationPlayer.play("hide_hud")
	$BatterUI/Animator.play("Close")
	$LoseScreen.visible = true
	$LoseScreen/Audio.play()
	ScoreRects[score].visible = true

func reset() -> void:
	print("PitchingHud::reset()")
	$AnimationPlayer.play("show_hud")
	$BatterUI/Animator.play("Open")
	$BattersBox.visible = true
	$LoseScreen.visible = false
	$WinScreen.visible = false
	for i in range(9):
		ScoreRects[i].visible = false

func _on_umpire_you_win() -> void:
	$AnimationPlayer.play("hide_hud")
	$BatterUI/Animator.play("Close")
	$WinScreen.visible = true
	$WinScreen/Audio.play()
