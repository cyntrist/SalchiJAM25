extends Camera3D
@onready var imm = ImmediateMesh.new()
@onready var mesh_inst = MeshInstance3D.new()
@onready var raycast = $RayCast3D # su raycast

func  _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_viewport().get_mouse_position()
		var origin = self.project_ray_origin(mouse_pos)
		var direction = self.project_ray_normal(mouse_pos)
		var to = origin + direction * 1000  # largo del rayo
		raycast.target_position = to
		raycast.force_raycast_update()
		if raycast.is_colliding():
			print("Hit", raycast.get_collider().name)
			raycast.get_collider().get_parent().select_bone(true)
