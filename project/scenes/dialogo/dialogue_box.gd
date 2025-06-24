extends Control

@onready var button: Button = $Button
@onready var label: Label = $Button/Label

var textDisplayed: float = 0 # contador para que se escriba letra a letra
var dialogueID: int = 0 # ID del dialogo en el que estamos
var dialogueTextID: int = 0 # ID texto del dialogo mostrado
var ultimaHistoria: int = -1 # guarda la ultima historia contada (nivel)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	Global.contarHistoria.connect(_start_quest)
	Global.nextLevel.connect(_next_level)
	label.text = ""

func _process(delta: float) -> void:
	if textDisplayed < 1:
		textDisplayed += delta 
		label.visible_ratio = textDisplayed

func _next_dialogue():
	# completa el texto si no lo ha hecho
	if textDisplayed >= 1:
		textDisplayed = 0
	else:
		textDisplayed = 1
		label.visible_ratio = textDisplayed
	
	# Comprueba si ha acabado el dialogo
	if dialogueTextID >= JsonParser.json_data.Dialoges[dialogueID].Texts.size() :
		_end_dialogue()
		print("FIN DEL DIALOGO")
		return
	else:
		#if JsonParser.dialogos[dialogueID].Texts[dialogueTextID].Person == 0:
			#audio_stream.pitch_scale = sound1
			#label.add_theme_color_override("font_color", color1)
		#else:
			#audio_stream.pitch_scale = sound2
			#label.add_theme_color_override("font_color", color2)
		
		#audio_stream.play()
		
		if "@" in JsonParser.dialogos[dialogueID].Texts[dialogueTextID].Text:
			label.text = JsonParser.dialogos[dialogueID].Texts[dialogueTextID].Text.replace('@', '')
		else:
			label.text = JsonParser.dialogos[dialogueID].Texts[dialogueTextID].Text
			dialogueTextID += 1
	
func _start_quest(idText: int):
	if idText == ultimaHistoria:
		return
	
	dialogueTextID = 0
	textDisplayed = 0
	
	#hace visible el cuadro de dialogo
	self.visible = true
	dialogueID = idText
	
	#asigna las diferentes propiedades
	var rng = RandomNumberGenerator.new() 
	#sound1 = rng.randf_range(0.5, 2.5)
	#sound2 = rng.randf_range(0.5, 2.5)
	#audio_stream.stream = sound
	
	#color1 = Color(JsonData.dialogos[dialogueID].Color1.R,JsonData.dialogos[dialogueID].Color1.G,JsonData.dialogos[dialogueID].Color1.B, 1)
	#color2 = Color(JsonData.dialogos[dialogueID].Color2.R,JsonData.dialogos[dialogueID].Color2.G,JsonData.dialogos[dialogueID].Color2.B, 1)
	
	if Global.nivelCorrecto:
		_start_dialogue()
		return
		
	print("START HISTORIA")
	_next_dialogue()

func _start_dialogue() -> void:
	self.visible = true
	textDisplayed = 0
	_avanzar_hasta_quest()
	_next_dialogue()

func _end_dialogue():
	ultimaHistoria = dialogueID
	self.visible = false
	Global._llamada_terminada(dialogueID)

func _avanzar_hasta_quest()->void:
	dialogueTextID = 0
	while not "@" in JsonParser.dialogos[dialogueID].Texts[dialogueTextID].Text:
		dialogueTextID += 1
	dialogueTextID += 1

func _next_level()->void:
	self.visible = false
