extends Scene

@onready var andres = $AndresScene
@onready var debugnivel = $DebugNivel

func on_enable():
	debugnivel.text = "Nivel: " + str((Global.stage + 1))
	pass

func on_disable():
	pass
