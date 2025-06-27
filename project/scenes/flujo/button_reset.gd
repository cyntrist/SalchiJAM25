extends Button

func _on_button_reset_mouse_entered():
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 2, 0.1)


func _on_button_reset_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 0, 0.1)

func _on_pressed():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.97,0.97), 0.1)
	tween.tween_property(self, "scale", Vector2(1,1), 0.1)
