extends Button

func _ready() -> void:
	pass

func _pressed() -> void:
	print("BOTON PULSADO");

	if (Global.stage == Global.maxStages):
		Global.change_scene(Global.Scenes.CREDITS);
		pass;
	
	# AQUÍ GESTION DE SI PASA AL SIGUIENTE SI ES SUFICIENTEMENTE ACERTADO
	else:
		Global.next_stage();
		Global.change_scene(Global.Scenes.GAME);

	# si no pues algun tipo de efecto 
	# ...
	pass
