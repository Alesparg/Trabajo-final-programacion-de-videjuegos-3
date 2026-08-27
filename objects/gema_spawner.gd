extends Node2D

signal gema_caught(points: int)

@export var gema_scene: PackedScene
@export var spawn_positions: Array[Vector2] = [Vector2(200, 80), Vector2(450, 80), Vector2(700, 80)]
@export var spawn_intervals: Array[float] = [5.0, 6.0, 5.0]
@export var fall_speeds: Array[float] = [200.0, 200.0, 200.0]

var _timer: float = 0.0
var _spawn_index: int = 0

func _ready():
	_reset_timer()

func _process(delta):
	_timer -= delta
	if _timer <= 0.0:
		_spawn_gema()
		_reset_timer()

func _reset_timer():
	if spawn_intervals.size() > 0:
		_timer = spawn_intervals[_spawn_index % spawn_intervals.size()]
	else:
		_timer = 5.0

func _spawn_gema():
	if spawn_positions.size() == 0:
		return
	
	var gema = gema_scene.instantiate()
	gema.position = spawn_positions[_spawn_index % spawn_positions.size()]
	
	if fall_speeds.size() > 0:
		gema.fall_speed = fall_speeds[_spawn_index % fall_speeds.size()]
	else:
		gema.fall_speed = 200.0
	
	gema.caught.connect(_on_gema_caught)
	add_child(gema)
	_spawn_index += 1

func _on_gema_caught(points: int):
	gema_caught.emit(points)
