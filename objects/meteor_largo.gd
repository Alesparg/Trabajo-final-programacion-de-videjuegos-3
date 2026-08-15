extends Area2D

@export var fall_speed: float = 350.0
@export var damage: int = 2

func _ready():
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	position.y += fall_speed * delta
	if position.y > 1100.0:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		if not body.is_invulnerable():
			body.take_damage(damage)
	queue_free()
