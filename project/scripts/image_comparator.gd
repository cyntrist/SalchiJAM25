extends Node

func _ready() -> void:
	var image = Image.load_from_file("res://icon.svg")
	var similitude = comparate(image, image)
	print(similitude * 100, "%")

func comparate(img1: Image, img2: Image) -> float:
	var imgSize = img1.get_size()
	var newImage := img1
	var equalPixels = 0
	newImage.resize(imgSize.x, imgSize.y)
	for i in range(imgSize.x):
		for j in range(imgSize.y):
			if img1.get_pixel(i,j) == img2.get_pixel(i,j):
				equalPixels += 1
	return equalPixels / (imgSize.x * imgSize.y)
