
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
var upgrade_menu: CanvasLayer
var upgrade_system: Node
var level_guide: CanvasLayer
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
	if has_node("fase_espectral_spawner"):
		$fase_espectral_spawner.fase_espectral_collected.connect(_on_fase_espectral_collected)
	death_counter.text = deaths_string%[3,deaths_value]
	score_counter.text = score_string%[4,score_value]
	timer_counter.text = _format_time(time_remaining)
	health_bar.value = 100.0
	game_over_menu.hide()
	if has_node("VictoryMenu"):
		victory_menu = $VictoryMenu
		victory_score = $VictoryMenu/CenterContainer/VBoxContainer/ScoreLabel
		victory_menu.hide()
	if has_node("UpgradeMenu"):
		upgrade_menu = $UpgradeMenu
		upgrade_menu.hide()
	if has_node("LevelGuide"):
		level_guide = $LevelGuide
		level_guide.hide()
		level_guide.guide_closed.connect(_on_guide_closed)
	
	# Inicializar sistema de mejoras
	_initialize_upgrade_system()
	
	# Aplicar mejoras desbloqueadas al jugador
	if player_group.size()>0:
		_apply_unlocked_upgrades(player_group[0] as Player)
	
	# Mostrar guía del nivel al inicio
	_show_level_guide()
	
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

func _initialize_upgrade_system():
	var upgrade_system_scene = load("res://systems/upgrade_system.gd")
	if upgrade_system_scene:
		upgrade_system = upgrade_system_scene.new()
		add_child(upgrade_system)
		
		if has_node("UpgradeMenu"):
			upgrade_menu = $UpgradeMenu
			upgrade_menu.set_upgrade_system(upgrade_system)
			upgrade_menu.upgrade_selected.connect(_on_upgrade_selected)
			upgrade_menu.menu_closed.connect(_on_upgrade_menu_closed)

func _apply_unlocked_upgrades(player: Player):
	if not upgrade_system:
		return
	
	for upgrade_id in upgrade_system.upgrades.keys():
		if upgrade_system.is_upgrade_unlocked(upgrade_id):
			upgrade_system.apply_upgrade_to_player(upgrade_id, player)

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
	_show_upgrade_menu_before_level_change("res://main/colworld2.tscn")

func _on_level3_pressed():
	_show_upgrade_menu_before_level_change("res://main/colworld3.tscn")

func _show_upgrade_menu_before_level_change(next_level_path: String):
	if upgrade_menu and upgrade_system:
		var available_upgrades = upgrade_system.get_available_upgrades()
		if available_upgrades.size() > 0:
			# Hay mejoras disponibles, mostrar menú
			var player_group = get_tree().get_nodes_in_group("player")
			if player_group.size() > 0:
				upgrade_menu.set_player(player_group[0] as Player)
				upgrade_menu.show_menu()
				# Guardar el nivel destino para cambiar después de seleccionar mejora
				_next_level_path = next_level_path
				return
	
	# No hay mejoras disponibles, cambiar directamente de nivel
	get_tree().change_scene_to_file(next_level_path)

var _next_level_path: String = ""

func _on_upgrade_menu_closed():
	if _next_level_path != "":
		get_tree().change_scene_to_file(_next_level_path)
		_next_level_path = ""

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

func _on_fase_espectral_collected():
	if game_over:
		return
	var player_group = get_tree().get_nodes_in_group("player")
	if player_group.size() > 0:
		var player = player_group[0] as Player
		player.activate_spectral_phase()

func _on_upgrade_selected(upgrade_id: String):
	print("Mejora seleccionada: ", upgrade_id)

