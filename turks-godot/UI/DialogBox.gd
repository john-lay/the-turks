extends Node2D


signal dialog_complete


onready var dialog_box = $ContentLabel
onready var more_arrow = $MoreArrow

var _current_page: int = 0
var _pages: Array


# Called when the node enters the scene tree for the first time.
func _ready():
	more_arrow.visible = false


func write_pages(pages: Array):
	print("write pages", pages.size())
	_pages = pages
	if (pages.size() > 1):
		more_arrow.visible = true
	dialog_box.text = _pages[_current_page]


func _get_input():
	if (Input.is_action_just_pressed("ui_accept")):
		_current_page+=1
		if (_pages.size() > _current_page):
			dialog_box.text = _pages[_current_page]
		else:
			more_arrow.visible = false
			emit_signal("dialog_complete")


func _process(_delta):
	if (self.is_visible_in_tree()):
		_get_input()

