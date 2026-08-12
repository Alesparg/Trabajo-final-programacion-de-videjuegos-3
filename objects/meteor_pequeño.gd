extends Area2D

@export var fall_speed: float = 350.0
@export var horizontal_velocity: float = 0.0

func _ready():
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	position.y += fall_speed * delta
	position.x += horizontal_velocity * delta
	if position.y > 1100.0:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage()
	queue_free()
