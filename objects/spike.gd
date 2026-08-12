extends Area2D

func _ready():
	# normalmente los resultados de las conexiones "estáticas" se ignoran
	body_entered.connect(_on_spike_body_entered)

func _on_spike_body_entered(body):
	if body.is_in_group("player"):
		body.explode()

