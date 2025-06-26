extends Camera3D
@onready var imm = ImmediateMesh.new()
@onready var mesh_inst = MeshInstance3D.new()

#capturas

func _ready():
	mesh_inst.mesh = imm
	add_child(mesh_inst)
	
	Global.checkLevel.connect(_screenshot)
	var dir = DirAccess.open("user://")
	dir.make_dir("screenshots")
	
	var ssCount = 0
	dir = DirAccess.open("user://screenshots")
	for n in dir.get_files():
		ssCount += 1
	
	print("capturas: " + str(ssCount))
	
func _screenshot():
	print("CAPTURA")
	
	await RenderingServer.frame_post_draw #accede al frame despues de dibujarlo
	
	var viewport = get_viewport()
	var vpImg = viewport.get_texture().get_image() #imagen del viewport
	
	#imagen a comparar, prueba del jugador
	vpImg.save_png("user://screenshots/userTry"+str(Global.stage)+".png")

func  _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_viewport().get_mouse_position()
		var origin = self.project_ray_origin(mouse_pos)
		var direction = self.project_ray_normal(mouse_pos)
		var to = origin + direction * 1000  # largo del rayo
		$RayCast3D.target_position = to
		$RayCast3D.force_raycast_update()
		if $RayCast3D.is_colliding():
			print("Hit", $RayCast3D.get_collider().name)
			$RayCast3D.get_collider().get_parent().select_bone(true)
