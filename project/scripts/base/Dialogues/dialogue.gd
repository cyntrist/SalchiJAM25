extends Node
class_name Dialogue

var soundEmmitter = null

var callable : Callable
var text := ""
var sound := ""

func reproduce() -> String:
	callable.call()
	
	return text
