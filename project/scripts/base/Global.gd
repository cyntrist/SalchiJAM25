extends Node
# SEÑALES
# flujo
signal on_transition_begin(speed)
signal on_transition_end
signal on_enable(scene)
signal on_disable(scene)
signal on_game_end()
# juego
signal nextLevel
signal on_candle_lit
signal on_candle_unlit()
signal contarHistoria(index) # señal para avanzar de sombra
signal checkLevel()
signal capturaToCompare
signal selectBone
signal unSelectBone
const SOL_1 = "res://assets/images/soluciones/Sol1.png"
const SOL_2 = "res://assets/images/soluciones/Sol2.png"
const SOL_3 = "res://assets/images/soluciones/Sol3.png"
const SOL_4 = "res://assets/images/soluciones/Sol4.png"
var Soluciones = [SOL_1, SOL_2, SOL_3, SOL_4]
enum Sombras { sombra1, sombra2, sombra3 }

enum Scenes { SPLASH, MAIN_MENU, INTRO, GAME, CREDITS, NULL}

var gms
var current_scene = Scenes.SPLASH 
var next_scene = Scenes.SPLASH
var stage = 1
var maxStages = 4;
var trasladarBrazo = false

var coolDown = 0.5
var startCoolDown = false
var random = RandomNumberGenerator.new()

func _ready() -> void:
	# change_scene(Scenes.SPLASH)
	pass

func  _process(delta: float) -> void:
	pass
	if startCoolDown:
		if coolDown <= 0:
			startCoolDown = false
			coolDown = 0.5
		else:
			coolDown-= delta

func next_stage():
	Global.stage += 1
	Global.stage = clamp(Global.stage, 1, maxStages)
	
var nivelCorrecto = false
func _sombra_terminada(currentHistoria: int)->void:
	if nivelCorrecto:
		#nextLevel.emit()
		nivelCorrecto = false

func change_scene(next : Global.Scenes, speed = 1.0, force = true):
	Global.next_scene = next
	#print(">> Changing from ", Global.current_scene, " to ", Global.next_scene)
	if ((current_scene != next || force)and not startCoolDown):
		startCoolDown = true
		Global.on_transition_begin.emit(speed)
