extends AspectRatioContainer

@export var percent_text: RichTextLabel

var batter_rects: Array[TextureRect] = []
var current_batter: int = 1
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
	$percent_sign.visible = is_on and not is_display_corrupt

func switch_batter_ui_elements() -> void:
	for i in range(9):
		batter_rects[i].visible = i == current_batter - 1

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
	current_batter = num
	$Animator.play("Switch_Batter")
	percent_text.text = str(num * 10)
