
extends Node2D
#escena principal del nivel, administra condiciones del juego

const MATCH_DURATION = 120.0

var spawn_point = Vector2()
@export var player_scene: PackedScene
@onready var death_counter: Label = $death_counter
@onready var score_counter: Label = $score_counter
@onready var timer_counter: Label = $timer_counter
@onready var health_bar: ProgressBar = $HealthBar
@onready var game_over_menu: CanvasLayer = $GameOverMenu
@onready var game_over_score: Label = $GameOverMenu/CenterContainer/VBoxContainer/ScoreLabel
var victory_menu: CanvasLayer
var victory_score: Label
var deaths_value = 0
var score_value = 0
var time_remaining = MATCH_DURATION
var game_over = false
var deaths_string = "Deaths: %0*d"
var score_string = "Puntos: %0*d"

func _ready():
	#no es el mejor modo, puede obtener una referencia directamente
	var player_group = get_tree().get_nodes_in_group("player")
	if player_group.size()>0:
		spawn_point = $player_spawn.global_position
		(player_group[0] as Player).im_dead.connect(_on_player_dead)
		(player_group[0] as Player).health_changed.connect(_on_health_changed)
	$metal_box_spawner.metal_box_caught.connect(_on_metal_box_caught)
	if has_node("esmeralda_spawner"):
		$esmeralda_spawner.esmeralda_caught.connect(_on_esmeralda_caught)
	if has_node("diamante_spawner"):
		$diamante_spawner.diamante_caught.connect(_on_diamante_caught)
	if has_node("power_up_spawner"):
		$power_up_spawner.power_up_collected.connect(_on_power_up_collected)
	death_counter.text = deaths_string%[3,deaths_value]
	score_counter.text = score_string%[4,score_value]
	timer_counter.text = _format_time(time_remaining)
	health_bar.value = 100.0
	game_over_menu.hide()
	if has_node("VictoryMenu"):
		victory_menu = $VictoryMenu
		victory_score = $VictoryMenu/CenterContainer/VBoxContainer/ScoreLabel
		victory_menu.hide()
	$GameOverMenu/CenterContainer/VBoxContainer/Buttons/RetryButton.pressed.connect(_on_retry_pressed)
	$GameOverMenu/CenterContainer/VBoxContainer/Buttons/ExitButton.pressed.connect(_on_exit_pressed)
	if has_node("VictoryMenu"):
		if has_node("VictoryMenu/CenterContainer/VBoxContainer/Buttons/Level2Button"):
			$VictoryMenu/CenterContainer/VBoxContainer/Buttons/Level2Button.pressed.connect(_on_level2_pressed)
		if has_node("VictoryMenu/CenterContainer/VBoxContainer/Buttons/Level3Button"):
			$VictoryMenu/CenterContainer/VBoxContainer/Buttons/Level3Button.pressed.connect(_on_level3_pressed)
		$VictoryMenu/CenterContainer/VBoxContainer/Buttons/ExitButton.pressed.connect(_on_exit_pressed)
	#Si no se carga como placeholder
	#$comments.hide()

func _process(delta):
	if game_over:
		return
	time_remaining -= delta
	if time_remaining <= 0.0:
		time_remaining = 0.0
		timer_counter.text = _format_time(time_remaining)
		_end_game()
		return
	timer_counter.text = _format_time(time_remaining)

func _format_time(seconds: float) -> String:
	var total_seconds = int(seconds)
	var minutes = total_seconds / 60
	var secs = total_seconds % 60
	return "%02d:%02d" % [minutes, secs]

func _end_game():
	game_over = true
	$meteor_spawner.set_process(false)
	$metal_box_spawner.set_process(false)
	if has_node("meteor_largo_spawner"):
		$meteor_largo_spawner.set_process(false)
	if has_node("esmeralda_spawner"):
		$esmeralda_spawner.set_process(false)
	for player in get_tree().get_nodes_in_group("player"):
		player.set_physics_process(false)
	
	if score_value >= 200:
		if has_node("VictoryMenu"):
			victory_score.text = "Puntuación: %d" % score_value
			victory_menu.show()
		else:
			get_tree().change_scene_to_file("res://main/colworld2.tscn")
	else:
		game_over_score.text = "Puntuación: %d" % score_value
		game_over_menu.show()

func _on_retry_pressed():
	get_tree().reload_current_scene()

func _on_exit_pressed():
	get_tree().quit()

func _on_level2_pressed():
	get_tree().change_scene_to_file("res://main/colworld2.tscn")

func _on_level3_pressed():
	get_tree().change_scene_to_file("res://main/colworld3.tscn")

func _on_player_dead(): 
	if game_over:
		return
	# no es el mejor modo, se puede tener una referencia a la escena player en su lugar
	var new_player = player_scene.instantiate() #null checks antes de esto
	new_player.position = spawn_point 
	# el motor no puede modificar el mundo físico en este punto, hay que retrasar el reingreso del player
	restart_player.call_deferred(new_player)
	deaths_value += 1
	death_counter.text = deaths_string%[3,deaths_value]

func restart_player(player_ref:Player):
	add_child(player_ref)
	player_ref.im_dead.connect(_on_player_dead)
	player_ref.health_changed.connect(_on_health_changed)

func _on_metal_box_caught(points: int):
	if game_over:
		return
	score_value += points
	score_counter.text = score_string%[4,score_value]

func _on_esmeralda_caught(points: int):
	if game_over:
		return
	score_value += points
	score_counter.text = score_string%[4,score_value]

func _on_diamante_caught(points: int):
	if game_over:
		return
	score_value += points
	score_counter.text = score_string%[4,score_value]

func _on_health_changed(health, max_health):
	var health_percentage = float(health) / float(max_health) * 100.0
	health_bar.value = health_percentage

func _on_power_up_collected():
	if game_over:
		return
	var player_group = get_tree().get_nodes_in_group("player")
	if player_group.size() > 0:
		var player = player_group[0] as Player
		player.activate_speed_boost()
