extends Control

@onready var label: Label = $Button/Label

var narrativas : Array[Narrative]
var actualNarrative := 0

var textDisplayed: float = 0 # contador para que se escriba letra a letra

func _ready() -> void:
	generate_narrative()

func _process(delta: float) -> void:
	if textDisplayed < 1:
		textDisplayed += delta 
		label.visible_ratio = textDisplayed

func generate_narrative() -> void:
	var persons = JsonParser.json_data["Persons"]
	var dialogos = JsonParser.json_data["Dialogues"]
	
	var characters: Array[NarrativeCharacter]
	for p in persons:
		var character = NarrativeCharacter.new(Color(p["Color"]["R"],p["Color"]["G"], p["Color"]["B"]))
		# Recorrer cada emoción y sus sonidos
		for emo_name in p["Sound"].keys():
			var emo_enum = NarrativeCharacter.Emotion[emo_name.to_upper()]
			var paths = p["Sound"][emo_name]
			if paths is Array:
				character.sounds[emo_enum] = paths.duplicate()
		characters.append(character)
	
	
	var i = 0
	for narrvs in dialogos:
		narrativas.append(Narrative.new(label))
		var j = 0
		for blq in narrvs:
			var bloq = NarrativeBLock.new(characters[blq["Person"]], NarrativeCharacter.Emotion[blq["Emotion"].to_upper()], blq["Text"])
			if j % 2 == 0:
				characters[blq["Person"]].set_font(load("res://assets/fonts/PPLettraMono-Medium.otf"))
			else:
				characters[blq["Person"]].set_font(load("res://assets/fonts/PPModelPlastic-Medium.otf"))
			narrativas[i].add_block(bloq)
			j+=1
		narrativas[i].restart_block_begin()
		i += 1

func next_dialogue() -> void:
	if narrativas[actualNarrative].is_end():
		actualNarrative += 1
		return
	narrativas[actualNarrative].advance_block()
	textDisplayed = 0


func _on_button_mouse_entered():
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", -0.5, 0.1)
	tween.tween_property(self, "rotation_degrees", 0, 0.1)
