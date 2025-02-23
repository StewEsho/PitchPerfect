extends Node3D

signal batter_update(num: int)
signal baseball_hit()
signal parent_ready()

# each batter's sweetspot power % is their number/10
# we are mussing 5 here since we'll manually add them first
var batting_order = [1, 2, 3, 4, 6, 7, 8, 9]
var curr_index: int = 7
var default_y_pos: float
const y_pos_range: float = 0.65
var target_y_pos: float

@export var baseball_node: Node3D

func get_target_power() -> float:
	return float(batting_order[curr_index]) / 10.0

func current_batter() -> int:
	return batting_order[curr_index]

func current_batter_node() -> Node3D:
	return get_child(batting_order[curr_index] - 1)

func send_out_next_batter(index: int = -1) -> void:
	if index >= 0:
		var old_batter: Node3D = get_child(batting_order[curr_index] - 1)
		if !old_batter.is_ready:
			print("batter %d isn't ready to exit yet!" % batting_order[curr_index])
			return
			
		if old_batter.visible:
			old_batter.get_node("Animator").play("exit")
	
	print("BatterManager: send_out_next_batter")
	target_y_pos = default_y_pos
	curr_index = index if index >= 0 else (curr_index + 1) % 9
	print(curr_index)
	var batter :Node3D = current_batter_node()
	batter.get_node("Animator").play("enter")
	batter.update_jersey_tex()
	batter_update.emit(current_batter())

func reset() -> void:
	print("BatterManager: reset()")
	for i in range(9):
		get_child(i).get_node("Animator").play("exit")
	batting_order.shuffle() # we don't care about 5 being first after a reset
	print(batting_order)
	curr_index = -1
	default_y_pos = position.y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: re-shuffle before 6th innings (after 18 outs)
	batting_order.shuffle()
	batting_order.insert(0, 5)
	print(batting_order)
	send_out_next_batter(0)
	default_y_pos = position.y
	parent_ready.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += (target_y_pos - position.y) * 0.4

func _input(event: InputEvent) -> void:
	if OS.is_debug_build() and not event.is_echo():
		if Input.is_key_pressed(KEY_G):
			send_out_next_batter()
		if Input.is_key_pressed(KEY_U):
			_on_umpire_batter_hit(-1)
		if Input.is_key_pressed(KEY_I):
			_on_umpire_batter_hit(0)
		if Input.is_key_pressed(KEY_O):
			_on_umpire_batter_hit(1)

func _on_umpire_batter_hit(y_relative: float) -> void:
	target_y_pos = default_y_pos + (y_relative * y_pos_range)
	print("new_target_y_pos: %f" % target_y_pos)
	current_batter_node().swing()

func _on_batter_hits_ball() -> void:
	baseball_node.hit()
