extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.on_transition_begin.connect(transition)
	pass


func transition():
	#print("DENTRO FADE IN")
	$AnimationPlayer.play("fade_in")
	# Global.gms.sfx.stream = load("res://Sounds/fade/683096__florianreichelt__woosh.mp3")
	# Global.gms.sfx.play()



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		#print("FUERA FADE IN")
		Global.on_transition_end.emit()
		$AnimationPlayer.play("fade_out")
	#elif anim_name == "fade_out":
		#print("FUERA FADE OUT")
		
