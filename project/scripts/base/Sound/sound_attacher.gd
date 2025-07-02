extends Node
@onready var loops: Node = $loops
@onready var sfx: Node = $SFX

func _ready() -> void:
	for c in loops.get_children():
		SoundSystem.add_channel(c,true)
	for c in sfx.get_children():
		SoundSystem.add_channel(c)
