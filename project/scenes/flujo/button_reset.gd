extends Button

func _on_button_reset_mouse_entered():
	var tween = create_tween()
	var targrot = $"../AndresScene/reset".rotation + Vector3(0,deg_to_rad(3),0)
	tween.tween_property($"../AndresScene/reset", "rotation", targrot, 0.1)

func _on_button_reset_mouse_exited():
	var tween = create_tween()
	var targrot = $"../AndresScene/reset".rotation + Vector3(0,deg_to_rad(-3),0)
	tween.tween_property($"../AndresScene/reset", "rotation", targrot, 0.1)

func _on_pressed():
	Global.sfx.stream = load("res://assets/audio/sfx/papel.wav")
	Global.sfx.play()
	var tween = create_tween()
	tween.tween_property($"../AndresScene/reset", "scale", Vector3(0.5,0.5, 0.5), 0.1)
	tween.tween_property($"../AndresScene/reset", "scale", Vector3(0.6,0.6,0.6), 0.1)
