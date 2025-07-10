extends Node3D


@export var listBones: Array[Node3D]
@onready var m_ano: MeshInstance3D = $Armature/Skeleton3D/MAno

var selected = false
var boneActual: int = 0
var interactuable := false

func _ready() -> void:
	select()
	Global.startTalking.connect(set_no_interactuable)
	Global.stopTalking.connect(set_interactuable)


func set_no_interactuable() -> void: 
		interactuable = false
		print("NO ES INTERACTUABLE")

func set_interactuable() -> void: 
		interactuable = true
		print("ES INTERACTUABLE")

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
		e.unselect_bone()

func  _process(delta: float) -> void:
	if not selected or not interactuable:
		return
		
	
	if(Input.is_action_just_pressed("Reset"):
		selected = not selected
	
	#if event is InputEventMouseButton and event.pressed:
	#	match event.button_index:
	#		MOUSE_BUTTON_WHEEL_UP:
	#			if boneActual != 0 or (boneActual == 0 and !Global.trasladarBrazo):
	#				listBones[boneActual].unselect_bone()
	#				boneActual += 1
	#				if boneActual >= listBones.size():
	#					boneActual = 0
	#				listBones[boneActual].select_bone()
	#				
	#		MOUSE_BUTTON_WHEEL_DOWN:
	#			if boneActual != 0 or (boneActual == 0 and !Global.trasladarBrazo):
	#				listBones[boneActual].unselect_bone()
	#				boneActual -= 1
	#				if boneActual < 0:
	#					boneActual = listBones.size() - 1
	#				listBones[boneActual].select_bone()
