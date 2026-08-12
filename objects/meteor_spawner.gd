extends Node2D

@export var meteor_scene: PackedScene
@export var spawn_positions: Array[Vector2] = [Vector2(100, 80), Vector2(300, 80), Vector2(500, 80), Vector2(700, 80), Vector2(900, 80)]
@export var spawn_intervals: Array[float] = [1.0, 1.5, 2.0, 1.5, 1.0]
@export var fall_speeds: Array[float] = [350.0, 350.0, 350.0, 350.0, 350.0]

var _timer: float = 0.0
var _spawn_index: int = 0

func _ready():
	_reset_timer()

func _process(delta):
	_timer -= delta
	if _timer <= 0.0:
		_spawn_meteor()
		_reset_timer()

func _reset_timer():
	if spawn_intervals.size() > 0:
		_timer = spawn_intervals[_spawn_index % spawn_intervals.size()]
	else:
		_timer = 1.0

func _spawn_meteor():
	if spawn_positions.size() == 0:
		return
	
	var meteor = meteor_scene.instantiate()
	meteor.position = spawn_positions[_spawn_index % spawn_positions.size()]
	
	if fall_speeds.size() > 0:
		meteor.fall_speed = fall_speeds[_spawn_index % fall_speeds.size()]
	else:
		meteor.fall_speed = 350.0
	
	add_child(meteor)
	_spawn_index += 1
