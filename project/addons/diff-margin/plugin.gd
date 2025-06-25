@tool
extends EditorPlugin

const DELETE_TOP = 1
const DELETE_BOTTOM = 2

const POPUP_DIFF = preload("res://addons/diff-margin/popup.tscn")

## Editor setting path
const DIFF_MARGIN: StringName = &"plugin/diff-margin/"
const GIT_PATH: StringName = DIFF_MARGIN + &"git_path"
const GUTTER_WIDTH: StringName = DIFF_MARGIN + &"gutter_width"
const COLOR_DELETE: StringName = DIFF_MARGIN + &"color_delete"
const COLOR_ADD: StringName = DIFF_MARGIN + &"color_add"
const COLOR_REPLACE: StringName = DIFF_MARGIN + &"color_replace"

var gutter_width := 0
var git_path := ""
var color_delete := Color()
var color_add := Color()
var color_replace := Color()

var _editor: CodeEdit = null
var _gutter_id := -1
var _diffs: Array[Array] = [] # [[start, count, old_content]]
var _diffs_map: = {} # <line, index in _diffs>
var _popup_diff: PopupPanel = null

func _enter_tree() -> void:
  var editor_settings := EditorInterface.get_editor_settings()
  editor_settings.settings_changed.connect(_on_settings_changed)
  if not editor_settings.has_setting(GIT_PATH):
    editor_settings.set_settings(GIT_PATH, "")
    editor_settings.set_initial_value(GIT_PATH, "", false)
  if not editor_settings.has_setting(GUTTER_WIDTH):
    editor_settings.set_settings(GUTTER_WIDTH, 6)
    editor_settings.set_initial_value(GUTTER_WIDTH, 6, false)
  if not editor_settings.has_setting(COLOR_DELETE):
    editor_settings.set_settings(COLOR_DELETE, Color.PALE_VIOLET_RED)
    editor_settings.set_initial_value(COLOR_DELETE, Color.PALE_VIOLET_RED, false)
  if not editor_settings.has_setting(COLOR_ADD):
    editor_settings.set_settings(COLOR_ADD, Color.LIGHT_GREEN)
    editor_settings.set_initial_value(COLOR_ADD, Color.LIGHT_GREEN, false)
  if not editor_settings.has_setting(COLOR_REPLACE):
    editor_settings.set_settings(COLOR_REPLACE, Color.SKY_BLUE)
    editor_settings.set_initial_value(COLOR_REPLACE, Color.SKY_BLUE, false)
  git_path = editor_settings.get_setting(GIT_PATH)
  gutter_width = editor_settings.get_setting(GUTTER_WIDTH)
  color_delete = editor_settings.get_setting(COLOR_DELETE)
  color_add = editor_settings.get_setting(COLOR_ADD)
  color_replace = editor_settings.get_setting(COLOR_REPLACE)

  var script_editor := EditorInterface.get_script_editor()
  script_editor.editor_script_changed.connect(_on_editor_script_changed)
  script_editor.focus_entered.connect(_on_editor_script_focus_entered)
  _on_editor_script_changed()
  resource_saved.connect(_on_resource_saved)

  _popup_diff = POPUP_DIFF.instantiate()
  _popup_diff.undo.connect(_on_undo_diff)
  script_editor.add_child(_popup_diff)
  _popup_diff.visible = false


func _exit_tree() -> void:
  var editor_settings := EditorInterface.get_editor_settings()
  editor_settings.settings_changed.disconnect(_on_settings_changed)
  var script_editor = EditorInterface.get_script_editor()
  script_editor.editor_script_changed.disconnect(_on_editor_script_changed)
  resource_saved.disconnect(_on_resource_saved)
  if _gutter_id != -1:
    _editor.gutter_clicked.disconnect(_on_gutter_clicked)
    _editor.remove_gutter(_gutter_id)
  script_editor.remove_child(_popup_diff)
  _popup_diff.free()


func _on_settings_changed():
  var editor_settings := EditorInterface.get_editor_settings()
  var changed_settings: PackedStringArray = editor_settings.get_changed_settings()
  for setting: String in changed_settings:
    if (!setting.begins_with(DIFF_MARGIN)):
      continue
    if setting == GIT_PATH:
      git_path = editor_settings.get_setting(setting)
    elif setting == GUTTER_WIDTH:
      gutter_width = editor_settings.get_setting(setting)
    elif setting == COLOR_DELETE:
      color_delete = editor_settings.get_setting(setting)
    elif setting == COLOR_ADD:
      color_add = editor_settings.get_setting(setting)
    elif setting == COLOR_REPLACE:
      color_replace = editor_settings.get_setting(setting)


func _on_resource_saved(resource: Resource):
  if resource is Script:
    _on_editor_script_changed(resource as Script)


func _on_editor_script_focus_entered():
  _on_editor_script_changed()


