extends Node2D

signal diamante_caught(points: int)

@export var diamante_scene: PackedScene
@export var spawn_positions: Array[Vector2] = [Vector2(300, 80), Vector2(600, 80)]
@export var spawn_intervals: Array[float] = [5.0, 5.0]
@export var fall_speeds: Array[float] = [200.0, 200.0]

var _timer: float = 0.0
var _spawn_index: int = 0

func _ready():
	_reset_timer()

func _process(delta):
	_timer -= delta
	if _timer <= 0.0:
		_spawn_diamante()
		_reset_timer()

func _reset_timer():
	if spawn_intervals.size() > 0:
		_timer = spawn_intervals[_spawn_index % spawn_intervals.size()]
	else:
		_timer = 5.0

func _spawn_diamante():
	if spawn_positions.size() == 0:
		return
	
	var diamante = diamante_scene.instantiate()
	diamante.position = spawn_positions[_spawn_index % spawn_positions.size()]
	
	if fall_speeds.size() > 0:
		diamante.fall_speed = fall_speeds[_spawn_index % fall_speeds.size()]
	else:
		diamante.fall_speed = 200.0
	
	diamante.caught.connect(_on_diamante_caught)
	add_child(diamante)
	_spawn_index += 1

func _on_diamante_caught(points: int):
	diamante_caught.emit(points)
