extends Area2D

signal fase_espectral_collected

@export var lifetime: float = 3.0

var _lifetime_timer: float = 0.0

func _ready():
	body_entered.connect(_on_body_entered)
	_lifetime_timer = lifetime

func _physics_process(delta):
	_lifetime_timer -= delta
	if _lifetime_timer <= 0.0:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		fase_espectral_collected.emit()
		queue_free()
