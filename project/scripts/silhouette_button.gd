extends Button

func _ready() -> void:
	Global.nextLevel.connect(_next_stage)
	pass

func _pressed() -> void:
	#print("BOTON PULSADO");
	Global.capturaToCompare.emit(); # captura para comparar
	pass

func _next_stage():
	if (Global.stage == Global.maxStages):
		Global.change_scene(Global.Scenes.CREDITS, 0.25);
		pass;
	else:
		Global.next_stage();
		Global.change_scene(Global.Scenes.GAME);
	pass;
