extends Area2D

signal caught(points: int)

@export var fall_speed: float = 250.0
@export var point_value: int = 10

func _ready():
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	position.y += fall_speed * delta
	if position.y > 1100.0:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		caught.emit(point_value)
	queue_free()
