extends Node3D

signal batter_update(num: int)

@export var hitting_odds: Curve

# each batter's sweetspot power % is their number/10
# we are mussing 5 here since we'll manually add them first
var batting_order = [1, 2, 3, 4, 6, 7, 8, 9]
var curr_index: int = 8

func send_out_next_batter() -> void:
	var old_batter: Node3D = get_child(batting_order[curr_index] - 1)
	if !old_batter.is_ready:
		print("batter %d isn't ready to exit yet!" % batting_order[curr_index])
		return
		
	if old_batter.visible:
		old_batter.get_node("Animator").play("exit")
	
	curr_index = (curr_index + 1) % 9
	var batter_num = batting_order[curr_index]
	var batter :Node3D = get_child(batter_num-1)
	batter.get_node("Animator").play("enter")
	batter.update_jersey_tex()
	batter_update.emit(batter_num)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: re-shuffle before 6th innings (after 18 outs)
	batting_order.shuffle()
	batting_order.insert(0, 5)
	print("Batting order: ", batting_order)
	send_out_next_batter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if not event.is_echo() and Input.is_key_pressed(KEY_G):
		send_out_next_batter()
