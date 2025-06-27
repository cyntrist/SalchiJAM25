extends Scene

@onready var andres = $AndresScene
@onready var debugnivel = $DebugNivel
#@onready var luz = $AndresScene/WorldEnvironment/DirectionalLight3D
@onready var luz = $AndresScene/WorldEnvironment/SpotLight3D
@onready var dialogue = $DialogueBox
#@export var initial_value : float = 1.5
@export var initial_value : float = 7.0

var soundEncender = load("res://assets/audio/sfx/encender.wav")
var soundApagar = load("res://assets/audio/sfx/apagar.wav")
var soundApagar2 = load("res://assets/audio/sfx/apagar_2.wav")

func on_enable():
	Global.bgm1.play()
	Global.bgm2.play()
	andres.visible = true;
	luz.light_energy = 0.0;
	dialogue.modulate = Color.TRANSPARENT;
	var tween = create_tween()
	tween.tween_property(dialogue, "modulate", Color.WHITE, 0.5)
	pass

func on_disable():
	Global.bgm1.stop()
	Global.bgm2.stop()
	Global.bgm3.stop()
	luz.light_energy = 0.0;
	dialogue.modulate = Color.TRANSPARENT;
	pass

func encender_cojones(speed = 1.0):
	var tween = create_tween()
	tween.tween_property(luz, "light_energy", initial_value, speed)
	Global.sfx.stream = soundEncender
	Global.sfx.play()
	Global.bgm3.play()
	pass;

func apagar_cojones(speed = 0.5):
	var tween = create_tween()
	tween.tween_property(luz, "light_energy", 0.0, speed)
	Global.sfx.stream = soundApagar
	Global.sfx.play()
	pass;

func encender(speed = 1.0):
	var tween = create_tween()
	tween.tween_property(luz, "light_energy", initial_value, speed)
	debugnivel.text = "Nivel: " + str((Global.stage))
	tween.finished.connect(func(): 
		andres.reset_pos() 
		Global.on_candle_lit.emit()
		)
	Global.sfx.stream = soundEncender
	Global.sfx.play()
	Global.bgm3.play()
	pass
	
func apagar(speed = 0.5):
	var tween = create_tween()
	tween.tween_property(luz, "light_energy", 0.0, speed)
	Global.on_candle_unlit.emit()
	andres.hide_hint()
	tween.finished.connect(func(): 
		andres.reset_pos() 
		)
	Global.sfx.stream = soundApagar2
	Global.sfx.play()
	Global.bgm3.stop()
	pass
	
func apagar_y_encender(speed = 1.0):
	apagar(speed)
	await get_tree().create_timer(1).timeout
	andres.reset_pos();
	encender(speed)
