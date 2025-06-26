extends Node3D


@export var listBones: Array[Node3D]
@onready var mesh: MeshInstance3D = $Armature/Skeleton3D/Circle
var selected = false
var boneActual: int = 0

func select():
	selected = true
	mesh.scale = Vector3(1.05,1.05,1.05)
	listBones[boneActual].select_bone()

func un_select():
	selected = false
	mesh.scale = Vector3(1,1,1)
	for e in listBones:
		e.reset_select()

func  _input(event: InputEvent) -> void:
	if not selected:
		return
	
	if event is InputEventKey and event.is_pressed():
		match event.keycode:
			KEY_A:
				listBones[boneActual].reset_select()
				boneActual +=1
				if boneActual >= len(listBones):
					boneActual = 0
				listBones[boneActual].select_bone()
			KEY_D:
				listBones[boneActual].reset_select()
				boneActual -=1
				if boneActual < 0:
					boneActual = len(listBones)-1
				listBones[boneActual].select_bone()
