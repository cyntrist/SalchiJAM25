extends RefCounted
class_name NarrativeCharacter

enum Emotion {NEUTRAL, HAPPY, SAD, ANGRY}
var sounds: Dictionary[Emotion,Array]
var color := Color.BLACK
var font : Font

func _init(clr:= Color.BLACK ) -> void:
	color = clr

## Cambia el color del bloque de texto
## [code]clr[code] (Color) nuevo color del bloque de texto
func set_color(clr:= Color.BLACK) -> void:
	color = clr


## Cambia la fuente del bloque de texto
## [code]fnt[code] (Font) nueva fuente del bloque de texto
func set_font(fnt: Font) -> void:
	if fnt == null:
		printerr("[NARRATIVE BLOCK ERROR] fuente asignada no valida.")
		return
	
	font = fnt

## Aniade un sonido y lo asigna a una emocion
## [code]snd[code] (String) sonido a asignar
## [code]emotion[code] (Emotion) emocion del sonido
func add_sound(snd: String, emotion := Emotion.NEUTRAL) -> void:
	# Si el sonido ya esta en el diccionario de sonidos no lo aniade
	if snd == "":
		printerr("[CHARACTER ERROR] El sonido a asignar no es valido")
		return
	if snd in sounds[emotion]:
		print("Sonido ya en el diccionario", emotion)
		return
	sounds[emotion].append(snd)

## Devuelve una ruta aleatoria de un sonido del personaje con la emocion indicada
## [code]emotion[code] (Emotion) emocion del sonido
func get_sound(emotion := Emotion.NEUTRAL) -> String:
	var sndArr := sounds[emotion]
	# Si el array esta vacio devuelve vacio
	if sndArr.is_empty():
		printerr("[CHARACTER ERROR] la emocion no tiene sonidos")
		return ""
	var idRand = randi_range(0,sndArr.size()-1)
	return sndArr[idRand]
