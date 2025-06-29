extends Camera3D

func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var origin = project_ray_origin(mouse_pos)
	var direction = project_ray_normal(mouse_pos)
	var to = origin + direction * 1000
	var plane = Plane(Vector3.BACK, $"../CSGBox3D2".global_position.z)
	var ray_direction = (to - origin).normalized()
	var point = plane.intersects_ray(origin, ray_direction)
	if point != null:
		$"../WorldEnvironment/SpotLight3D".set_objetive_pos(point)
