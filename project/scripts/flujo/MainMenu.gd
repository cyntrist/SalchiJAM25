extends Scene


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
	Global.change_scene(Global.Scenes.INTRO)
	pass
