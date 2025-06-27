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
		Global.contarHistoria.emit(4)	
	else:
		get_parent().apagar_y_encender()
		Global.next_stage();
		#Global.change_scene(Global.Scenes.GAME);
