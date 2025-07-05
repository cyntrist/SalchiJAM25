extends RefCounted
class_name NarrativeBLock

var callbacks : Array[Callable]
var condition_continue: Callable = Callable()
var text := ""
var soundChannel := -1
var character : NarrativeCharacter
var emotion : NarrativeCharacter.Emotion

## Constructora
## [code]txt[code] (String) texto a mostrar
## [code]snd[code] (String) ruta al sonido
func _init(chr : NarrativeCharacter, emt := NarrativeCharacter.Emotion.NEUTRAL, txt := "") -> void:
	emotion = emt
	character = chr
	text = txt

## Cambia el texto a mostrar
## [code]txt[code] (String) texto a mostrar
func set_text(txt:= "") -> void:
	text = txt

## Cambia el canal de reproduccion del sonido
## [code]channel[code] (int) canal por el que quieres que salga, se asigna automaticamente
func set_sound_channel(channel:= -1) -> void:
	soundChannel = channel

## Aniade un callback que se ejecutara al reproducir
## [code]call[code] (Callable) metodo
func add_callable(call:Callable) -> void:
	if call:
		callbacks.append(call)

## Aniade un callback condicion para continuar al siguiente dialogo
## [code]call[code] (Callable) metodo
func add_condition(call:Callable) -> void:
	if call.is_valid():
		condition_continue = call

## Configura la label segun el hablante
func configure_label(label: Label) ->void:
	label.add_theme_font_override("font", character.font)
	label.add_theme_color_override("font_color", character.color)

## Coprueba si puede pasar al siguiente dialogo
## [code]return[code] (bool)
func can_continue() -> bool:
	if not condition_continue.is_valid():
		return true
	
	return condition_continue.call()

## Devuelve el texto y ejecuta los callbacks y el sonido del dialogo
func reproduce() -> String:
	for c in callbacks:
		c.call()
	SoundSystem.play_sfx(character.get_sound(emotion), soundChannel)
	return text
