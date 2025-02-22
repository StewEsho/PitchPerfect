extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var t = sin(Time.get_ticks_msec() * 2 * PI / 1000 / 16)
	scale = Vector2.ONE * ((t * t * 0.05) + 1);
