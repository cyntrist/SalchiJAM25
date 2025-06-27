extends Scene

func on_disable():
	self.visible = false;
	$Node3D/WorldEnvironment/SpotLight3D.visible = false
	$Node3D/WorldEnvironment/SpotLight3D.energy = 0.0
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
	$Node3D/Play/AnimationPlayer.play("Caja|CajaAction")
	$Node3D/Play/Caja/compartimento/AnimationPlayer.play("Compartimento|CompartimentoAction")
	await $Node3D/Play/AnimationPlayer.animation_finished
	print("CAMBIO DE ESCEASD")
	Global.change_scene(Global.Scenes.GAME)
	pass
