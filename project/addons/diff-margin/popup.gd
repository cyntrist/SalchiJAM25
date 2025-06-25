@tool
extends PopupPanel

var line := -1
var content := ""

signal undo(line: int)
signal hide_popup()

func _on_undo_button_pressed() -> void:
  undo.emit(line)


func _on_copy_button_pressed() -> void:
  if not content.is_empty():
    DisplayServer.clipboard_set(content)


func _on_about_to_popup() -> void:
  # remove old label
  while %VBoxContainer.get_child_count() > 1:
    %VBoxContainer.remove_child(%VBoxContainer.get_child(1))
  # force recompute size
  size = Vector2(100, 100)
  if content.is_empty():
    return
  var label = Label.new()
  label.text = content
  %VBoxContainer.add_child(label)
