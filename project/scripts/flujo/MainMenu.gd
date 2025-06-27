extends Scene

var soundCoger = load("res://assets/audio/sfx/coger.wav")

func on_enable():
	self.visible = true;
	$Node3D.visible = true;

func on_disable():
	self.visible = false;
	$Node3D.visible = false;
	$Node3D/WorldEnvironment/SpotLight3D.visible = false
	$Node3D/WorldEnvironment/SpotLight3D.light_energy = 0.0
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_salir_pressed() -> void:
	get_tree().quit()
	pass

func _on_jugar_pressed() -> void:
	Global.sfx.stream = soundCoger
	Global.sfx.play()
	$Node3D/Play/AnimationPlayer.play("Caja|CajaAction")
	$Node3D/Play/Caja/compartimento/AnimationPlayer.play("Compartimento|CompartimentoAction")
	await $Node3D/Play/AnimationPlayer.animation_finished
	print("CAMBIO DE ESCEASD")
	Global.change_scene(Global.Scenes.GAME)
	pass
