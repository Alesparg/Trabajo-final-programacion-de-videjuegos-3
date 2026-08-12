extends Node2D

signal metal_box_caught(points: int)

@export var collectible_scenes: Array[PackedScene] = []
@export var spawn_positions: Array[Vector2] = [Vector2(150, 80), Vector2(400, 80), Vector2(650, 80), Vector2(850, 80)]
@export var spawn_intervals: Array[float] = [3.0, 2.5, 3.0, 2.5]
@export var fall_speeds: Array[float] = [200.0, 200.0, 200.0, 200.0]
@export var scene_indices: Array[int] = [0, 1, 2, 0, 1, 2]

var _timer: float = 0.0
var _spawn_index: int = 0

func _ready():
	_reset_timer()

func _process(delta):
	_timer -= delta
	if _timer <= 0.0:
		_spawn_metal_box()
		_reset_timer()

func _reset_timer():
	if spawn_intervals.size() > 0:
		_timer = spawn_intervals[_spawn_index % spawn_intervals.size()]
	else:
		_timer = 2.0

func _spawn_metal_box():
	if collectible_scenes.is_empty() or spawn_positions.size() == 0:
		return
	
	var scene_index = scene_indices[_spawn_index % scene_indices.size()] if scene_indices.size() > 0 else 0
	var box = collectible_scenes[scene_index % collectible_scenes.size()].instantiate()
	box.position = spawn_positions[_spawn_index % spawn_positions.size()]
	
	if fall_speeds.size() > 0:
		box.fall_speed = fall_speeds[_spawn_index % fall_speeds.size()]
	else:
		box.fall_speed = 200.0
	
	box.caught.connect(_on_metal_box_caught)
	add_child(box)
	_spawn_index += 1

func _on_metal_box_caught(points: int):
	metal_box_caught.emit(points)
