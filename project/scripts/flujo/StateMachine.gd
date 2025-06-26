extends Node

@export var scenes: Array[Node] = [] 
@onready var fade = $Fade

@onready var bgm: AudioStreamPlayer2D = $Sound/BGM
@onready var sfx_1: AudioStreamPlayer2D = $Sound/SFX1
@onready var sfx_2: AudioStreamPlayer2D = $Sound/SFX2
@onready var sfx_3: AudioStreamPlayer2D = $Sound/SFX3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.gms = self
	Global.sfx = sfx_1
	Global.on_transition_end.connect(_on_fade_end)
	Global.on_game_end.connect(_on_game_end)
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	var scene = Global.Scenes.NULL;
	if event.is_action_pressed("1"):
		scene = Global.Scenes.SPLASH
	if event.is_action_pressed("2"):
		scene = Global.Scenes.MAIN_MENU
	if event.is_action_pressed("3"):
		scene = Global.Scenes.INTRO
	if event.is_action_pressed("4"):
		scene = Global.Scenes.GAME
	if event.is_action_pressed("5"):
		scene = Global.Scenes.CREDITS
	if event.is_action_pressed("6"):
		scene = Global.Scenes.NULL
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if (scene != Global.Scenes.NULL):
		Global.change_scene(scene)

func add_bgm_channel():
	Global.bgm[Global.CurrentEdad].volume_db = 0.0
	pass

func _on_game_end():
	Global.change_scene(Global.Scenes.CREDITS)

func _on_transition(speed = 1.0) -> void: #fade in
	fade.transition(speed)
	

func _on_fade_end() -> void: #justo antes del fadeout, la idea es que esto sea un switch
	# escena a apagar
	scenes[Global.current_scene].visible = false
	scenes[Global.current_scene].on_disable()
	scenes[Global.current_scene].process_mode = Node.PROCESS_MODE_DISABLED

	# escena a encender
	scenes[Global.next_scene].visible = true
	scenes[Global.next_scene].on_enable()
	scenes[Global.next_scene].process_mode = Node.PROCESS_MODE_INHERIT

	Global.current_scene = Global.next_scene	
	
