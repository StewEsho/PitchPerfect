extends AspectRatioContainer

@export var percent_text: RichTextLabel
@export var batting_lineup: Node3D

var batter_rects: Array[TextureRect] = []
var is_display_corrupt: bool = false

func load_rect(i: int) -> void:
	var tex = load("res://assets/art/ui/batter/batter_%d.png" % i)
	var rect := TextureRect.new()
	rect.texture = tex
	rect.visible = false
	add_child(rect)
	batter_rects.append(rect)

func toggle_percentage_display(is_on: bool) -> void:
	percent_text.visible = is_on and not is_display_corrupt
	#$percent_sign.visible = is_on and not is_display_corrupt

func switch_batter_ui_elements() -> void:
	var curr_batter: int = batting_lineup.current_batter()
	for i in range(9):
		batter_rects[i].visible = i == curr_batter - 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(9):
		load_rect(i + 1)
	switch_batter_ui_elements()
	toggle_percentage_display(false)
	$Animator.play("Open")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	pass

func _on_batter_lineup_batter_update(num: int) -> void:
	if !$Animator.is_playing():
		$Animator.play("Switch_Batter")
	else:
		switch_batter_ui_elements()
	percent_text.text = str(int(batting_lineup.get_target_power() * 100)) + "%"
