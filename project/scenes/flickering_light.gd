extends SpotLight3D


var original_position: Vector3
var shake_strength := 0.05         
var shake_interval := 0.2          
var shake_timer := 0.0

var current_offset := Vector3.ZERO  
var target_offset := Vector3.ZERO  

var smoothing_speed := 7.0          

func _ready():
	original_position = global_position

func _process(delta):
	shake_timer -= delta
	if shake_timer <= 0.0:
		target_offset = Vector3(
			randf_range(-1, 1),
			randf_range(-1, 1),
			randf_range(-1, 1)
		).normalized() * shake_strength
		shake_timer = shake_interval

	current_offset = current_offset.lerp(target_offset, delta * smoothing_speed)
	global_position = original_position + current_offset
