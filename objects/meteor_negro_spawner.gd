extends Node2D

@export var meteor_negro_scene: PackedScene
@export var spawn_positions: Array[Vector2] = [Vector2(350, 80), Vector2(750, 80)]
@export var spawn_intervals: Array[float] = [6.0, 6.0]
@export var fall_speeds: Array[float] = [500.0, 500.0]

var _timer: float = 0.0
var _spawn_index: int = 0

func _ready():
	_reset_timer()

func _process(delta):
	_timer -= delta
	if _timer <= 0.0:
		_spawn_meteor_negro()
		_reset_timer()

func _reset_timer():
	if spawn_intervals.size() > 0:
		_timer = spawn_intervals[_spawn_index % spawn_intervals.size()]
	else:
		_timer = 6.0

func _spawn_meteor_negro():
	if spawn_positions.size() == 0:
		return
	
	var meteor = meteor_negro_scene.instantiate()
	meteor.position = spawn_positions[_spawn_index % spawn_positions.size()]
	
	if fall_speeds.size() > 0:
		meteor.fall_speed = fall_speeds[_spawn_index % fall_speeds.size()]
	else:
		meteor.fall_speed = 350.0
	
	add_child(meteor)
	_spawn_index += 1
