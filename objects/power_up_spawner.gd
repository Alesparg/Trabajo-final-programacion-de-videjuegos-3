extends Node2D

signal power_up_collected

@export var power_up_scene: PackedScene
@export var spawn_positions: Array[Vector2] = [Vector2(200, 80), Vector2(500, 80)]
@export var spawn_intervals: Array[float] = [15.0, 15.0]
@export var fall_speeds: Array[float] = [200.0, 200.0]
@export var max_spawns: int = 2

var _timer: float = 0.0
var _spawn_index: int = 0
var _spawns_remaining: int = 2

func _ready():
	_reset_timer()
	_spawns_remaining = max_spawns

func _process(delta):
	if _spawns_remaining <= 0:
		return
	
	_timer -= delta
	if _timer <= 0.0:
		_spawn_power_up()
		_reset_timer()

func _reset_timer():
	if spawn_intervals.size() > 0:
		_timer = spawn_intervals[_spawn_index % spawn_intervals.size()]
	else:
		_timer = 15.0

func _spawn_power_up():
	if _spawns_remaining <= 0:
		return
	
	var player_group = get_tree().get_nodes_in_group("player")
	if player_group.size() == 0:
		return
	
	var player = player_group[0]
	var player_x = player.global_position.x
	
	# Posición aleatoria en el suelo, cerca del jugador pero no sobre él
	var offset = randf_range(-200.0, 200.0)
	var spawn_x = clamp(player_x + offset, 64.0, 960.0)
	var spawn_position = Vector2(spawn_x, 886.0)  # Altura del suelo
	
	var power_up = power_up_scene.instantiate()
	power_up.position = spawn_position
	power_up.fall_speed = 0.0  # No cae, aparece en el suelo
	
	power_up.power_up_collected.connect(_on_power_up_collected)
	add_child(power_up)
	_spawn_index += 1
	_spawns_remaining -= 1

func _on_power_up_collected():
	power_up_collected.emit()
