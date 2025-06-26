extends Node3D

var rotating = false
var isSelected = false

var antPosCursor # anterior
var sigPosCursor # siguiente

func _process(delta):
	if(Input.is_action_just_pressed("Rotate")):
		#print("HOLA")
		rotating = true
		antPosCursor = get_viewport().get_mouse_position()
	if(Input.is_action_just_released("Rotate")):
		rotating = false
		isSelected = false

	if(rotating and isSelected):
		sigPosCursor = get_viewport().get_mouse_position()
		rotate3D(Vector3(1,0,0), (sigPosCursor.y - antPosCursor.y) * .1 * delta)
		rotate3D(Vector3(0,1,0), (sigPosCursor.x - antPosCursor.x) * .1 * delta)
		rotate3D(Vector3(0,0,-1), (sigPosCursor.y - antPosCursor.y) * .1 * delta)
		antPosCursor = sigPosCursor

func rotate3D(axis:Vector3, angle):
	match axis:
		Vector3(1,0,0):
			rotate_x(angle)
		Vector3(0,1,0):
			rotate_y(angle)
		Vector3(0,0,1):
			rotate_z(angle)

func select_bone(selected):
	isSelected = selected
