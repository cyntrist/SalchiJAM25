extends Node3D


@export var listBones: Array[Node3D]
@onready var m_ano: MeshInstance3D = $Armature/Skeleton3D/MAno
var selected = false
var boneActual: int = 0

func _ready() -> void:
	select()

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
		
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				if boneActual != 0 or (boneActual == 0 and !Global.trasladarBrazo):
					listBones[boneActual].reset_select()
					boneActual += 1
					if boneActual >= listBones.size():
						boneActual = 0
					listBones[boneActual].select_bone()
					
			MOUSE_BUTTON_WHEEL_DOWN:
				if boneActual != 0 or (boneActual == 0 and !Global.trasladarBrazo):
					listBones[boneActual].reset_select()
					boneActual -= 1
					if boneActual < 0:
						boneActual = listBones.size() - 1
					listBones[boneActual].select_bone()
