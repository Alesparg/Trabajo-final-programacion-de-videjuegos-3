extends Area2D

@export var fall_speed: float = 400.0
@export var change_interval: float = 0.5
@export var horizontal_speed: float = 150.0

var time_since_change: float = 0.0
var current_direction: int = 1  # 1 = derecha, -1 = izquierda

func _ready():
	body_entered.connect(_on_body_entered)
	# Elegir dirección inicial aleatoria
	current_direction = randi() % 2
	if current_direction == 0:
		current_direction = -1

func _physics_process(delta):
	time_since_change += delta
	
	# Cambiar dirección horizontal periódicamente
	if time_since_change >= change_interval:
		time_since_change = 0.0
		current_direction *= -1  # Invertir dirección
	
	# Mover hacia abajo
	position.y += fall_speed * delta
	
	# Mover horizontalmente
	position.x += horizontal_speed * current_direction * delta
	
	# Eliminar si sale de la pantalla
	if position.y > 1100.0:
		queue_free()
	
	# Eliminar si sale por los lados
	if position.x < -100 or position.x > 1200:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		if not body.is_invulnerable():
			body.take_damage()
	queue_free()
