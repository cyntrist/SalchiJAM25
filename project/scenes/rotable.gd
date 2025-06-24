extends CSGBox3D

var rotating = false

var antPosCursor # anterior
var sigPosCursor # siguiente

func _process(delta):
	
	if(Input.is_action_just_pressed("Rotate")):
		print("HOLA")
		rotating = true
		antPosCursor = get_viewport().get_mouse_position()
	if(Input.is_action_just_released("Rotate")):
		rotating = false

	if(rotating):
		sigPosCursor = get_viewport().get_mouse_position()
		rotate_x((sigPosCursor.y - antPosCursor.y) * .1 * delta)
		rotate_y((sigPosCursor.x - antPosCursor.x) * .1 * delta)
		rotate_z(-(sigPosCursor.y - antPosCursor.y) * .1 * delta)
		antPosCursor = sigPosCursor
	
	