func _on_editor_script_changed(_script: Script = null):
  if _gutter_id != -1:
    _editor.gutter_clicked.disconnect(_on_gutter_clicked)
    _editor.remove_gutter(_gutter_id)

  var script_editor = EditorInterface.get_script_editor()
  if not script_editor or not script_editor.get_current_editor():
    return
  _editor = script_editor.get_current_editor().get_base_editor()
  _gutter_id = _editor.get_gutter_count()
  _editor.gutter_clicked.connect(_on_gutter_clicked)
  _editor.add_gutter()
  _editor.set_gutter_type(_gutter_id, TextEdit.GUTTER_TYPE_CUSTOM)
  _editor.set_gutter_custom_draw(_gutter_id, _on_gutter_custom_draw)
  _editor.set_gutter_width(_gutter_id, gutter_width)

  _diffs.clear()
  _diffs_map.clear()

  if git_path.is_empty():
    printerr("Git path is not defined (Editor > Editor Settings... > Plugin > Diff-margin)")

  var path = script_editor.get_current_script().get_path().substr(6, -1)
  var result = []

  # check if file is untracked
  var exit_code = OS.execute(git_path, ["status", "-s", path], result)
  if exit_code != 0:
    if not git_path.is_empty():
      printerr("Check the git path (Editor > Editor Settings... > Plugin > Diff-margin)")
    return

  if exit_code == 0 and not result.is_empty() and result[0].substr(0, 2) == "??":
    _apply_diff(0, _editor.get_line_count(), 0, "")
    return

  result.clear()
  exit_code = OS.execute(git_path, ["diff", "-U0", path], result)
  var diffs_string = [] if result.size() != 1 or result[0].is_empty() else result[0].split("\n").slice(4, -1)
  var removed := false
  var start := -1
  var count := 0
  var old_content := ""
  for diff_string: String in diffs_string:
    var first_char := diff_string[0]
    if first_char == "@":
      if start >= 0:
        _apply_diff(start, count, removed, old_content)
      var array = diff_string.split(" ")
      var removes = array[1].substr(1).split(",")
      var adds = array[2].substr(1).split(",")
      start = int(adds[0]) - 1
      count = int(adds[1]) if adds.size() > 1 else 1
      removed = (int(removes[1]) if removes.size() > 1 else 1) != 0
      old_content = ""
    elif first_char == "-":
      old_content = diff_string.substr(1) if old_content.is_empty() else old_content + "\n" + diff_string.substr(1)
  if start >= 0:
    _apply_diff(start, count, removed, old_content)


func _apply_diff(start: int, count: int, removed: bool, old_content: String):
  var diff_index := _diffs.size()
  if not old_content.is_empty():
    old_content += "\n"
  var line_count := _editor.get_line_count()
  var is_remove_only := count == 0 and removed
  var is_add_only := count > 0 and not removed
  var end := start + 2 if is_remove_only else start + count
  var color := color_add if is_add_only else color_replace
  color = color_delete if is_remove_only else color
  _diffs.append([start + 1 if is_remove_only else start, count, old_content])
  for line in range(start, end):
    if line >= 0 and line < line_count:
      _editor.set_line_gutter_item_color(line, _gutter_id, color)
      _editor.set_line_gutter_clickable(line, _gutter_id, true)
      if is_remove_only:
        _editor.set_line_gutter_metadata(line, _gutter_id, DELETE_TOP if line == start else DELETE_BOTTOM)
      _diffs_map[line] = diff_index


func _on_gutter_clicked(line: int, gutter: int):
  if gutter != _gutter_id or not _editor.is_line_gutter_clickable(line, gutter):
    return

  _popup_diff.line = line
  _popup_diff.content = _diffs[_diffs_map[line]][2]
  _popup_diff.popup(Rect2i(get_viewport().get_mouse_position(), Vector2.ZERO))


func _on_undo_diff(line: int):
  var start: int = _diffs[_diffs_map[line]][0]
  var count: int = _diffs[_diffs_map[line]][1]
  var old_content: String = _diffs[_diffs_map[line]][2]
  _editor.remove_text(start, 0, start + count, 0)
  _editor.insert_text(old_content, start, 0)
  EditorInterface.save_scene()


func _on_gutter_custom_draw(line: int, gutter: int, area: Rect2):
  if gutter != _gutter_id or not _editor.is_line_gutter_clickable(line, gutter):
    return
  var color := _editor.get_line_gutter_item_color(line, gutter)
  var metadata = _editor.get_line_gutter_metadata(line, _gutter_id)
  if metadata == null:
    _editor.draw_rect(area, color)
  elif metadata == DELETE_TOP:
    _editor.draw_colored_polygon(PackedVector2Array([Vector2(area.position.x, area.end.y - gutter_width), area.end, Vector2(area.position.x, area.end.y)]), color)
  elif metadata == DELETE_BOTTOM:
    _editor.draw_colored_polygon(PackedVector2Array([area.position, Vector2(area.end.x, area.position.y), Vector2(area.position.x, area.position.y + gutter_width)]), color)
