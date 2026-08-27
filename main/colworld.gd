
extends Node2D
#escena principal del nivel, administra condiciones del juego

const MATCH_DURATION = 120.0
const MAX_DEATHS = 3

var level_score_requirements = {
	1: 400,
	2: 1000,
	3: 1800,
	4: 2800,
	5: 3750
}

var reco_defeat_messages = [
	"🤖 RECO: Como experto en supervivencia espacial, debo decirte que...\neso era exactamente lo que no había que hacer. 😎",
	"🤖 RECO: ¡Eeeeh...! ¿Estás bien? 😰\nBueno, técnicamente no estás muy bien... pero podemos intentarlo otra vez. 😎",
	"🤖 RECO: ¡No pasa nada, recolector! 💪\nYa sabes qué te espera, así que la próxima vez estaremos preparados.\nBueno... tú estarás preparado. Yo solo voy a mirar. 😎"
]

var reco_final_victory_message = "🤖 RECO: ¡¿LO LOGRAMOS?! 🎉🚀 ¡No puedo creerlo, recolector! ¡Completaste todos los niveles y sobreviviste a meteoritos cada vez más absurdos!

Recogiste minerales, esquivaste meteoritos, conseguiste mejoras y, contra todo pronóstico... ¡no terminaste convertido en polvo espacial! 😎

Debo admitirlo, hiciste un gran trabajo. Aunque... siendo sincero, yo también ayudé bastante. Bueno... te di algunos consejos. 😅

¡Felicidades, recolector! 💎🏆
¡El cielo está oficialmente recolectado!

...Bueno, casi. Seguro que nos olvidamos de algo. 😂

🚀 ¡Hasta la próxima, recolector!"

var spawn_point = Vector2()
@export var player_scene: PackedScene
@onready var death_counter: Label = $death_counter
@onready var score_counter: Label = $score_counter
@onready var timer_counter: Label = $timer_counter
@onready var health_bar: ProgressBar = $HealthBar
@onready var game_over_menu: CanvasLayer = $GameOverMenu
@onready var game_over_score: Label = $GameOverMenu/CenterContainer/VBoxContainer/ScoreLabel
@onready var game_over_reco_message: Label = $GameOverMenu/CenterContainer/VBoxContainer/RecoMessage
@onready var victory_reco_message: Label = $VictoryMenu/CenterContainer/VBoxContainer/RecoMessage
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
	if has_node("gema_spawner"):
		$gema_spawner.gema_caught.connect(_on_gema_caught)
	if has_node("power_up_spawner"):
		$power_up_spawner.power_up_collected.connect(_on_power_up_collected)
	if has_node("fase_espectral_spawner"):
		$fase_espectral_spawner.fase_espectral_collected.connect(_on_fase_espectral_collected)
	if has_node("power_up_doble_spawner"):
		$power_up_doble_spawner.power_up_doble_collected.connect(_on_power_up_doble_collected)
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
		if has_node("VictoryMenu/CenterContainer/VBoxContainer/Buttons/ExitButton"):
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

func _get_current_level() -> int:
	var has_esmeralda_spawner = has_node("esmeralda_spawner")
	var has_meteor_largo_spawner = has_node("meteor_largo_spawner")
	var has_diamante_spawner = has_node("diamante_spawner")
	var has_meteor_negro_spawner = has_node("meteor_negro_spawner")
	var has_meteor_cambiante_spawner = has_node("meteor_cambiante_spawner")
	var has_bloque_obstaculo = has_node("bloque_obstaculo_1")
	
	if has_bloque_obstaculo:
		return 5
	elif has_meteor_cambiante_spawner or has_meteor_negro_spawner:
		return 4
	elif has_diamante_spawner:
		return 3
	elif has_esmeralda_spawner or has_meteor_largo_spawner:
		return 2
	else:
		return 1

func _end_game():
	game_over = true
	$meteor_spawner.set_process(false)
	$metal_box_spawner.set_process(false)
	if has_node("meteor_largo_spawner"):
		$meteor_largo_spawner.set_process(false)
	if has_node("esmeralda_spawner"):
		$esmeralda_spawner.set_process(false)
	if has_node("gema_spawner"):
		$gema_spawner.set_process(false)
	for player in get_tree().get_nodes_in_group("player"):
		player.set_physics_process(false)
	
	var current_level = _get_current_level()
	var required_score = level_score_requirements[current_level]
	
	# Verificar condiciones de derrota
	if deaths_value >= MAX_DEATHS:
		_show_game_over("Derrota por muertes")
		return
	
	# Verificar si alcanzó la puntuación requerida
	if score_value >= required_score:
		if current_level == 5:
			# Victoria final del juego
			if has_node("VictoryMenu"):
				victory_score.text = "Puntuación: %d" % score_value
				victory_reco_message.text = reco_final_victory_message
				victory_menu.show()
			else:
				game_over_score.text = "¡VICTORIA FINAL! Puntuación: %d" % score_value
				game_over_menu.show()
		else:
			# Pasar al siguiente nivel
			if has_node("VictoryMenu"):
				victory_score.text = "Puntuación: %d" % score_value
				victory_menu.show()
			else:
				var next_level_path = "res://main/colworld%d.tscn" % (current_level + 1)
				get_tree().change_scene_to_file(next_level_path)
	else:
		_show_game_over("Objetivo: %d" % required_score)

