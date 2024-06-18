extends Node2D


signal dialog_complete


onready var dialog_box = $ContentLabel
onready var heading = $HeadingLabel
onready var more_arrow = $MoreArrow
onready var tsung_portrait = $TsungPortrait
onready var global = get_node("/root/Global")

var _current_page: int = 0
var _headings: Array
var _pages: Array
var _portraits: Array
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
		var heading = null
		for line in page.Lines.size():
			# Handle case where the heading should be coloured
			var copy = page.Lines[line].PathToSentence.duplicate()
			copy.push_back("color")
			var hasColor: Array = copy
			var color_value = get_value_from_path(dict, hasColor)
			
			# Grab the text from the look up table and localise
			page.Lines[line].PathToSentence.push_back(_lang)
			var localizedSentence: Array = page.Lines[line].PathToSentence
			var raw_value = get_value_from_path(dict, localizedSentence)
			
			if raw_value != null && color_value != null:
				heading = global.DialogHeading.new(raw_value, color_value)
				page_contents += "\n"
			elif raw_value != null:
				# Handle case where we need to display the player name
				if raw_value == global.g_DISPLAY_PLAYER_NAME:
#					print("displaying player name")
					page_contents += global.g_settings.player_name
					if line <= page.Lines.size():
						page_contents += "\n"
				else:
					var formatted_value = raw_value % page.Lines[line].FormatSentence
					page_contents += formatted_value
					if line <= page.Lines.size():
						page_contents += "\n"
			else:
				print("Key not found in the dictionary")
		_pages.push_back(page_contents)
		_portraits.push_back(page.Portrait)
		_headings.push_back(heading)


func show_portrait():
	if _portraits[_current_page] == global.g_PORTRAITS.UNKNOWN:
		hide_portraits()
	elif _portraits[_current_page] == global.g_PORTRAITS.TSUNG:
		tsung_portrait.visible = true


func hide_portraits():
	tsung_portrait.visible = false


func show_heading():
	print(_headings[_current_page] is global.DialogHeading)
	if _headings[_current_page] is global.DialogHeading:
		heading.text = _headings[_current_page].Text
		heading.add_color_override("font_color", _headings[_current_page].Colour)
	else:
		heading.text = ""


func write_pages(pages: Array, dialog_type):
	_dialog_type = dialog_type
#	_debugPrintDialogPages(pages)
	_setPagesFromDialogPages(pages)
	more_arrow.visible = true
	dialog_box.text = _pages[_current_page]
	show_portrait()
	show_heading()


func _get_input():
	if (Input.is_action_just_pressed("ui_accept")):
		_current_page+=1
		if (_pages.size() > _current_page):
			dialog_box.text = _pages[_current_page]
			show_portrait()
			show_heading()
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

