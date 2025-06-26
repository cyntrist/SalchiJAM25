extends Button

func _ready() -> void:
	Global.nextLevel.connect(_next_stage)
	pass

func _pressed() -> void:
	print("BOTON PULSADO");
	Global.capturaToCompare.emit(); # captura para comparar
	pass

func _next_stage():
	print_debug("2123123213")
	if (Global.stage == Global.maxStages):
		Global.change_scene(Global.Scenes.CREDITS, 0.25);
		pass;
	else:
		print_debug("cojojojo")
		get_parent().apagar_y_encender()
		Global.next_stage();
		#Global.change_scene(Global.Scenes.GAME);
