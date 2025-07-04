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
	
	var i = 0
	for narrvs in dialogos:
		narrativas.append(Narrative.new(label))
		var j = 0
		for blq in narrvs:
			var bloq = NarrativeBLock.new(blq["Text"],persons[blq["Person"]]["Sound"],Color(persons[blq["Person"]]["Color"]["R"],persons[blq["Person"]]["Color"]["G"],persons[blq["Person"]]["Color"]["B"],persons[blq["Person"]]["Color"]["A"]))
			if j % 2 == 0:
				bloq.set_font(load("res://assets/fonts/PPLettraMono-Medium.otf"))
			else:
				bloq.set_font(load("res://assets/fonts/PPModelPlastic-Medium.otf"))
			narrativas[i].add_block(bloq)
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
