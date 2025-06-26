extends Scene

@onready var andres = $AndresScene
@onready var debugnivel = $DebugNivel
@onready var luz = $AndresScene/WorldEnvironment/DirectionalLight3D

func on_enable():
	luz.light_energy = 0.0;
	await get_tree().create_timer(1).timeout
	debugnivel.text = "Nivel: " + str((Global.stage))
	encender()
	pass

func on_disable():
	luz.light_energy = 0.0;
	pass

func encender():
	var tween = create_tween()
	tween.tween_property(luz, "light_energy", 1.0, 0.5)
	pass
	
func apagar():
	var tween = create_tween()
	tween.tween_property(luz, "light_energy", 0.0, 0.5)
	pass
	
func apagar_y_endender():
	print_debug("cjones")
	apagar()
	await get_tree().create_timer(1).timeout
	encender()
