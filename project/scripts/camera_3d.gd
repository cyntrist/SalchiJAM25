extends Camera3D

@onready var raycast = $RayCast3D
var isDragging = false;
var dragged_object: Node3D = null
var drag_offset: Vector3 = Vector3.ZERO

func _ready() -> void:
	pass

func  _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_pos = get_viewport().get_mouse_position()
		var origin = self.project_ray_origin(mouse_pos)
		var direction = self.project_ray_normal(mouse_pos)
		var to = origin + direction * 1000  # largo del rayo
		raycast.target_position = to
		raycast.force_raycast_update()
	
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if raycast.is_colliding():
				var collider = raycast.get_collider()
				if (collider is Node3D):
					isDragging = true;
					dragged_object = collider.get_parent()
					var collision_point = raycast.get_collision_point()
					#drag_offset = dragged_object.global_position - collision_point
					#print_debug("Objecto", dragged_object)
					#print_debug("Hit", raycast.get_collider().name)
		
		elif not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			isDragging = false;
			dragged_object = null
			
func _process(_delta: float) -> void:
	if dragged_object && isDragging:
		var mouse_pos = get_viewport().get_mouse_position()
		var origin = project_ray_origin(mouse_pos)
		var direction = project_ray_normal(mouse_pos)
		var to = origin + direction * 1000

		var plane = Plane(Vector3.BACK, dragged_object.global_position.z)
		var ray_direction = (to - origin).normalized()
		var point = plane.intersects_ray(origin, ray_direction)

		if point != null:
			var new_pos = point + drag_offset
			new_pos.z = dragged_object.global_position.z 
			dragged_object.global_position = new_pos
