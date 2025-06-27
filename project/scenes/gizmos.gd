extends Node3D

func _hide():
	visible = false


func _ready() -> void:
	Global.nextLevel.connect(_hide)
	pass
	
