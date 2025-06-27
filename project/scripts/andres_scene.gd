extends Node3D

@export var manos : Array[Node3D]
@onready var sprite_3d: Sprite3D = $Sprite3D
@export var color = Color("ffffff46")

func _ready() -> void:	
	sprite_3d.modulate = Color.TRANSPARENT
	#Global.nextLevel.connect(next_stage)

func reset_pos():
	for m in manos:
		m.reset_pos()

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
	#print_debug(Global.stage)
	if (Global.stage <= Global.Soluciones.size()):
		sprite_3d.texture = load(Global.Soluciones[Global.stage - 1])

func show_hint():
	next_stage()
	if (sprite_3d.modulate != Color.WHITE):
		var tween = create_tween()
		tween.tween_property(sprite_3d, "modulate", color, 0.5)
	pass
	
func hide_hint():
	if (sprite_3d.modulate != Color.TRANSPARENT):
		var tween = create_tween()
		tween.tween_property(sprite_3d, "modulate", Color.TRANSPARENT, 0.5)
		tween.finished.connect(func(): next_stage())
	else:
		next_stage()
	pass
