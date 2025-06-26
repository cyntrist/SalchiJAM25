extends Scene

var elapsedTime: float = 0
var maxTime: float = 1
var aumentado: bool = false
@onready var control: Control = $Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if elapsedTime<= maxTime:
		# control.scale =  Vector2((1+elapsedTime)/10,(1+elapsedTime)/10)
		elapsedTime += delta
	elif not aumentado:
		Global.change_scene(Global.Scenes.MAIN_MENU)
		aumentado = true	


func on_enable():
	pass

func on_disable():
	aumentado = false;
	elapsedTime = 0;
	maxTime = 3;
	pass
