extends Node2D

signal fase_espectral_collected

@export var fase_espectral_scene: PackedScene
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
		_spawn_fase_espectral()
		_reset_timer()

func _reset_timer():
	_timer = spawn_interval

func _spawn_fase_espectral():
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
	
	var fase_espectral = fase_espectral_scene.instantiate()
	fase_espectral.position = spawn_position
	
	fase_espectral.fase_espectral_collected.connect(_on_fase_espectral_collected)
	add_child(fase_espectral)
	_spawns_remaining -= 1

func _on_fase_espectral_collected():
	fase_espectral_collected.emit()
