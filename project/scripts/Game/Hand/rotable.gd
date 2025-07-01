extends Node3D

@export var maxRotation: Vector3 = Vector3(360,360,360)
@export var minRotation: Vector3 = Vector3(0,0,0)
@export var camera: Camera3D
@export var angleRot: float = 0.5

var startRot: Vector3

var rotating = false
var isSelected = false

var antPosCursor # anterior
var sigPosCursor # siguiente

func _ready() -> void:
	#add_child(gizmoInstance)
	Global.selectBone.connect(select_bone)
	Global.unSelectBone.connect(reset_select)
	startRot = rotation

func _process(delta):
	if(Input.is_action_just_pressed("Reset") and isSelected):
		rotation = startRot
	if(Input.is_action_just_pressed("Rotate")):
		rotating = true
		antPosCursor = get_viewport().get_mouse_position()
	if(Input.is_action_just_released("Rotate")):
		rotating = false

	if(rotating and isSelected):
		#print("HOLA")
		sigPosCursor = get_viewport().get_mouse_position()
		var axisX := Vector3(1,0,0)
		if rotation_degrees.x > 180:
			axisX *= -1
		var axisZ := Vector3(0,0,1)
		if rotation_degrees.z > 180:
			axisZ *= -1
		rotate_relative_to_camera(axisX, (sigPosCursor.y - antPosCursor.y) * angleRot * delta)
		rotate_relative_to_camera(axisZ, (sigPosCursor.x - antPosCursor.x) * angleRot * delta)
		antPosCursor = sigPosCursor


func rotate_relative_to_camera(axis: Vector3, angle: float):
	var cameraAxis
	
	if axis == Vector3(1,0,0):
		cameraAxis = -camera.global_transform.basis.x.normalized()
	else:
		cameraAxis = camera.global_transform.basis.z.normalized()
	
	global_rotate(cameraAxis, angle)

func select_bone():
	scale = scale + Vector3(0.1,0.1,0.1)
	isSelected = true
	print("BONE SELECCIONADO", name)

func reset_select():
	print("RESET")
	isSelected = false
	scale = scale - Vector3(0.1,0.1,0.1)
