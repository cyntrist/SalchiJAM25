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
	# Global.to_transition.connect(_on_totransition)
	Global.on_transition_end.connect(_on_fade_end)
	Global.on_game_end.connect(_on_game_end)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("1"):
		Global.change_scene(Global.Scenes.SPLASH)
	if event.is_action_pressed("2"):
		Global.change_scene(Global.Scenes.MAIN_MENU)
	if event.is_action_pressed("3"):
		Global.change_scene(Global.Scenes.INTRO)
	if event.is_action_pressed("4"):
		Global.change_scene(Global.Scenes.GAME)
	if event.is_action_pressed("5"):
		Global.change_scene(Global.Scenes.CREDITS)
	if event.is_action_pressed("6"):
		Global.change_scene(Global.Scenes.NULL)
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

# func _change_to_scene(newScene: scenes):
# 	if current_scente != next_scene:
# 		current_scente = next_scene

func add_bgm_channel():
	Global.bgm[Global.CurrentEdad].volume_db = 0.0
	pass

func _on_game_end():
	Global.change_scene(Global.Scenes.CREDITS)

func _on_transition() -> void: #fade in
	fade.transition()

func _on_fade_end() -> void: #justo antes del fadeout, la idea es que esto sea un switch
	#if Global.current_scene == Global.to_scene:
		 #pass
	# escena a apagar
	scenes[Global.current_scene].visible = false
	scenes[Global.current_scene].on_disable()
	scenes[Global.current_scene].process_mode = Node.PROCESS_MODE_DISABLED

	# escena a encender
	# print("next: ", Global.next_scene, " ", scenes[Global.next_scene])
	scenes[Global.next_scene].visible = true
	scenes[Global.next_scene].on_enable()
	scenes[Global.next_scene].process_mode = Node.PROCESS_MODE_INHERIT

	Global.current_scene = Global.next_scene	
