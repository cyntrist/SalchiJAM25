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
		
func _on_button_confirm_mouse_entered():
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", -2, 0.1)

func _on_button_confirm_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 0, 0.1)

func _on_pressed():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.97,0.97), 0.1)
	tween.tween_property(self, "scale", Vector2(1,1), 0.1)
