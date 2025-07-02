extends Node

@export var loopChannels : Array[AudioStreamPlayer2D]
@export var sfxChannels : Array[AudioStreamPlayer2D]

## Aniade un canal de audio.
## [code]channel[/code]: (AudioStreamPlayer2D) que se agregara.
## [code]isloop[/code]: (bool) si debe reproducirse en bucle.
func add_channel(channel:AudioStreamPlayer2D, isloop = false):
	if isloop:
		loopChannels.append(channel)
	else:
		sfxChannels.append(channel)

## Reproduce un audio en loop
## [code]path[/code]: (String) ruta a la pista de audio.
## [code]channel[/code]: (int) canal por el que se debe reproducir.
func play_loop(path:="", channel := int(-1)):
	_play_on_channel(loopChannels, path, channel)

## Reproduce un audio
## [code]path[/code]: (String) ruta a la pista de audio.
## [code]channel[/code]: (int) canal por el que se debe reproducir.
func play_sfx(path:="", channel := int(-1)):
	_play_on_channel(sfxChannels, path, channel)

## METODO PRIVADO NO USAR.
func _play_on_channel(list:Array, path:="", channel:= int(-1)):
	# Si no hay audio o no hay canales return
	if path == "" or len(list) <= 0:
		print("PATH: ", path, " lEN: ", len(list))
		return
	# Si no hay canales seleccionados, busca uno libre
	var freeChannel = list[0]
	if channel <= -1 or channel >= len(list):
		if channel >= len(list):
			printerr("No existe el canal de loop seleccionado, se escogera uno libre")
		for c in list:
			channel +=1
			if not c.playing:
				freeChannel = c
				continue
		# Si no hay ningun canal disponible se queda con el primero
	else:
		freeChannel = list[channel]
	
	print("Reproduciendo: ", path, " en: ", channel)
	
	freeChannel.stream = load(path)
	freeChannel.play()

## Para todos los sonidos.
func stop_all():
	stop_all_sfx()
	stop_all_loop()

## Para todos los sfx.
func stop_all_sfx():
	for i in len(sfxChannels):
		stop_sfx_channel(i)

## Para todos los sonidos en loop.
func stop_all_loop():
	for i in len(loopChannels):
		stop_loop_channel(i)

## Para un canal de sfx.
## [code]channel[/code]: (int) numero de canal >=0 .
func stop_sfx_channel(channel := int(-1)) -> bool:
	if channel >= -1 or len(sfxChannels) <= 0:
		return false
	sfxChannels[channel].stop()
	return true

## Para un canal de loop.
## [code]channel[/code]: (int) numero de canal >=0 .
func stop_loop_channel(channel := int(-1)) -> bool:
	if channel >= -1 or len(loopChannels) <= 0:
		return false
	loopChannels[channel].stop()
	return true
