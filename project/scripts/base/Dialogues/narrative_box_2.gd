extends Control

@onready var label: Label = $Button/Label

var narrativas : Array[Narrative]
var actualNarrative := 0

var textDisplayed: float = 0 # contador para que se escriba letra a letra

func _ready() -> void:
	generate_narrative()
	print(actualNarrative)
	if narrativas[0]:
		narrativas[0].restart_block_begin()
	Global.nextLevel.connect(next_narrative)

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
		characters.push_back(character)
	
	var i = 0
	for narrvs in dialogos:
		narrativas.push_back(Narrative.new(label))
		var j = 0
		for blq in narrvs:
			var bloq = NarrativeBLock.new(characters[blq["Person"]], NarrativeCharacter.Emotion[blq["Emotion"].to_upper()], blq["Text"])
			characters[blq["Person"]].set_font(load("res://assets/fonts/PPLettraMono-Medium.otf"))
			if "@" in blq["Text"]:
				#bloq.add_callable(Callable(self, "next_narrative"))
				bloq.add_callable(Callable(get_parent().get_child(0), "show_hint"))
				bloq.add_callable(Callable(start_input))
				
			narrativas[i].add_block(bloq)
			j += 1
		i += 1
	
	narrativas[0].get_last_block().add_callable(Callable(get_parent(),"encender_cojones"))
	narrativas[0].get_last_block().add_callable(Callable(self, "start_story"))
	
	#narrativas[1].get_last_block().add_callable(Callable(self, "next_narrative"))
	for n in range(2,len(narrativas)):
		narrativas[n].get_first_block().add_callable(Callable(get_parent().get_child(0), "hide_hint"))
		narrativas[n].get_first_block().add_callable(Callable(stop_input))

### METODOS BOTONES

func next_dialogue() -> void:
	narrativas[actualNarrative].advance_block()
	textDisplayed = 0
	if narrativas[actualNarrative].is_end():
		self.visible = false
		return

func _on_button_mouse_entered():
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", -0.5, 0.1)
	tween.tween_property(self, "rotation_degrees", 0, 0.1)

### METODOS CALLBACKS
func stop_input():
	Global.startTalking.emit()
	print("STOP INPUT")

func start_input():
	Global.stopTalking.emit()
	print("START INPUT")

## Empieza la historia despues de la intro
func start_story() -> void:
	await get_tree().create_timer(2.0).timeout
	actualNarrative = 1
	label.text = ""
	next_dialogue()
	self.visible = true

func next_narrative() -> void:
	await get_tree().create_timer(2.0).timeout
	actualNarrative += 1
	label.text = ""
	next_dialogue()
	self.visible = true

func set_continue_when_level_reaches(tgt: int, bloq: NarrativeBLock) -> void:
	var condition_func = func() -> bool:
		return bloq.continue_
	bloq.continue_ = false
	Global.contarHistoria.connect(func(new_level: int) -> void:
		if new_level == tgt:
			bloq.continue_ = true
	)
