extends CanvasLayer

@onready var movilidad_upgrades = $Panel/VBoxContainer/BranchContainer/MovilidadBranch/MovilidadUpgrades
@onready var supervivencia_upgrades = $Panel/VBoxContainer/BranchContainer/SupervivenciaBranch/SupervivenciaUpgrades
@onready var close_button = $Panel/VBoxContainer/CloseButton

var upgrade_system: Node
var player: Player

signal upgrade_selected(upgrade_id: String)
signal menu_closed

func _ready():
	close_button.pressed.connect(_on_close_pressed)
	hide()

func set_upgrade_system(system: Node):
	upgrade_system = system

func set_player(p: Player):
	player = p

func show_menu():
	if not upgrade_system:
		return
	
	_clear_upgrades()
	_populate_upgrades()
	show()

func _clear_upgrades():
	for child in movilidad_upgrades.get_children():
		child.queue_free()
	for child in supervivencia_upgrades.get_children():
		child.queue_free()

func _populate_upgrades():
	var available_upgrades = upgrade_system.get_available_upgrades()
	
	for upgrade in available_upgrades:
		var upgrade_button = _create_upgrade_button(upgrade)
		
		if upgrade.branch == upgrade_system.Branch.MOVILIDAD:
			movilidad_upgrades.add_child(upgrade_button)
		elif upgrade.branch == upgrade_system.Branch.SUPERVIVENCIA:
			supervivencia_upgrades.add_child(upgrade_button)

func _create_upgrade_button(upgrade) -> Button:
	var button = Button.new()
	button.custom_minimum_size = Vector2(0, 60)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 5)
	
	var name_label = Label.new()
	name_label.text = upgrade.name
	name_label.add_theme_font_size_override("font_size", 16)
	name_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	
	var desc_label = Label.new()
	desc_label.text = upgrade.description
	desc_label.add_theme_font_size_override("font_size", 12)
	desc_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8, 1))
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	vbox.add_child(name_label)
	vbox.add_child(desc_label)
	
	button.add_child(vbox)
	
	# Mostrar prerrequisitos si existen
	if upgrade.prerequisites.size() > 0:
		var prereq_label = Label.new()
		var prereq_text = "Requiere: "
		for i in range(upgrade.prerequisites.size()):
			var prereq_id = upgrade.prerequisites[i]
			var prereq_upgrade = upgrade_system.get_upgrade(prereq_id)
			if prereq_upgrade:
				prereq_text += prereq_upgrade.name
				if i < upgrade.prerequisites.size() - 1:
					prereq_text += ", "
		prereq_label.text = prereq_text
		prereq_label.add_theme_font_size_override("font_size", 10)
		prereq_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6, 1))
		vbox.add_child(prereq_label)
	
	button.pressed.connect(_on_upgrade_button_pressed.bind(upgrade.id))
	
	return button

func _on_upgrade_button_pressed(upgrade_id: String):
	if upgrade_system and player:
		upgrade_system.unlock_upgrade(upgrade_id)
		upgrade_system.apply_upgrade_to_player(upgrade_id, player)
		upgrade_selected.emit(upgrade_id)
		hide()
		menu_closed.emit()

func _on_close_pressed():
	hide()
	menu_closed.emit()
