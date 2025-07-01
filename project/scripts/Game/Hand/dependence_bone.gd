extends Node3D

@export var boneParent: Node3D = null
@export var multiplex: float = 1.1
var startParRot: Vector3
var startRot: Vector3

func _ready() -> void:
	startRot = rotation
	if boneParent:
		startParRot = boneParent.rotation
func _process(delta: float) -> void:
	if boneParent:
		rotation = startRot + ((boneParent.rotation - startParRot) * multiplex)
