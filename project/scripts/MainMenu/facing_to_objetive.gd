extends Node3D

var objetivePos:= Vector3(0,0,0)

func set_objetive_pos(pos):
	objetivePos = pos

func _process(delta):
	look_at(objetivePos)
