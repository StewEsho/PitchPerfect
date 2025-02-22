extends Node3D

@export var hitting_odds: Curve

# each batter's sweetspot power % is their number/10
# we are mussing 5 here since we'll manually add them first
var batting_order = [1, 2, 3, 4, 6, 7, 8, 9]
var curr_index: int = 0

func send_out_batter(num: int) -> void:
	get_child(batting_order[curr_index] - 1).visible = false
	var batter = get_child(num-1)
	batter.visible = true
	batter.update_jersey_tex()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: re-shuffle before 6th innings (after 18 outs)
	batting_order.shuffle()
	batting_order.insert(0, 5)
	print("Batting order: ", batting_order)
	send_out_batter(batting_order[curr_index])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
