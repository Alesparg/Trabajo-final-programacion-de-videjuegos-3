extends Node

const SAVE_FILE_PATH = "user://savegame.cfg"

var save_data = {
	"has_save": false,
	"current_level": 1,
	"score": 0,
	"deaths": 0
}

func save_game(level: int, score: int, deaths: int):
	save_data["has_save"] = true
	save_data["current_level"] = level
	save_data["score"] = score
	save_data["deaths"] = deaths
	
	var config = ConfigFile.new()
	config.set_value("game", "has_save", true)
	config.set_value("game", "current_level", level)
	config.set_value("game", "score", score)
	config.set_value("game", "deaths", deaths)
	
	var error = config.save(SAVE_FILE_PATH)
	if error != OK:
		print("Error al guardar: ", error)

func load_game():
	var config = ConfigFile.new()
	var error = config.load(SAVE_FILE_PATH)
	
	if error != OK:
		print("No hay partida guardada")
		return null
	
	save_data["has_save"] = config.get_value("game", "has_save", false)
	save_data["current_level"] = config.get_value("game", "current_level", 1)
	save_data["score"] = config.get_value("game", "score", 0)
	save_data["deaths"] = config.get_value("game", "deaths", 0)
	
	return save_data

func has_save():
	var config = ConfigFile.new()
	var error = config.load(SAVE_FILE_PATH)
	
	if error != OK:
		return false
	
	return config.get_value("game", "has_save", false)

func delete_save():
	var config = ConfigFile.new()
	var error = config.load(SAVE_FILE_PATH)
	
	if error == OK:
		DirAccess.remove_absolute(SAVE_FILE_PATH)
	
	save_data["has_save"] = false
	save_data["current_level"] = 1
	save_data["score"] = 0
	save_data["deaths"] = 0

func get_current_level():
	if has_save():
		var data = load_game()
		return data["current_level"]
	return 1
