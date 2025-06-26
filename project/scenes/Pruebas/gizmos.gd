extends Node3D

func _ready() -> void:
	Global.selectBone.connect(select_giz)
	

func select_giz(obj:Node3D):
	
	for c in get_children():
		if c != obj:
			c.get_child(0).get_child(0).disabled = true
		else:
			c.get_child(0).get_child(0).disabled = false