func _show_level_guide():
	if level_guide:
		# Determinar el nivel actual verificando qué nodos existen
		var has_esmeralda_spawner = has_node("esmeralda_spawner")
		var has_meteor_largo_spawner = has_node("meteor_largo_spawner")
		var has_diamante_spawner = has_node("diamante_spawner")
		var has_meteor_negro_spawner = has_node("meteor_negro_spawner")
		
		print("Nivel 2 detectado (esmeralda): ", has_esmeralda_spawner)
		print("Nivel 2 detectado (meteor_largo): ", has_meteor_largo_spawner)
		print("Nivel 3 detectado (diamante): ", has_diamante_spawner)
		print("Nivel 3 detectado (meteor_negro): ", has_meteor_negro_spawner)
		
		# Verificar primero nivel 3 (nivel más alto)
		if has_diamante_spawner or has_meteor_negro_spawner:
			var text = "🤖 RECO: ¡Estoy de vuelta colega! Y... traigo novedades. Bueno, creo que son novedades.\n\nTenemos un nuevo mineral: ¡el diamante! 💎 Vale nada menos que 100 puntos. ¡Cien! Eso es muchísimo. Así que si ves uno, ¡no lo pierdas!\n\nTambién apareció un nuevo power-up. ⚡ ¡Ahora puedes volverte completamente inmune al daño! Sí, leíste bien: durante un rato los meteoritos pueden golpearte y no te pasará nada. ¡Por fin una razón para dejar de esquivarlos!\n\n...Aunque probablemente sea mejor seguir esquivándolos.\n\nY hablando de meteoritos... ☄️ apareció uno MUY rápido. Cae tan rápido que apenas tendrás tiempo de verlo venir.\n\nAsí que si escuchas un ¡FUUUUSH!...\n\ncorre primero y pregunta después. 😎\n\n¡Buena suerte, recolector! ¡Y trata de no convertirte en polvo espacial! 🚀"
			level_guide.set_guide_content("", text)
		elif has_esmeralda_spawner or has_meteor_largo_spawner:
			var text = "RECO: \"¡Volvió tu guía favorito! Bueno... el único que tienes.\n\nPrimero, ¡un nuevo mineral: la esmeralda! 💚 Creo que vale 80 puntos... o eran 70... Bueno, ¡vale un montón! Así que si ves una, ¡agárrala!\n\nTambién apareció un nuevo meteorito. ☄️ Hace bastante más daño que los normales. ¿Cuánto exactamente? Mmm... mejor no averiguarlo. 😅\n\nY por último... ¡un power-up de velocidad! ⚡ Ahora podrás moverte mucho más rápido. Perfecto para escapar de los meteoritos, llegar antes a los minerales o... ir a toda velocidad contra una pared.\n\nPero recomiendo las dos primeras opciones. 😎\n\n¡Buena suerte, recolector! 🚀"
			level_guide.set_guide_content("", text)
		else:
			# Nivel 1: guía por defecto sin imagen
			var text = "🤖 **RECO:** ¡Hola, hola! Soy **RECO**, tu guía oficial, experto en recolección, supervivencia y... bueno, en realidad no estoy seguro de tener el título para ninguna de esas cosas. 😎 ¡Pero vamos a intentarlo!

¡Bienvenido, amigo, amiga... o lo que sea que seas! 😎 ¡Bienvenido a **El Recolector de los Cielos**! Tu misión es sencilla: **atrapar todos los minerales que puedas mientras esquivas esos meteoritos que intentan convertirte en polvo espacial.**

Ah, y presta atención a los minerales, colega. No todos valen lo mismo: **el metal es el que menos puntos da, el cobre da un poco más y el oro... bueno, el oro es el que más puntos da por ahora.**

Bueno, ya aprenderás. ¡Yo tampoco estaba prestando mucha atención cuando explicaron eso!

¡Vamos, recolector! ¡El cielo no se va a recolectar solo! 🚀"
			level_guide.set_guide_content("", text)
		
		level_guide.show_guide()
		# Pausar el procesamiento del nivel
		set_process(false)
		set_physics_process(false)

func _on_guide_closed():
	# Reanudar el procesamiento del nivel
	set_process(true)
	set_physics_process(true)
