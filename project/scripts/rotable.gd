extends Node3D

@export var maxRotation: Vector3 = Vector3(360,360,360)
@export var minRotation: Vector3 = Vector3(0,0,0)
@export var angleRot: float = 5

#@onready var gizmoInstance:Node3D = $Gizmo3D

var rotating = false
var isSelected = false

var antPosCursor # anterior
var sigPosCursor # siguiente

func _ready() -> void:
	#add_child(gizmoInstance)
	#gizmoInstance.visible = false
	Global.selectBone.connect(select_bone)
	Global.unSelectBone.connect(reset)

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
		rotate3D(Vector3(1,0,0), (sigPosCursor.y - antPosCursor.y) * angleRot * delta)
		rotate3D(Vector3(0,1,0), (sigPosCursor.x - antPosCursor.x) * angleRot * delta)
		rotate3D(Vector3(0,0,1), (sigPosCursor.y - antPosCursor.y) * angleRot * delta)
		antPosCursor = sigPosCursor

func rotate3D(axis: Vector3, angle: float):
	match axis:
		Vector3(1,0,0):
			if rotation.x + angle > minRotation.x and rotation.x + angle < maxRotation.x:
				rotate_x(angle)
		Vector3(0,1,0):
			if rotation.y + angle > minRotation.y and rotation.y + angle < maxRotation.y:
				rotate_y(angle)
		Vector3(0,0,1):
			if rotation.z + angle > minRotation.z and rotation.z + angle < maxRotation.z:
				rotate_z(angle)

func select_bone(bone):
	if bone == self.get_parent() :
		print("BONE SELECCIONADO", name)
		#gizmoInstance.visible = true
	else:
		self.visible = false
		#gizmoInstance.visible = false

func reset():
	print("RESET")
	#gizmoInstance.visible = false
	self.visible = true
