extends Node3D

@export var manos : Array[Node3D]

func _ready() -> void:	
	Global.nextLevel.connect(next_stage)

func reset_pos():
	for m in manos:
		m.reset_pos()
@onready var sprite_3d: Sprite3D = $Sprite3D

func  _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		match event.keycode:
			KEY_1:
				manos[0].select()
				manos[1].un_select()
			KEY_2:
				manos[0].un_select()
				manos[1].select()

func next_stage():
	sprite_3d.texture = load(Global.Soluciones[Global.stage])
