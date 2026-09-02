extends Control

@export var game_scene: PackedScene

var music_volume: float = 1.0

func _ready():
	# Cargar volumen guardado (usar bus Master índice 0)
	music_volume = AudioServer.get_bus_volume_db(0)
	$SoundPanel/VBoxContainer/VolumeSlider.value = db_to_linear(music_volume)
	
	$CenterContainer/VBoxContainer/Buttons/PlayButton.pressed.connect(_on_play_pressed)
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

func _on_play_pressed():
	if game_scene:
		get_tree().change_scene_to_packed(game_scene)
	else:
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
