extends TextureRect

var timer_started: bool = false
@export var blink_duration: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !timer_started:
		timer_started = true
		await get_tree().create_timer(blink_duration if self.visible else blink_duration * 0.8).timeout
		self.visible = !self.visible
		timer_started = false
