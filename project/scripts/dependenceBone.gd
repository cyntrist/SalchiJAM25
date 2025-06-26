extends Node3D
@export var boneParent: Node3D = null


func _process(delta: float) -> void:
	if boneParent:
		rotation = (boneParent.rotation - boneParent.startRot) * 5
