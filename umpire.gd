extends Node3D

signal game_over(score: int)
signal you_win()
signal set_ball_num(num: int)
signal set_strike_num(num: int)
signal set_outs_num(num: int)
signal batter_hit(y_relative: float)

@export var pitcher: Node3D
@export var batter_lineup: Node3D
@export var hitting_odds: Curve
@export var batting_box: TextureRect

const max_strikes = 3
const max_balls = 4
const max_outs = 27

var batting_box_bounds: Rect2
var num_strikes := 0
var num_balls := 0
var num_outs := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	batting_box_bounds = Rect2(batting_box.position, batting_box.size)
	
func reset() -> void:
	num_strikes = 0
	num_balls = 0
	num_outs = 0
	set_strike_num.emit(num_strikes)
	set_ball_num.emit(num_balls)
	set_outs_num.emit(num_outs)
	batting_box.visible = true

func print_stats() -> void:
	print("Batter #%d -- S=%d B=%d" % [num_outs + 1, num_strikes, num_balls])

func process_ball() -> void:
	print("Umpire: Ball")
	num_balls += 1
	set_ball_num.emit(num_balls)
	$Sounds/DangIt.play()
	if num_balls == max_balls:
		batting_box.visible = false
		game_over.emit(num_outs)

func process_strike(is_perfect: bool) -> void:
	print("Umpire: Strike!")
	$Sounds/Alright.play()
	if is_perfect:
		print("Umpire: Perfect power!")
		$Sounds/Perfect.play()
	
	num_strikes += 1
	set_strike_num.emit(num_strikes)
	if num_strikes == max_strikes:
		num_strikes = 0
		set_strike_num.emit(0)
		num_balls = 0
		set_ball_num.emit(0)
		print("Umpire: batter %d is out!" % batter_lineup.current_batter())
		num_outs += 1
		$Sounds/Out.play()
		set_outs_num.emit(num_outs)
		if num_outs == max_outs:
			you_win.emit()
		
func process_hit(pos: Vector2) -> void:
	print("Umpire: The batter hits!")
	# we send a relative value of the bounding box,
	# 1 if its at the top, -1 if its at the bottom
	# this is used to animate the y-pos of the batter
	var y_relative: float = (pos.y - batting_box_bounds.position.y) / batting_box_bounds.size.y
	y_relative -= 0.5
	y_relative *= -2
	print(y_relative)
	batter_hit.emit(y_relative)
	batting_box.visible = false

func process_pitch(pos: Vector2, power: float, _null) -> void:
	print("Umpire: processing pitch with power %f at position (%f, %f)" % [power, pos.x, pos.y])
	var target_power = batter_lineup.get_target_power()
	var is_in_bounds: bool = batting_box_bounds.has_point(pos)
	if not is_in_bounds:
		process_ball()
		print_stats()
		return
	# add 0.5 since that is where odds are centered
	var power_odds: float = hitting_odds.sample(power - target_power + 0.5)
	print("Umpire: power_odds: %f" % power_odds)
	var random_num = randf()
	if random_num <= power_odds:
		process_strike(abs(power_odds - 1.0) < 0.0001)
	else:
		process_hit(pos)
	print_stats()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_batter_lineup_baseball_hit() -> void:
	batting_box.visible = false
	game_over.emit(num_outs)

func _input(event: InputEvent) -> void:
	if OS.is_debug_build() and not event.is_echo():
		if Input.is_key_pressed(KEY_L):
			process_strike(false)
