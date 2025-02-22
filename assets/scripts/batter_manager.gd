extends Node3D

@export var hitting_odds: Curve

# each batter's sweetspot power % is their number/10
var batting_order = [1, 2, 3, 4, 5, 6, 7, 8, 9]
var curr_index: int = 0

func send_out_batter(num: int) -> void:
	get_child(batting_order[curr_index] - 1).visible = false
	get_child(num - 1).visible = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	batting_order.shuffle()
	print("Batting order: ", batting_order)
	send_out_batter(batting_order[curr_index])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
