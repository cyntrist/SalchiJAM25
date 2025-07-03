extends RefCounted
class_name Dialogue

var callbacks : Array[Callable]
var condition_continue: Callable = Callable()
var text := ""
var sound := ""
var soundChannel := -1

## Constructora
## [code]txt[code] (String) texto a mostrar
## [code]snd[code] (String) ruta al sonido
func _init(txt := "",snd := "" ) -> void:
	text = txt
	sound = snd

## Cambia el texto a mostrar
## [code]txt[code] (String) texto a mostrar
func _set_text(txt:= "") -> void:
	text = txt

## Cambia el sonido que queremos que se reproduzca
## [code]snd[code] (String) ruta al sonido
## [code]channel[code] (int) canal por el que quieres que salga, se asigna automaticamente
func _set_sound(snd:= "", channel:= -1) -> void:
	sound = snd
	soundChannel = channel

## Aniade un callback que se ejecutara al reproducir
## [code]call[code] (Callable) metodo
func _add_callable(call:Callable) -> void:
	if call:
		callbacks.append(call)

## Devuelve el texto y ejecuta los callbacks y el sonido del dialogo
func _reproduce() -> String:
	for c in callbacks:
		c.call()
	SoundSystem.play_sfx(sound, soundChannel)
	return text
