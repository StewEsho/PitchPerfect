extends AspectRatioContainer

signal s_three_strikes()
signal s_walk()

const MAX_STRIKES = 3
const MAX_BALLS = 4

const SCREEN_WIDTH = 720

@export var intro_anim_duration: int = 10  # in frames

var StrikeRects: Array[TextureRect] = []
var BallRects: Array[TextureRect] = []

var num_strikes: int = 0
var num_balls: int = 0
var intro_anim_frame: int = 0

func load_rect(path: String, array: Array) -> void:
	var tex = load(path)
	var rect := TextureRect.new()
	rect.texture = tex
	rect.visible = false
	add_child(rect)
	array.append(rect)

func set_bug(strikes: int, balls: int) -> void:
	set_strikes(strikes)
	set_balls(balls)

func set_strikes(strikes: int) -> void:
	num_strikes = strikes
	for i in range(MAX_STRIKES):
		StrikeRects[i].visible = i + 1 <= num_strikes
	
	if num_strikes >= MAX_STRIKES:
		s_three_strikes.emit()

func set_balls(balls: int) -> void:
	num_balls = balls
	for i in range(MAX_BALLS):
		BallRects[i].visible = i + 1 <= num_balls
	
	if num_balls >= MAX_BALLS:
		s_walk.emit()

func add_strike() -> void:
	set_strikes(num_strikes + 1)

func add_ball() -> void:
	set_balls(num_balls + 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x = SCREEN_WIDTH  # move offscreen
	for i in range(MAX_STRIKES):
		load_rect("res://assets/art/ui/bug/bug_s%d.png" % (i + 1), StrikeRects)
	for i in range(MAX_BALLS):
		load_rect("res://assets/art/ui/bug/bug_b%d.png" % (i + 1), BallRects)

func _input(event: InputEvent) -> void:
	var just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_Q) and just_pressed:
		add_strike()
	if Input.is_key_pressed(KEY_E) and just_pressed:
		add_ball()
	if Input.is_key_pressed(KEY_R) and just_pressed:
		set_bug(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if intro_anim_frame < intro_anim_duration:
		var t = ease(float(intro_anim_frame) / float(intro_anim_duration), 0.3) # ease out
		position.x = lerpf(SCREEN_WIDTH, SCREEN_WIDTH - size.x, t)
		intro_anim_frame += 1
