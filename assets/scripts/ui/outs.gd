extends CenterContainer

signal s_max_outs

const MAX_OUTS: int = 27
var rects: Array[TextureRect] = []
var num_outs: int = 0

func set_num_outs(num: int) -> void:
	num_outs = min(num, MAX_OUTS)
	for i in range(MAX_OUTS):
		rects[i].visible = (i + 1) <= num
		
	if num_outs >= MAX_OUTS:
		s_max_outs.emit()

func add_out() -> void:
	if num_outs >= MAX_OUTS: 
		return
	rects[num_outs].visible = true
	num_outs += 1
	
	if num_outs >= MAX_OUTS:
		s_max_outs.emit()

func reset() -> void:
	set_num_outs(0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(MAX_OUTS):
		var tex = load("res://assets/art/ui/outs/outs_%d.png" % (i + 1))
		var rect := TextureRect.new()
		rect.texture = tex
		rect.visible = false
		add_child(rect)
		rects.append(rect)

func _input(event: InputEvent) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
