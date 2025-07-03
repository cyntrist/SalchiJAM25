extends Node

@export var label: Label = null
var dialogues: Array[Dialogue]
var actualDialogue: int = -1

func _ready() -> void:
	if not label:
		label = $Button/Label

func add_dialogue(dialogue:Dialogue = null) ->bool:
	if not dialogue:
		return false	
	dialogues.append(dialogue)
	return true

func advance_dialogue() -> String:
	var dialogue = dialogues[actualDialogue]
	if actualDialogue >= len(dialogues):
		return ""
	else:
		actualDialogue += 1
	return dialogue.reproduce()

func retreat_dialogue() -> String:
	var dialogue = dialogues[actualDialogue]
	if actualDialogue >= len(dialogues):
		return ""
	else:
		actualDialogue += 1
	return dialogue.reproduce()

func restart_dialogue() -> String:
	return ""
