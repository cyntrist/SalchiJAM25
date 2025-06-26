extends Gizmeable

var giro = true

func  _input(event: InputEvent) -> void:
	if not selected:
		return
	
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_Q or event.keycode == KEY_E:
			giro = not giro
			Global.trasladarBrazo = not giro;
		if event.keycode == KEY_R:
				reset_pos()
		if giro: # girar
			match event.keycode:
				KEY_D:
					rotate_object_local(Vector3(0,1,0), velocity)
				KEY_A:
					rotate_object_local(Vector3(0,1,0), -velocity)
		else: # trasladar
			match event.keycode:
				KEY_W:
					global_position += Vector3(0,1,0) * velocity
				KEY_S:
					global_position += Vector3(0,1,0) * -velocity
				KEY_D:
					global_position += Vector3(1,0,0) * velocity
				KEY_A:
					global_position += Vector3(1,0,0) * -velocity

func set_axis_vis(n):
	gizmos.get_child(2).visible = true
