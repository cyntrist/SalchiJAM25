extends Node3D


@export var listBones: Array[Node3D]
var selected = false
var boneActual: int = 0

func select(sel):
	selected = sel

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
