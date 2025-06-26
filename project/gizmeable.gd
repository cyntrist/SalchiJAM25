extends Node3D
@onready var gizmos: Node3D = $gizmos
var selected = false
var velocity: float = 0.1
var axis: Vector3 = Vector3(1,0,0)

func _ready() -> void:
	gizmos.visible = false

func  _input(event: InputEvent) -> void:
	if not selected:
		return
	
	if event is InputEventKey and event.is_pressed():
		match event.keycode:
			KEY_UP:
				rotate_object_local(axis, velocity)
			KEY_DOWN:
				rotate_object_local(axis, -velocity)
			KEY_LEFT:
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
			KEY_RIGHT:
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
