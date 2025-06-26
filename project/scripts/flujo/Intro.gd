extends Scene

@onready var label: Label = $Label
var timer = 0
var frames_per_letter = 4
var elapsedTime: float = 0
var maxTime: float = 8
var textDisplay: float = 0
var aumentado: bool = false
var text_ended = false
var clicked = false
var clicks = 0;
var stop = false
var transitioned = false
var mostrar_aviso = false
@onready var aviso = $Aviso
var counter = 0;
var tiempo = 2;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# ESTO ES PARA MOSTRAR AVISO EN MACHI MENTIBUS
	if mostrar_aviso:
		counter += delta
		if counter >= tiempo:
			mostrar_aviso = false
			counter = 0
			var tween = create_tween()
			tween.tween_property(aviso, "modulate", Color.TRANSPARENT, 0.5)
	
	# ESTO ES PARA ESCRIBIR EL TEXTO EN BURBUJARRONAS ETC
	# if stop:
	# 	label.visible_ratio =  1
	# 	text_ended = true
	# elif elapsedTime <= maxTime:
	# 	if textDisplay < 1:
	# 		if timer >= frames_per_letter:
	# 			timer = 0
	# 			label.visible_ratio = textDisplay
	# 			textDisplay += delta
	# 		else:
	# 			timer += 1
	# 	else:
	# 		label.visible_ratio =  1
	# 	elapsedTime += delta
	pass

func _input(event):
	# ESTO ES PARA MOSTRAR AVISO EN MACHI MENTIBUS
	if (event.is_action_pressed("1") || event.is_action_pressed("2") || event.is_action_pressed("3") || event.is_action_pressed("4") ||  event.is_action_pressed("5") ||  event.is_action_pressed("6")):
		pass
	elif (event is InputEventKey && event.pressed):
		if (!mostrar_aviso):
			mostrar_aviso = true
			var tween = create_tween()
			tween.tween_property(aviso, "modulate", Color.WHITE, 0.5)
		else:
			Global.change_scene(Global.Scenes.GAME)
			pass

	# ESTO ES PARA ESCRIBIR EL TEXTO EN BURBUJARRONAS ETC
	# if event.is_action_pressed("click"):
	# 	if label.visible_ratio == 1:
	# 		text_ended = true
	# 	if transitioned:
	# 		print(transitioned)
	# 		Global.change_scene(Global.Scenes.MAIN_MENU)
	# 	if !text_ended:
	# 		label.visible_ratio = 1
	# 		stop = true;
	# 		text_ended = true;
	# 	else:
	# 		if !clicked:
	# 			$AnimationPlayer.play("fadeout")
	# 			clicked = true
	pass
			

func on_enable():
	# label.text = tr("INTRODUCCION")
	# Global.sfx.stream= load("res://sonido/monologoIntroduccion.mp3")
	# Global.sfx.play()
	_reset_aviso()
	pass

func on_disable():
	_reset()
	_reset_aviso()
	pass

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	transitioned = true

func _reset():
	timer = 0
	frames_per_letter = 4
	elapsedTime = 0
	maxTime = 8
	textDisplay = 0
	aumentado = false
	text_ended = false
	clicked = false
	clicks = 0;
	stop = false
	transitioned = false

func _reset_aviso():
	_reset()
	mostrar_aviso = false
	counter = 0
	var tween = create_tween()
	tween.tween_property(aviso, "modulate", Color.TRANSPARENT, 0.01)
	pass

func _on_video_stream_player_finished() -> void:
	Global.change_scene(Global.Scenes.GAME)
