extends CanvasLayer

signal guide_closed

@onready var continue_button = $Panel/VBoxContainer/ContinueButton
@onready var guide_image = $Panel/VBoxContainer/ContentContainer/GuideImage
@onready var guide_text = $Panel/VBoxContainer/ContentContainer/TextContainer/GuideText

var paused_nodes: Array = []

func _ready():
	if continue_button:
		continue_button.pressed.connect(_on_continue_pressed)
		print("Botón continuar conectado")
	else:
		print("ERROR: No se encontró el botón continuar")
	hide()

func set_guide_content(image_path: String, text_content: String):
	if guide_image:
		if image_path != "":
			var texture = load(image_path)
			if texture:
				guide_image.texture = texture
				guide_image.visible = true
		else:
			guide_image.visible = false
	
	if guide_text:
		guide_text.text = text_content

func show_guide():
	show()
	_pause_game_nodes()

func _pause_game_nodes():
	paused_nodes.clear()
	
	# Pausar jugador
	var player_group = get_tree().get_nodes_in_group("player")
	for player in player_group:
		if player.process_mode != Node.PROCESS_MODE_DISABLED:
			paused_nodes.append({"node": player, "mode": player.process_mode})
			player.set_process_mode(Node.PROCESS_MODE_DISABLED)
	
	# Pausar spawners
	var spawners = get_tree().get_nodes_in_group("spawner")
	for spawner in spawners:
		if spawner.process_mode != Node.PROCESS_MODE_DISABLED:
			paused_nodes.append({"node": spawner, "mode": spawner.process_mode})
			spawner.set_process_mode(Node.PROCESS_MODE_DISABLED)
	
	# Pausar meteoritos y otros objetos
	var meteors = get_tree().get_nodes_in_group("meteor")
	for meteor in meteors:
		if meteor.process_mode != Node.PROCESS_MODE_DISABLED:
			paused_nodes.append({"node": meteor, "mode": meteor.process_mode})
			meteor.set_process_mode(Node.PROCESS_MODE_DISABLED)

func _resume_game_nodes():
	for node_data in paused_nodes:
		node_data.node.set_process_mode(node_data.mode)
	paused_nodes.clear()

func _on_continue_pressed():
	print("Botón continuar presionado")
	hide()
	_resume_game_nodes()
	guide_closed.emit()
