extends Node3D

@export var camera: Camera3D
@export var sensivility:= Vector2(0.5, 0.5)
@export var maxRot:= Vector2(180, 180)
@export var minRot:= Vector2(-180, -180)
const DEAD_ZONE = 10.0  

var startRot: Vector3

var rotating = false
var isSelected = false
var interactuable := false

var antPosCursor # anterior
var sigPosCursor # siguiente

func _ready() -> void:
	startRot = rotation
	camera = get_viewport().get_camera_3d()
	Global.startTalking.connect(Callable(func() -> void: interactuable = false))
	Global.stopTalking.connect(Callable(func() -> void: interactuable = true))

func _process(delta):
	if not interactuable or not isSelected:
		return
	
	if(Input.is_action_just_pressed("Reset") and isSelected):
		reset_pos()
	if(Input.is_action_just_pressed("Rotate")):
		rotating = true
		antPosCursor = get_viewport().get_mouse_position()
	if(Input.is_action_just_released("Rotate")):
		rotating = false
	
	
	if rotating:
		#print("HOLA")
		sigPosCursor = get_viewport().get_mouse_position()
		var axisX := Vector3(1,0,0)
		if rotation_degrees.x > 180:
			axisX *= -1
		var axisZ := Vector3(0,0,1)
		if rotation_degrees.z > 180:
			axisZ *= -1
		
		# Desplazamiento en eje y
		var deltaY = sigPosCursor.y - antPosCursor.y
		# Aplicar rotacion si supera la zona muerta
		if abs(deltaY) > DEAD_ZONE:
			rotate_relative_to_camera(axisX, deltaY * sensivility.x * delta)
	
		# Desplazamiento en x
		var deltaX = sigPosCursor.x - antPosCursor.x
		# Aplicar rotacion si supera la zona muerta
		if abs(deltaX) > DEAD_ZONE:
			rotate_relative_to_camera(axisZ, deltaX * sensivility.y * delta)
			
		antPosCursor = sigPosCursor


func rotate_relative_to_camera(axis: Vector3, angle: float):
	var cameraAxis
	var targetAngle
	
	if axis == Vector3(1, 0, 0):
		cameraAxis = camera.global_transform.basis.x.normalized()
		targetAngle = clamp(rotation_degrees.x + angle, minRot.x, maxRot.x)
		rotation_degrees.x = targetAngle
	else:
		cameraAxis = camera.global_transform.basis.z.normalized()
		targetAngle = clamp(rotation_degrees.z + (angle/2), minRot.y, maxRot.y)
		rotation_degrees.z = targetAngle
	
	global_rotate(cameraAxis, angle)

func reset_pos() -> void:
	rotation = startRot

func select_bone():
	scale = scale + Vector3(0.1,0.1,0.1)
	isSelected = true
	print("BONE SELECCIONADO", name)

func unselect_bone():
	print("RESET")
	isSelected = false
	scale = scale - Vector3(0.1,0.1,0.1)
