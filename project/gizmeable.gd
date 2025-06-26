extends Node3D
class_name Gizmeable

@onready var gizmos: Node3D = $gizmos
var selected = false
var velocity: float = 0.05
var axis: Vector3 = Vector3(1,0,0)
var startRot: Vector3
var startPos: Vector3

func _ready() -> void:
	gizmos.visible = false
	startRot = rotation
	startPos = position

func  _input(event: InputEvent) -> void:
	if not selected:
		return
	
	if event is InputEventKey and event.is_pressed():
		match event.keycode:
			KEY_D:
				rotate_object_local(axis, -velocity)
			KEY_A:
				rotate_object_local(axis, velocity)
			KEY_Q:
				match axis:
					Vector3(1,0,0):
						axis = Vector3(0,1,0)
						set_axis_vis(0)
					Vector3(0,1,0):
						axis = Vector3(0,0,1)
						set_axis_vis(2)
					Vector3(0,0,1):
						axis = Vector3(1,0,0)
						set_axis_vis(1)
			KEY_E:
				match axis:
					Vector3(1,0,0):
						axis = Vector3(0,0,1)
						set_axis_vis(2)
					Vector3(0,1,0):
						axis = Vector3(1,0,0)
						set_axis_vis(1)
					Vector3(0,0,1):
						axis = Vector3(0,1,0)
						set_axis_vis(0)
			KEY_R:
				reset_pos()

func set_axis_vis(n):
	for c in gizmos.get_children():
		c.visible = false	
	gizmos.get_child(n).visible = true

func select_bone():
	print("COLL")
	gizmos.visible = true
	selected = true
	match  axis:
		Vector3(1,0,0):
			set_axis_vis(1)
		Vector3(0,1,0):
			set_axis_vis(0)
		Vector3(0,0,1):
			set_axis_vis(2)

func reset_select():
	print("Reset")
	gizmos.visible = false
	selected = false

func reset_pos():
	rotation = startRot
	position = startPos
