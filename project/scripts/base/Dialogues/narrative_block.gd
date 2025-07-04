extends RefCounted
class_name NarrativeBLock

var callbacks : Array[Callable]
var condition_continue: Callable = Callable()
var text := ""
var sound := ""
var color := Color.BLACK
var font : Font
var soundChannel := -1

## Constructora
## [code]txt[code] (String) texto a mostrar
## [code]snd[code] (String) ruta al sonido
func _init(txt := "",snd := "", clr:= Color.BLACK ) -> void:
	text = txt
	sound = snd
	color = clr

## Cambia el texto a mostrar
## [code]txt[code] (String) texto a mostrar
func set_text(txt:= "") -> void:
	text = txt

## Cambia el sonido que queremos que se reproduzca
## [code]snd[code] (String) ruta al sonido
## [code]channel[code] (int) canal por el que quieres que salga, se asigna automaticamente
func set_sound(snd:= "", channel:= -1) -> void:
	sound = snd
	soundChannel = channel

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
	label.add_theme_font_override("font", font)
	label.add_theme_color_override("font_color", color)

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
	SoundSystem.play_sfx(sound, soundChannel)
	return text
