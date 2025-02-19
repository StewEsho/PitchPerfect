extends Node3D

var normalDir: Vector3
var startingY: float

@export var period: float = 20
@export var mag: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	normalDir = get_global_transform().basis.z
	startingY = position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y = startingY + mag * sin(Time.get_ticks_msec() * 2 * PI / 1000 / period )
