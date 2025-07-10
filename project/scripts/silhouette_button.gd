extends Button

func _ready() -> void:
	Global.nextLevel.connect(_next_stage)
	pass

func _pressed() -> void:
	#print("BOTON PULSADO");
	SoundSystem.play_sfx("res://assets/audio/sfx/papel.wav")
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
	var target = $"../Node3D/Camera/next".rotation + Vector3(0,deg_to_rad(-3),0)
	tween.tween_property($"../Node3D/Camera/next", "rotation", target, 0.1)

func _on_button_confirm_mouse_exited():
	var tween = create_tween()
	var target = $"../Node3D/Camera/next".rotation + Vector3(0,deg_to_rad(3),0)
	tween.tween_property($"../Node3D/Camera/next",  "rotation", target, 0.1)

func _on_pressed():
	var tween = create_tween()
	tween.tween_property($"../Node3D/Camera/next", "scale", Vector3(0.5,0.5, 0.5), 0.1)
	tween.tween_property($"../Node3D/Camera/next", "scale", Vector3(0.6,0.6,0.6), 0.1)
