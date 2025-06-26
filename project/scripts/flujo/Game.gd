extends Scene

@onready var andres = $AndresScene
@onready var debugnivel = $DebugNivel
#@onready var luz = $AndresScene/WorldEnvironment/DirectionalLight3D
@onready var luz = $AndresScene/WorldEnvironment/SpotLight3D
#@export var initial_value : float = 1.5
@export var initial_value : float = 7.0

func on_enable():
	luz.light_energy = 0.0;
	await get_tree().create_timer(1).timeout
	encender()
	pass

func on_disable():
	luz.light_energy = 0.0;
	pass

func encender():
	var tween = create_tween()
	tween.tween_property(luz, "light_energy", initial_value, 0.5)
	debugnivel.text = "Nivel: " + str((Global.stage))
	pass
	
func apagar():
	var tween = create_tween()
	tween.tween_property(luz, "light_energy", 0.0, 0.5)
	pass
	
func apagar_y_encender():
	print_debug("cjones")
	apagar()
	await get_tree().create_timer(1).timeout
	andres.reset_pos();
	encender()
