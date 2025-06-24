extends Scene

@export var bg_color : Color = Color.BLACK
@export var to_scene : PackedScene = null
@export var title_color := Color.GOLD
@export var text_color := Color.WHITE
@export var title_font : FontFile = null
@export var text_font : FontFile = null
@export var Music : AudioStream = null
@export var Use_Video_Audio : bool = false
@export var Video : VideoStream = null
@onready var final_icon = $Icon
var final_icon_en_mitad = false;

const section_time := 2.0
const line_time := 0.3
const base_speed := 100
const speed_up_multiplier := 10.0

var scroll_speed : float = base_speed
var speed_up := false

#@onready var colorrect := $ColorRect
@onready var videoplayer := $VideoPlayer
@onready var line := $CreditsContainer/Line
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits = [
	[
		"SALCHIJAM25"
	], [
		"EQUIPO",
		"Nieves Alonso Gilsanz",
		"Andrés García Navarro",
		"Cynthia Tristán Álvarez"
	], [
		"AGRADECIMIENTOS ESPECIALES",
		"Rocío Sánchez"
	], [
		"y a ti :^]"
	]
	#],[
		#"tetitas",
		#"tetazas", 
		#"tetazas", 
		#"tetorras", 
		#"tetotas",
		#"tetarracas",
		#"tetacas",
		#"tetuzas",
		#"teturras",
		#"tetungas",
		#"tetillas",
		#"bufas",
		#"bufarras",
		#"bufarracas",
		#"bufoncias",
		#"bakugans",
		#"mamelungas",
		#"mamelones",
		#"melones",
		#"domingas",
		#"bubalongas",
		#"babungas",
		#"pechugas",
		#"peras",
		#"peritas",
		#"perolas",
		#"mamellas",
		#"tetolas",
		#"gemelas"
	#]
]

func start():
	#colorrect.color = bg_color
	videoplayer.set_stream(Video)
	if !Use_Video_Audio:
		var stream = AudioStreamPlayer.new()
		stream.set_stream(Music)
		add_child(stream)
		videoplayer.set_volume_db(-80)
		stream.play()
	else:
		videoplayer.set_volume_db(0)
	videoplayer.play()
	

func _process(delta):
	scroll_speed = base_speed * delta
	
	if section_next:
		section_timer += delta * speed_up_multiplier if speed_up else delta
		if section_timer >= section_time:
			section_timer -= section_time
			
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	
	else:
		line_timer += delta * speed_up_multiplier if speed_up else delta
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	if speed_up:
		scroll_speed *= speed_up_multiplier
	
	if final_icon.position.y <= 300:
		final_icon_en_mitad = true
	
	if (!final_icon_en_mitad):
		final_icon.set_global_position(final_icon.get_global_position() - Vector2(0, scroll_speed))	

	if lines.size() > 0:
		for l in lines:
			l.set_global_position(l.get_global_position() - Vector2(0, scroll_speed))
			if l.get_global_position().y < -500-l.get_line_height():
				lines.erase(l)
				l.queue_free()
	elif started:
		finish()


func finish():
	if not finished:
		finished = true
		if to_scene != null:
			var path = to_scene.get_path()
			get_tree().change_scene_to_file(path)
		else:
			#var tween = create_tween()
			#tween.tween_property(final_icon, "position.y", -100, 2)
			await get_tree().create_timer(6.5).timeout
			get_tree().quit()


func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)
	if curr_line == 0:
		if title_font != null:
			new_line.set("theme_override_fonts/font", title_font)
		new_line.set("theme_override_colors/font_color", title_color)
	
	else:
		if text_font != null:
			new_line.set("theme_override_fonts/font", text_font)
		new_line.set("theme_override_colors/font_color", text_color)
	
	$CreditsContainer.add_child(new_line)
	
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		finish()
	if event.is_action_pressed("ui_down") and !event.is_echo():
		speed_up = true
	if event.is_action_released("ui_down") and !event.is_echo():
		speed_up = false

func on_enable():
	# Global.bgm0.stream = load("res://assets/music/credits.mp3")
	# Global.bgm0.play()
	#var tween = create_tween()
	#tween.tween_property(final_icon, "position:y", 100, 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	pass