func _show_game_over(reason: String):
	var random_message = reco_defeat_messages[randi() % reco_defeat_messages.size()]
	game_over_score.text = "Puntuación: %d (%s)" % [score_value, reason]
	game_over_reco_message.text = random_message
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
	deaths_value += 1
	death_counter.text = deaths_string%[3,deaths_value]
	
	# Verificar si alcanzó el límite de muertes
	if deaths_value >= MAX_DEATHS:
		_end_game()
		return
	
	# no es el mejor modo, se puede tener una referencia a la escena player en su lugar
	var new_player = player_scene.instantiate() #null checks antes de esto
	new_player.position = spawn_point 
	# el motor no puede modificar el mundo físico en este punto, hay que retrasar el reingreso del player
	restart_player.call_deferred(new_player)

func restart_player(player_ref:Player):
	add_child(player_ref)
	player_ref.im_dead.connect(_on_player_dead)
	player_ref.health_changed.connect(_on_health_changed)

func _on_metal_box_caught(points: int):
	if game_over:
		return
	var player_group = get_tree().get_nodes_in_group("player")
	if player_group.size() > 0:
		var player = player_group[0] as Player
		if player.has_double_points_active():
			points *= 2
	score_value += points
	score_counter.text = score_string%[4,score_value]

func _on_esmeralda_caught(points: int):
	if game_over:
		return
	var player_group = get_tree().get_nodes_in_group("player")
	if player_group.size() > 0:
		var player = player_group[0] as Player
		if player.has_double_points_active():
			points *= 2
	score_value += points
	score_counter.text = score_string%[4,score_value]

func _on_diamante_caught(points: int):
	if game_over:
		return
	var player_group = get_tree().get_nodes_in_group("player")
	if player_group.size() > 0:
		var player = player_group[0] as Player
		if player.has_double_points_active():
			points *= 2
	score_value += points
	score_counter.text = score_string%[4,score_value]

func _on_gema_caught(points: int):
	if game_over:
		return
	var player_group = get_tree().get_nodes_in_group("player")
	if player_group.size() > 0:
		var player = player_group[0] as Player
		if player.has_double_points_active():
			points *= 2
	score_value += points
	score_counter.text = score_string%[4,score_value]

func _on_power_up_doble_collected():
	if game_over:
		return
	var player_group = get_tree().get_nodes_in_group("player")
	if player_group.size() > 0:
		var player = player_group[0] as Player
		player.activate_double_points()

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
		var has_meteor_cambiante_spawner = has_node("meteor_cambiante_spawner")
		var has_bloque_obstaculo = has_node("bloque_obstaculo_1")
		
		print("Nivel 2 detectado (esmeralda): ", has_esmeralda_spawner)
		print("Nivel 2 detectado (meteor_largo): ", has_meteor_largo_spawner)
		print("Nivel 3 detectado (diamante): ", has_diamante_spawner)
		print("Nivel 3 detectado (meteor_negro): ", has_meteor_negro_spawner)
		print("Nivel 4 detectado (meteor_cambiante): ", has_meteor_cambiante_spawner)
		print("Nivel 5 detectado (bloque_obstaculo): ", has_bloque_obstaculo)
		
		# Verificar primero nivel 5 (nivel más alto)
		if has_bloque_obstaculo:
			var text = "🤖 **RECO:** ¡Hola de nuevo, recolector! ¡RECO está aquí para el nivel FINAL! 🎉

¡Sí, colega, este es el último nivel! ¡El gran final! ¡El momento de la verdad!

Pero espera... antes de que te emociones demasiado, tengo malas noticias.

Muy malas noticias.

¿Ves esos bloques grises en el suelo? 🧱

Sí, esos. Los que parecen inofensivos.

**¡PUES NO LO SON!**

Son obstáculos que te van a dificultar el movimiento. Ya no podrás correr libremente por el suelo como antes. Ahora tendrás que esquivar bloques mientras esquivas meteoritos.

¡Es como un doble desafío! ¡Doble dificultad! ¡Doble... bueno, doble de todo!

¿Qué más hay? Bueno, este nivel tiene TODO lo de los anteriores:

- La gema de 120 puntos 💎
- El power-up de puntos dobles ⚡
- El meteorito que cambia de trayectoria ☄️
- TODOS los otros minerales y meteoritos

