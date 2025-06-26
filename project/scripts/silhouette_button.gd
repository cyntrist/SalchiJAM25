extends Button

func _ready() -> void:
	pass

func _pressed() -> void:
	print("BOTON PULSADO");

	Global.next_stage();
	Global.checkLevel.emit();
	#Global.change_scene(Global.Scenes.GAME);

	if (Global.stage == Global.maxStages):
		Global.change_scene(Global.Scenes.CREDITS, 0.5);
		pass;
	
	# AQUÍ GESTION DE SI PASA AL SIGUIENTE SI ES SUFICIENTEMENTE ACERTADO
	else:
		Global.next_stage();
		Global.change_scene(Global.Scenes.GAME);

	# si no pues algun tipo de efecto 
	# ...
	pass
