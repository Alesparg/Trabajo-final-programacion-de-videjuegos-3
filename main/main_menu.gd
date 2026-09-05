extends Control

@export var game_scene: PackedScene

var music_volume: float = 1.0
var save_system: Node

func _ready():
	# Cargar sistema de guardado
	save_system = preload("res://save_system.gd").new()
	add_child(save_system)
	
	# Cargar volumen guardado (usar bus Master índice 0)
	music_volume = AudioServer.get_bus_volume_db(0)
	$SoundPanel/VBoxContainer/VolumeSlider.value = db_to_linear(music_volume)
	
	# Verificar si hay partida guardada
	if save_system.has_save():
		$CenterContainer/VBoxContainer/Buttons/ContinueButton.visible = true
		$CenterContainer/VBoxContainer/Buttons/NewGameButton.text = "Nueva Partida"
	else:
		$CenterContainer/VBoxContainer/Buttons/ContinueButton.visible = false
		$CenterContainer/VBoxContainer/Buttons/NewGameButton.text = "Jugar"
	
	$CenterContainer/VBoxContainer/Buttons/ContinueButton.pressed.connect(_on_continue_pressed)
	$CenterContainer/VBoxContainer/Buttons/NewGameButton.pressed.connect(_on_new_game_pressed)
	$CenterContainer/VBoxContainer/Buttons/AboutButton.pressed.connect(_on_about_pressed)
	$CenterContainer/VBoxContainer/Buttons/ControlsButton.pressed.connect(_on_controls_pressed)
	$CenterContainer/VBoxContainer/Buttons/LevelSelectButton.pressed.connect(_on_level_select_pressed)
	$CenterContainer/VBoxContainer/Buttons/SoundButton.pressed.connect(_on_sound_pressed)
	$CenterContainer/VBoxContainer/Buttons/ExitButton.pressed.connect(_on_exit_pressed)
	$AboutPanel/VBoxContainer/BackButton.pressed.connect(_on_back_pressed)
	$ControlsPanel/VBoxContainer/BackButton.pressed.connect(_on_back_pressed)
	$SoundPanel/VBoxContainer/BackButton.pressed.connect(_on_back_pressed)
	$SoundPanel/VBoxContainer/VolumeSlider.value_changed.connect(_on_volume_changed)
	$LevelSelectPanel/VBoxContainer/LevelButtons/Level1Button.pressed.connect(_on_level1_pressed)
	$LevelSelectPanel/VBoxContainer/LevelButtons/Level2Button.pressed.connect(_on_level2_pressed)
	$LevelSelectPanel/VBoxContainer/LevelButtons/Level3Button.pressed.connect(_on_level3_pressed)
	$LevelSelectPanel/VBoxContainer/LevelButtons/Level4Button.pressed.connect(_on_level4_pressed)
	$LevelSelectPanel/VBoxContainer/LevelButtons/Level5Button.pressed.connect(_on_level5_pressed)
	$LevelSelectPanel/VBoxContainer/BackButton.pressed.connect(_on_back_pressed)

func _on_continue_pressed():
	var save_data = save_system.load_game()
	if save_data:
		var level = save_data["current_level"]
		match level:
			1: get_tree().change_scene_to_file("res://main/colworld.tscn")
			2: get_tree().change_scene_to_file("res://main/colworld2.tscn")
			3: get_tree().change_scene_to_file("res://main/colworld3.tscn")
			4: get_tree().change_scene_to_file("res://main/colworld4.tscn")
			5: get_tree().change_scene_to_file("res://main/colworld5.tscn")

func _on_new_game_pressed():
	# Borrar partida guardada si existe
	save_system.delete_save()
	
	# Iniciar nueva partida desde el nivel 1
	get_tree().change_scene_to_file("res://main/colworld.tscn")

func _on_exit_pressed():
	get_tree().quit()

func _on_about_pressed():
	$AboutPanel.visible = true

func _on_controls_pressed():
	$ControlsPanel.visible = true

func _on_back_pressed():
	$AboutPanel.visible = false
	$ControlsPanel.visible = false
	$LevelSelectPanel.visible = false
	$SoundPanel.visible = false

func _on_level_select_pressed():
	$LevelSelectPanel.visible = true

func _on_sound_pressed():
	$SoundPanel.visible = true

func _on_volume_changed(value: float):
	music_volume = linear_to_db(value)
	AudioServer.set_bus_volume_db(0, music_volume)

func _on_level1_pressed():
	get_tree().change_scene_to_file("res://main/colworld.tscn")

func _on_level2_pressed():
	get_tree().change_scene_to_file("res://main/colworld2.tscn")

func _on_level3_pressed():
	get_tree().change_scene_to_file("res://main/colworld3.tscn")

func _on_level4_pressed():
	get_tree().change_scene_to_file("res://main/colworld4.tscn")

func _on_level5_pressed():
	get_tree().change_scene_to_file("res://main/colworld5.tscn")
