extends Node2D


signal dialog_complete


onready var dialog_box = $ContentLabel
onready var heading = $HeadingLabel
onready var more_arrow = $MoreArrow
onready var tsung_portrait = $TsungPortrait
onready var global = get_node("/root/Global")

var _current_page: int = 0
var _pages: Array
var _lang: String
var _dialog_type


# Called when the node enters the scene tree for the first time.
func _ready():
	more_arrow.visible = false
	_lang = global.g_settings["lang"]
	_dialog_type = global.g_DIALOG_TYPE.UNKNOWN
	tsung_portrait.visible = false


func _debugPrintDialogPages(pages: Array):
	print("book contains: " + pages.size() as String + " pages")
	for i in pages.size():
		var index: String = i as String
		print("  page[" + index  + "] contains: " + pages[i].Lines.size() as String + " lines")
		for j in pages[i].Lines.size():
			var jndex: String = j as String
			print("    page[" + index + "] line[" + jndex + "] path: ", pages[i].Lines[j].PathToSentence)
			print("    page[" + index + "] line[" + jndex + "] format: ", pages[i].Lines[j].FormatSentence)


func _setPagesFromDialogPages(pages: Array):
	var dict = global.g_strings
	heading.text = ""
	for page in pages:
		var page_contents: String
		for line in page.Lines.size():
			var copy = page.Lines[line].PathToSentence.duplicate()
			copy.push_back("color")
			var hasColor: Array = copy
			var color_value = get_value_from_path(dict, hasColor)
			if color_value != null:
				heading.add_color_override("font_color", color_value)
				
			page.Lines[line].PathToSentence.push_back(_lang)
			var localizedSentence: Array = page.Lines[line].PathToSentence
			var raw_value = get_value_from_path(dict, localizedSentence)
			if raw_value != null && color_value != null:
				heading.text = raw_value
				page_contents += "\n"
			elif raw_value != null:
				var formatted_value = raw_value % page.Lines[line].FormatSentence
				page_contents += formatted_value
				if line <= page.Lines.size():
					page_contents += "\n"
			else:
				print("Key not found in the dictionary")
		_pages.push_back(page_contents)


func write_pages(pages: Array, dialog_type):
	_dialog_type = dialog_type
#	_debugPrintDialogPages(pages)
	_setPagesFromDialogPages(pages)
#	if (pages.size() > 1):
	more_arrow.visible = true
	dialog_box.text = _pages[_current_page]


func _get_input():
	if (Input.is_action_just_pressed("ui_accept")):
		_current_page+=1
		if (_pages.size() > _current_page):
			dialog_box.text = _pages[_current_page]
		else:
			more_arrow.visible = false
			emit_signal("dialog_complete", _dialog_type)


func get_value_from_path(dict: Dictionary, path: Array):
	var current_dict = dict
	for key in path:
		if not current_dict.has(key):
			return null  # Handle the case where a key is not found
		current_dict = current_dict[key]
	return current_dict


func _process(_delta):
	if (self.is_visible_in_tree()):
		_get_input()

