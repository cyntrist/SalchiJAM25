extends Node3D
@onready var gizmos: Node3D = $gizmos
var selected = false
var velocity: float = 0.1

func _ready() -> void:
	gizmos.visible = false

func  _input(event: InputEvent) -> void:
	if not selected:
		return
	
	if event is InputEventKey and event.is_pressed():
		match event.keycode:
			KEY_UP:
				rotate(Vector3(1,0,0), velocity)
			KEY_LEFT:
				rotate(Vector3(0,0,1), velocity)
			KEY_DOWN:
				rotate(Vector3(1,0,0), -velocity)
			KEY_RIGHT:
				rotate(Vector3(0,0,1), -velocity)

func select_bone():
	print("COLL")
	gizmos.visible = true
	selected = true

func reset_select():
	print("Reset")
	gizmos.visible = false
	selected = false
