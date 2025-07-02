extends Scene

@onready var andres = $AndresScene
@onready var debugnivel = $DebugNivel
#@onready var luz = $AndresScene/WorldEnvironment/DirectionalLight3D
@onready var luz = $AndresScene/WorldEnvironment/SpotLight3D
@onready var dialogue = $DialogueBox
#@export var initial_value : float = 1.5
@export var initial_value : float = 7.0

var soundEncender = "res://assets/audio/sfx/encender.wav"
var soundApagar = "res://assets/audio/sfx/apagar.wav"
var soundApagar2 = "res://assets/audio/sfx/apagar_2.wav"

func on_enable():
	SoundSystem.play_loop("res://assets/audio/ambient/wind.wav", 0)
	SoundSystem.play_loop("res://assets/audio/ambient/crickets.wav", 1)
	andres.visible = true;
	luz.light_energy = 0.0;
	dialogue.modulate = Color.TRANSPARENT;
	var tween = create_tween()
	tween.tween_property(dialogue, "modulate", Color.WHITE, 0.5)
	pass

func on_disable():
	SoundSystem.stop_all_loop()
	luz.light_energy = 0.0;
	dialogue.modulate = Color.TRANSPARENT;
	pass

func encender_cojones(speed = 1.0):
	var tween = create_tween()
	tween.tween_property(luz, "light_energy", initial_value, speed)
	SoundSystem.play_sfx(soundEncender)
	SoundSystem.play_loop("res://assets/audio/ambient/flickering.wav", 2)
	pass;

func apagar_cojones(speed = 0.5):
	var tween = create_tween()
	tween.tween_property(luz, "light_energy", 0.0, speed)
	SoundSystem.play_sfx(soundApagar)
	pass;

func encender(speed = 1.0):
	var tween = create_tween()
	tween.tween_property(luz, "light_energy", initial_value, speed)
	debugnivel.text = "Nivel: " + str((Global.stage))
	tween.finished.connect(func(): 
		andres.reset_pos() 
		Global.on_candle_lit.emit()
		)
	SoundSystem.play_sfx(soundEncender)
	SoundSystem.play_loop("res://assets/audio/ambient/flickering.wav", 2)
	pass
	
func apagar(speed = 0.5):
	var tween = create_tween()
	tween.tween_property(luz, "light_energy", 0.0, speed)
	Global.on_candle_unlit.emit()
	andres.hide_hint()
	tween.finished.connect(func(): 
		andres.reset_pos() 
		)
	SoundSystem.play_sfx(soundApagar2)
	SoundSystem.stop_loop_channel(2)
	pass
	
func apagar_y_encender(speed = 1.0):
	apagar(speed)
	await get_tree().create_timer(1).timeout
	andres.reset_pos();
	encender(speed)
