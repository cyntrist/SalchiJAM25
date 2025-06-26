extends Button

func _ready() -> void:
	pass

func _pressed() -> void:
	print("BOTON PULSADO");
	Global.next_stage();
	Global.change_scene(Global.Scenes.GAME);
	pass
