extends Control

#@onready var audio_stream: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var button: Button = $Button
@onready var label: Label = $Button/Label

#color de cada persona
var color1 : Color
var color2 : Color
var color3 : Color
#ruta del sonido de cada persona
#var sound = load("res://Sounds/voces/random.wav")
var sound1: float
var sound2: float
var sound3: float

var textDisplayed: float = 0 # contador para que se escriba letra a letra
var dialogueID: int = 0 # ID del dialogo en el que estamos
var dialogueTextID: int = 0 # ID texto del dialogo mostrado
var ultimaHistoria: int = -1 # guarda la ultima historia contada (nivel)
var juego_acabado = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start_quest(dialogueID)
	Global.contarHistoria.connect(_start_quest)
	#Global.nextLevel.connect(_next_level)
	Global.on_candle_lit.connect(_show)
	Global.on_candle_unlit.connect(_hide)
	label.text = ""

func _process(delta: float) -> void:
	if textDisplayed < 1:
		textDisplayed += delta 
		label.visible_ratio = textDisplayed

func _next_dialogue():
	if juego_acabado:
		Global.change_scene(Global.Scenes.CREDITS)
		return
	elif dialogueTextID == 11 and dialogueID == 4:
		juego_acabado = true;
		return;
	
	# completa el texto si no lo ha hecho
	if textDisplayed >= 1:
		textDisplayed = 0
	else:
		textDisplayed = 1
		label.visible_ratio = textDisplayed
	
	#print_debug(dialogueTextID)
	#print_debug(JsonParser.json_data.Dialoges[dialogueID].Texts.size())
	#
	
	
	### GESTIONES DE PUTA MIERDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	if dialogueTextID == 6 and dialogueID == 0:
		get_parent().encender_cojones();
	elif dialogueTextID == 11 and dialogueID == 0 or dialogueTextID == 5 and dialogueID == 1 or dialogueTextID == 7 and dialogueID == 2 or dialogueTextID == 6 and dialogueID == 3:
		get_parent().get_child(0).show_hint();
	elif dialogueTextID == 7 and dialogueID == 4:
		get_parent().apagar_cojones();
	#################################################################
	
	
	
	# Comprueba si ha acabado el dialogo
	if dialogueTextID >= JsonParser.json_data.Dialoges[dialogueID].Texts.size():
		print("FIN DEL DIALOGO")
		_end_dialogue()
		return
		
	else:
		var person = JsonParser.dialogos[dialogueID].Texts[dialogueTextID].Person
		#print(person)
		match person:
			0.0:
				#audio_stream.pitch_scale = sound1
				label.add_theme_color_override("font_color", color1)
			1.0:
				#audio_stream.pitch_scale = sound2
				label.add_theme_color_override("font_color", color2)
			2.0:
				#audio_stream.pitch_scale = sound3
				label.add_theme_color_override("font_color", color3)
			_:
				label.add_theme_color_override("font_color", (Color(1,0,0,1)))
		
		#audio_stream.play()
		
		if "@" in JsonParser.dialogos[dialogueID].Texts[dialogueTextID].Text:
			label.text = JsonParser.dialogos[dialogueID].Texts[dialogueTextID].Text.replace('@', '')
		else:
			label.text = JsonParser.dialogos[dialogueID].Texts[dialogueTextID].Text
			dialogueTextID +=1

func _start_quest(idText: int):
	#print("START PREHISTORIA ", idText)
	if idText == ultimaHistoria:
		print("hola")
		return
	
	dialogueTextID = 0
	textDisplayed = 0
	
	# hace visible el cuadro de dialogo
	self.visible = true
	dialogueID = idText
	
	#asigna las diferentes propiedades
	#var rng = RandomNumberGenerator.new() 
	#sound1 = rng.randf_range(0.5, 2.5)
	#sound2 = rng.randf_range(0.5, 2.5)
	#audio_stream.stream = sound
	
	color1 = Color(JsonParser.dialogos[dialogueID].Color1.R,JsonParser.dialogos[dialogueID].Color1.G,JsonParser.dialogos[dialogueID].Color1.B, 1)
	color2 = Color(JsonParser.dialogos[dialogueID].Color2.R,JsonParser.dialogos[dialogueID].Color2.G,JsonParser.dialogos[dialogueID].Color2.B, 1)
	color3 = Color(JsonParser.dialogos[dialogueID].Color3.R,JsonParser.dialogos[dialogueID].Color3.G,JsonParser.dialogos[dialogueID].Color3.B, 1)
	
	if Global.nivelCorrecto:
		_start_dialogue()
		return
	
	print("START HISTORIA")
	_next_dialogue()

func _start_dialogue() -> void:
	#self.visible = true
	textDisplayed = 0
	#_avanzar_hasta_quest()
	_next_dialogue()

func _end_dialogue():
	ultimaHistoria = dialogueID
	#self.visible = true
	Global._sombra_terminada(dialogueID)

func _avanzar_hasta_quest()->void:
	dialogueTextID = 0
	while not "@" in JsonParser.dialogos[dialogueID].Texts[dialogueTextID].Text:
		dialogueTextID += 1
	dialogueTextID += 1

func _next_level()->void:
	#self.visible = false
	dialogueID += 1 
	print_debug(Global.stage)
	Global.contarHistoria.emit(Global.stage-1)

func _hide():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	
func _show():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.5)
	_next_level()
