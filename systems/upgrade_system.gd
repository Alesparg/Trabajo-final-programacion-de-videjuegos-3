extends Node

# Sistema de mejoras con dos ramas: Movilidad y Supervivencia
# Cada mejora tiene un ID, nombre, descripción, rama, prerrequisitos y efecto

signal upgrade_selected(upgrade_id: String)

const SAVE_FILE = "user://upgrades.save"

enum Branch {
	MOVILIDAD,
	SUPERVIVENCIA
}

class UpgradeData:
	var id: String
	var name: String
	var description: String
	var branch: Branch
	var prerequisites: Array[String]
	var unlocked: bool = false
	
	func _init(p_id: String, p_name: String, p_description: String, p_branch: Branch, p_prerequisites: Array[String] = []):
		id = p_id
		name = p_name
		description = p_description
		branch = p_branch
		prerequisites = p_prerequisites

var upgrades: Dictionary = {}

func _ready():
	_register_upgrades()
	load_upgrades()

func _register_upgrades():
	# Rama Movilidad
	upgrades["mov_1"] = UpgradeData.new("mov_1", "Agilidad Básica", "Aumenta velocidad de movimiento en un 10%", Branch.MOVILIDAD, [])
	upgrades["mov_2"] = UpgradeData.new("mov_2", "Agilidad Avanzada", "Aumenta velocidad de movimiento en un 20%", Branch.MOVILIDAD, ["mov_1"])
	upgrades["mov_3"] = UpgradeData.new("mov_3", "Salto Potenciado", "Aumenta altura de salto en un 15%", Branch.MOVILIDAD, ["mov_1"])
	upgrades["mov_4"] = UpgradeData.new("mov_4", "Maestro de Movimiento", "Aumenta velocidad de movimiento en un 30% y altura de salto en un 25%", Branch.MOVILIDAD, ["mov_2", "mov_3"])
	
	# Rama Supervivencia
	upgrades["sup_1"] = UpgradeData.new("sup_1", "Resistencia Básica", "Aumenta vida máxima en 1", Branch.SUPERVIVENCIA, [])
	upgrades["sup_2"] = UpgradeData.new("sup_2", "Resistencia Avanzada", "Aumenta vida máxima en 2", Branch.SUPERVIVENCIA, ["sup_1"])
	upgrades["sup_3"] = UpgradeData.new("sup_3", "Regeneración", "Regenera 1 de vida cada 30 segundos", Branch.SUPERVIVENCIA, ["sup_1"])
	upgrades["sup_4"] = UpgradeData.new("sup_4", "Tanque", "Aumenta vida máxima en 3 y reduce daño recibido en 20%", Branch.SUPERVIVENCIA, ["sup_2", "sup_3"])

func get_upgrade(upgrade_id: String) -> UpgradeData:
	return upgrades.get(upgrade_id)

func get_upgrades_by_branch(branch: Branch) -> Array:
	var result = []
	for upgrade in upgrades.values():
		if upgrade.branch == branch:
			result.append(upgrade)
	return result

func is_upgrade_unlocked(upgrade_id: String) -> bool:
	var upgrade = get_upgrade(upgrade_id)
	if upgrade:
		return upgrade.unlocked
	return false

func can_unlock_upgrade(upgrade_id: String) -> bool:
	var upgrade = get_upgrade(upgrade_id)
	if not upgrade:
		return false
	if upgrade.unlocked:
		return false
	
	# Verificar prerrequisitos
	for prereq in upgrade.prerequisites:
		if not is_upgrade_unlocked(prereq):
			return false
	
	return true

func unlock_upgrade(upgrade_id: String):
	var upgrade = get_upgrade(upgrade_id)
	if upgrade and can_unlock_upgrade(upgrade_id):
		upgrade.unlocked = true
		upgrade_selected.emit(upgrade_id)
		save_upgrades()

func get_available_upgrades() -> Array:
	var result = []
	for upgrade_id in upgrades.keys():
		if can_unlock_upgrade(upgrade_id):
			result.append(get_upgrade(upgrade_id))
	return result

func apply_upgrade_to_player(upgrade_id: String, player: Player):
	match upgrade_id:
		"mov_1":
			player.WALK_MAX_SPEED *= 1.1
		"mov_2":
			player.WALK_MAX_SPEED *= 1.2
		"mov_3":
			player.JUMP_SPEED *= 1.15
		"mov_4":
			player.WALK_MAX_SPEED *= 1.3
			player.JUMP_SPEED *= 1.25
		"sup_1":
			player.max_health += 1
			player.current_health += 1
		"sup_2":
			player.max_health += 2
			player.current_health += 2
		"sup_3":
			# Regeneración se maneja en el script del jugador
			pass
		"sup_4":
			player.max_health += 3
			player.current_health += 3
			# Reducción de daño se maneja en el script del jugador
			pass

func save_upgrades():
	var save_data = {}
	for upgrade_id in upgrades.keys():
		save_data[upgrade_id] = upgrades[upgrade_id].unlocked
	
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		file.store_var(save_data)
		file.close()

func load_upgrades():
	if not FileAccess.file_exists(SAVE_FILE):
		return
	
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file:
		var save_data = file.get_var()
		file.close()
		
		for upgrade_id in save_data.keys():
			if upgrades.has(upgrade_id):
				upgrades[upgrade_id].unlocked = save_data[upgrade_id]

func reset_upgrades():
	for upgrade in upgrades.values():
		upgrade.unlocked = false
	save_upgrades()
