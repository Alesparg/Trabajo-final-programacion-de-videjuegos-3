extends Node2D

signal esmeralda_caught(points: int)

@export var esmeralda_scene: PackedScene
@export var spawn_positions: Array[Vector2] = [Vector2(200, 80), Vector2(450, 80), Vector2(700, 80)]
@export var spawn_intervals: Array[float] = [4.0, 5.0, 4.0]
@export var fall_speeds: Array[float] = [200.0, 200.0, 200.0]

var _timer: float = 0.0
var _spawn_index: int = 0

func _ready():
	_reset_timer()

func _process(delta):
	_timer -= delta
	if _timer <= 0.0:
		_spawn_esmeralda()
		_reset_timer()

func _reset_timer():
	if spawn_intervals.size() > 0:
		_timer = spawn_intervals[_spawn_index % spawn_intervals.size()]
	else:
		_timer = 4.0

func _spawn_esmeralda():
	if spawn_positions.size() == 0:
		return
	
	var esmeralda = esmeralda_scene.instantiate()
	esmeralda.position = spawn_positions[_spawn_index % spawn_positions.size()]
	
	if fall_speeds.size() > 0:
		esmeralda.fall_speed = fall_speeds[_spawn_index % fall_speeds.size()]
	else:
		esmeralda.fall_speed = 200.0
	
	esmeralda.caught.connect(_on_esmeralda_caught)
	add_child(esmeralda)
	_spawn_index += 1

func _on_esmeralda_caught(points: int):
	esmeralda_caught.emit(points)
