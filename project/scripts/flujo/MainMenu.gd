extends Scene

@export var camera_scene :Camera3D

var soundCoger = "res://assets/audio/sfx/coger.wav"


func on_enable():
	self.visible = true;
	$Node3D/titulo/AnimationPlayer.play("titulo|tituloAction")
	$Node3D.visible = true;
	camera_scene.make_current()

func on_disable():
	self.visible = false;
	$Node3D.visible = false;
	$Node3D/WorldEnvironment/SpotLight3D.visible = false
	$Node3D/WorldEnvironment/SpotLight3D.light_energy = 0.0
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false;
	$Node3D.visible = false;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_salir_pressed() -> void:
	get_tree().quit()
	pass

func _on_jugar_pressed() -> void:
	SoundSystem.play_sfx(soundCoger)
	$Node3D/Camera/Play/AnimationPlayer.play("Caja|CajaAction")
	$Node3D/Camera/Play/Caja/compartimento/AnimationPlayer.play("Compartimento|CompartimentoAction")
	await $Node3D/Camera/Play/AnimationPlayer.animation_finished
	print("CAMBIO DE ESCEASD")
	Global.change_scene(Global.Scenes.GAME)
	pass

# idiomas
func _show_lenguages()-> void:
	SoundSystem.play_sfx(soundCoger)
	#v_box_container.visible = not v_box_container.visible 
	#$VBoxContainer/Lenguages/Label.text = JsonData.json_data.UI.Lenguage
	#$VBoxContainer/Exit/Label.text = JsonData.json_data.UI.Exit

func _set_ingles()->void:
	SoundSystem.play_sfx(soundCoger)
	JsonParser._load_lenguage("res://jsons/eng.json")
	_show_lenguages()

func _set_espaniol()->void:
	SoundSystem.play_sfx(soundCoger)
	JsonParser._load_lenguage("res://jsons/esp.json")
	_show_lenguages()
