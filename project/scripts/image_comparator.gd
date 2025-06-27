extends Node

func _ready() -> void:
	Global.checkLevel.connect(comparate)

func comparate() -> float:
	print("COMPARAR")
	var img1 = Image.load_from_file(Global.Soluciones[Global.stage-1])
	var img2 = Image.load_from_file("user://screenshots/userTry"+str(Global.stage)+".png")

	var imgSize = img1.get_size()
	var equalPixels = 0
	for i in range(imgSize.x):
		for j in range(imgSize.y):
			if img1.get_pixel(i,j) == img2.get_pixel(i,j):
				equalPixels += 1
	print(equalPixels, "/", imgSize.x * imgSize.y)
	var similitud := (float(equalPixels) / float(imgSize.x * imgSize.y))
	print(similitud * 100, "%")
	
	# comprueba si es correcta la respuesta
	if similitud * 100 >= 70:
		Global.nivelCorrecto = true
		#Global.contarHistoria.emit(1)
		Global.nextLevel.emit()
		
	return similitud
