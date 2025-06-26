extends Camera3D
@onready var camaraVP = get_parent().get_parent() # la camara que esta en el viewport real
@onready var raycast = camaraVP.get_child(0) # su raycast
@onready var viewport = camaraVP.get_child(1);

@onready var imm = ImmediateMesh.new()
@onready var mesh_inst = MeshInstance3D.new()
#capturas

func _ready():
	mesh_inst.mesh = imm
	add_child(mesh_inst)
	
	Global.capturaToCompare.connect(_screenshot)
	var dir = DirAccess.open("user://")
	dir.make_dir("screenshots")
	
	viewport.world_3d = get_world_3d()
	self.current = true;
	
	#var img2 = "user://screenshots/userTry"+str(Global.stage)+".png".get_file()
	#dir = DirAccess.open("user://screenshots")
	
func _screenshot():
	print("CAPTURA")
	
	await RenderingServer.frame_post_draw #accede al frame despues de dibujarlo
	var vpImg = viewport.get_texture().get_image() #imagen del viewport
	
	# imagen a comparar, prueba del jugador
	# guarda en \AppData\Roaming\sombras\screenshots
	vpImg.save_png("user://screenshots/userTry"+str(Global.stage)+".png")
	Global.checkLevel.emit(); # comprobar la resolucion 