Y ahora, además, ¡bloques en el suelo que te estorban!

**⚠️ REGLAS IMPORTANTES:**
- Necesitas **3750 puntos** para ganar el juego
- Si mueres **4 veces o más**, pierdes automáticamente
- Si no alcanzas los **3750 puntos** cuando termine el tiempo, pierdes

¿Crees que puedes con esto? ¡Yo creo que sí! ¡Bueno... espero que sí! Porque si no, ¡será el fin del recolector!

¡Buena suerte, recolector! ¡Y recuerda: si un bloque te bloquea... ¡salta por encima! 🚀"
			level_guide.set_guide_content("", text)
		elif has_meteor_cambiante_spawner or has_meteor_negro_spawner:
			var current_level = _get_current_level()
			var required_score = level_score_requirements[current_level]
			var text = "🤖 RECO: ¡Estoy de vuelta colega! Y... traigo novedades. Bueno, creo que son novedades.\n\nTenemos un nuevo mineral: ¡el diamante! 💎 Vale nada menos que 100 puntos. ¡Cien! Eso es muchísimo. Así que si ves uno, ¡no lo pierdas!\n\nTambién apareció un nuevo power-up. ⚡ ¡Ahora puedes volverte completamente inmune al daño! Sí, leíste bien: durante un rato los meteoritos pueden golpearte y no te pasará nada. ¡Por fin una razón para dejar de esquivarlos!\n\n...Aunque probablemente sea mejor seguir esquivándolos.\n\nY hablando de meteoritos... ☄️ apareció uno MUY rápido. Cae tan rápido que apenas tendrás tiempo de verlo venir.\n\nAsí que si escuchas un ¡FUUUUSH!...\n\ncorre primero y pregunta después. 😎\n\n**⚠️ REGLAS IMPORTANTES:**\n- Necesitas **%d puntos** para pasar al siguiente nivel\n- Si mueres **4 veces o más**, pierdes automáticamente\n- Si no alcanzas los **%d puntos** cuando termine el tiempo, pierdes\n\n¡Buena suerte, recolector! ¡Y trata de no convertirte en polvo espacial! 🚀" % [required_score, required_score]
			level_guide.set_guide_content("", text)
		elif has_esmeralda_spawner or has_meteor_largo_spawner:
			var current_level = _get_current_level()
			var required_score = level_score_requirements[current_level]
			var text = "RECO: \"¡Volvió tu guía favorito! Bueno... el único que tienes.\n\nPrimero, ¡un nuevo mineral: la esmeralda! 💚 Creo que vale 80 puntos... o eran 70... Bueno, ¡vale un montón! Así que si ves una, ¡agárrala!\n\nTambién apareció un nuevo meteorito. ☄️ Hace bastante más daño que los normales. ¿Cuánto exactamente? Mmm... mejor no averiguarlo. 😅\n\nY por último... ¡un power-up de velocidad! ⚡ Ahora podrás moverte mucho más rápido. Perfecto para escapar de los meteoritos, llegar antes a los minerales o... ir a toda velocidad contra una pared.\n\nPero recomiendo las dos primeras opciones. 😎\n\n**⚠️ REGLAS IMPORTANTES:**\n- Necesitas **%d puntos** para pasar al siguiente nivel\n- Si mueres **4 veces o más**, pierdes automáticamente\n- Si no alcanzas los **%d puntos** cuando termine el tiempo, pierdes\n\n¡Buena suerte, recolector! 🚀" % [required_score, required_score]
			level_guide.set_guide_content("", text)
		else:
			# Nivel 1: guía por defecto sin imagen
			var text = "🤖 **RECO:** ¡Hola, hola! Soy **RECO**, tu guía oficial, experto en recolección, supervivencia y... bueno, en realidad no estoy seguro de tener el título para ninguna de esas cosas. 😎 ¡Pero vamos a intentarlo!

¡Bienvenido, amigo, amiga... o lo que sea que seas! 😎 ¡Bienvenido a **El Recolector de los Cielos**! Tu misión es sencilla: **atrapar todos los minerales que puedas mientras esquivas esos meteoritos que intentan convertirte en polvo espacial.**

Ah, y presta atención a los minerales, colega. No todos valen lo mismo: **el metal es el que menos puntos da, el cobre da un poco más y el oro... bueno, el oro es el que más puntos da por ahora.**

Bueno, ya aprenderás. ¡Yo tampoco estaba prestando mucha atención cuando explicaron eso!

**⚠️ REGLAS IMPORTANTES:**
- Necesitas **400 puntos** para pasar al siguiente nivel
- Si mueres **4 veces o más**, pierdes automáticamente
- Si no alcanzas los **400 puntos** cuando termine el tiempo, pierdes

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
