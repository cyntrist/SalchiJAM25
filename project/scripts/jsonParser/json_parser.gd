extends Node
# (hello...) Dialogos contienen: Sound1 = rute  || Sound2 = rute || Texts[] || Sound = 0/1 || text = ""
#
# Variable para almacenar los datos JSON cargados
var json_data = {}
var dialogos = []

func _ready():
	_load_lenguage("res://jsons/esp.json")

func _load_lenguage(root:String)->void:
	load_json_data(root)
	
# Función para cargar los datos JSON desde un archivo
func load_json_data(file_path: String) -> void:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if  file != null:
		var file_content = file.get_as_text()
		file.close()
		json_data = parse_json(file_content)
		dialogos = json_data["Dialoges"]

# Función para parsear el JSON
func parse_json(json_string: String) -> Dictionary:
	var json = JSON.new()
	var result = json.parse(json_string)
	if result == OK:
		var data = json.data
		if not typeof(data) == null:
			print("Done parseo") # Prints array
			return data
		else:
			print("Error al parsear JSON")
	return {}
