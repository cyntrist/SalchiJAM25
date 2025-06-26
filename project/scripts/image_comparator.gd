extends Node

func comparate(img1: Image, img2: Image) -> float:
	return 0

func to_black_white(img: Image) -> Image:
	var imgSize = img.get_size()
	var newImage := img
	newImage.resize(imgSize.x, imgSize.y)
	for i in range(img.get_size().x):
		for j in range(img.get_size().y):
			pass
	return newImage
