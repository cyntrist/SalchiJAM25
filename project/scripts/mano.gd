extends Node3D


@export var listBones: Array[Node3D]
@onready var m_ano: MeshInstance3D = $Armature/Skeleton3D/MAno
var selected = false
var boneActual: int = 0

func reset_pos():
	for b in listBones:
		b.reset_pos()

func select():
	selected = true
	m_ano.scale = Vector3(1.05,1.05,1.05)
	
	listBones[boneActual].select_bone()

func un_select():
	selected = false
	m_ano.scale = Vector3(1,1,1)
	for e in listBones:
		e.reset_select()

func  _input(event: InputEvent) -> void:
	if not selected:
		return
	
	if event is InputEventKey and event.is_pressed():
		match event.keycode:
			KEY_W:
				if (boneActual != 0 || boneActual == 0 && !Global.trasladarBrazo):
					listBones[boneActual].reset_select()
					boneActual +=1
					if boneActual >= len(listBones):
						boneActual = 0
					listBones[boneActual].select_bone()
			KEY_S:
				if (boneActual != 0 || boneActual == 0 && !Global.trasladarBrazo):
					listBones[boneActual].reset_select()
					boneActual -=1
					if boneActual < 0:
						boneActual = len(listBones)-1
					listBones[boneActual].select_bone()
