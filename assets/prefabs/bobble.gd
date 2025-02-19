extends Node3D

var normalDir: Vector3
var startingY: float

@export var period: float = 20
@export var mag: float = 0.1

var randomOffset: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	normalDir = get_global_transform().basis.z
	startingY = position.y
	randomOffset = randi()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y = startingY + mag * sin(randomOffset + Time.get_ticks_msec() * 2.0 * PI / 1000.0 / period )
