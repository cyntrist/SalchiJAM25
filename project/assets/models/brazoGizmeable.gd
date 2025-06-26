extends Gizmeable

var giro = true

func  _input(event: InputEvent) -> void:
	if not selected:
		return
	
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_Q or event.keycode == KEY_E:
			giro = not giro
		
		if giro:
			match event.keycode:
				KEY_RIGHT:
					rotate_object_local(Vector3(0,1,0), velocity)
				KEY_LEFT:
					rotate_object_local(Vector3(0,1,0), -velocity)
		else:
			match event.keycode:
				KEY_UP:
					global_position += Vector3(0,1,0) * velocity
				KEY_DOWN:
					global_position += Vector3(0,1,0) * -velocity
				KEY_RIGHT:
					global_position += Vector3(1,0,0) * velocity
				KEY_LEFT:
					global_position += Vector3(1,0,0) * -velocity

func set_axis_vis(n):
	gizmos.get_child(2).visible = true
