extends Node2D

signal power_up_doble_collected

@export var power_up_doble_scene: PackedScene
@export var spawn_interval: float = 20.0
@export var max_spawns: int = 1

var _timer: float = 0.0
var _spawns_remaining: int = 1

func _ready():
	_reset_timer()
	_spawns_remaining = max_spawns

func _process(delta):
	if _spawns_remaining <= 0:
		return
	
	_timer -= delta
	if _timer <= 0.0:
		_spawn_power_up_doble()
		_reset_timer()

func _reset_timer():
	_timer = spawn_interval

func _spawn_power_up_doble():
	if _spawns_remaining <= 0:
		return
	
	var player_group = get_tree().get_nodes_in_group("player")
	if player_group.size() == 0:
		return
	
	var player = player_group[0]
	var player_x = player.global_position.x
	
	# Posición aleatoria en el suelo, cerca del jugador
	var offset = randf_range(-200.0, 200.0)
	var spawn_x = clamp(player_x + offset, 64.0, 960.0)
	var spawn_position = Vector2(spawn_x, 886.0)  # Altura del suelo
	
	var power_up_doble = power_up_doble_scene.instantiate()
	power_up_doble.position = spawn_position
	
	power_up_doble.power_up_doble_collected.connect(_on_power_up_doble_collected)
	add_child(power_up_doble)
	_spawns_remaining -= 1

func _on_power_up_doble_collected():
	power_up_doble_collected.emit()
