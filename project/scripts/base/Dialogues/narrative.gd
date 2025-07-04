extends Node
class_name Narrative
var narrativeBlqs: Array[NarrativeBLock]
var actualblock: int = 0
var label : Label

func _init(lbl:Label) -> void:
	if lbl:
		label = lbl

## Aniade un dialogo 
func add_block(NarrtBlq:NarrativeBLock = null) ->bool:
	if not NarrtBlq:
		return false
	narrativeBlqs.append(NarrtBlq)
	return true

## Avanza 1 bloque
## [code]return[code] (String) el bloque siguiente
func advance_block() -> void:
	print("SIGUIENTE BLOQUE: ", actualblock)
	if actualblock >= len(narrativeBlqs):
		return
	var block = narrativeBlqs[actualblock]
	# Si no hay dialogo devuelve vacio
	if block == null:
		printerr("[NARRATIVE ERROR] No hay dialogo valido.")
		return 
	# Si no ha llegado al final y puede continuar avanza el bloque
	if actualblock < (len(narrativeBlqs) + 1) and block.can_continue():
		actualblock += 1
	
	block.configure_label(label)
	label.text = block.reproduce()

## Retrocede 1 bloque
## [code]return[code] (String) el bloque anterior
func retreat_block() -> void:
	var block = narrativeBlqs[actualblock]
	# Si no hay bloque devuelve vacio
	if block == null:
		printerr("[NARRATIVE ERROR] No hay dialogo valido.")
		return 
	# Si no ha llegado al principio y puede continuar retrocede el bloque
	if actualblock > 0 and block.can_continue():
		actualblock -= 1
	
	block.configure_label(label)
	label.text = block.reproduce()

## Reestablece la narrativa desde el principio
func restart_block_begin() -> void:
	actualblock = 0
	var block = narrativeBlqs[actualblock]
	# Si no hay bloque devuelve vacio
	if block == null:
		printerr("[NARRATIVE ERROR] No hay bloque narrativo valido.")
		return
	
	block.configure_label(label)
	label.text = block.reproduce()

## Reestablece la narrativa desde el final
func restart_block_end() -> void:
	actualblock = len(narrativeBlqs) - 1
	var block = narrativeBlqs[actualblock]
	# Si no hay bloque devuelve vacio
	if block == null:
		printerr("[NARRATIVE ERROR] No hay bloque narrativo valido.")
		return
	
	block.configure_label(label)
	label.text = block.reproduce()

func is_end() -> bool:
	return actualblock >= len(narrativeBlqs)

func is_begining() -> bool:
	return actualblock <= 0
