extends Node2D

signal close

onready var magic_cursor = $MagicCursor

var initial_offset:Vector2 = Vector2(16, 26)
var tile_size: int = 52
var max_offset_x:int = initial_offset.x + (tile_size * 3)
var max_offset_y:int = initial_offset.y + (tile_size * 2)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (self.is_visible_in_tree()):
		_get_input()


func _get_input():
	if (Input.is_action_just_pressed("ui_down")):
		if magic_cursor.position.y <= max_offset_y:
			magic_cursor.position.y += tile_size
	if (Input.is_action_just_pressed("ui_up")):
		if magic_cursor.position.y > initial_offset.y:
			magic_cursor.position.y -= tile_size
	if (Input.is_action_just_pressed("ui_right")):
		if magic_cursor.position.x <= max_offset_x:
			magic_cursor.position.x += tile_size
	if (Input.is_action_just_pressed("ui_left")):
		if magic_cursor.position.x > initial_offset.x:
			magic_cursor.position.x -= tile_size
	if (Input.is_action_just_pressed("ui_cancel")):
		emit_signal("close")

func set_cursor_position(player_position: Vector2):
	magic_cursor.position = initial_offset
	_set_cursor_position_x(player_position.x)
	_set_cursor_position_y(player_position.y)
	

func _set_cursor_position_x(x):
	if x < initial_offset.x:
		return
	elif x < initial_offset.x + tile_size:
		magic_cursor.position.x += tile_size
	elif x < initial_offset.x + (tile_size * 2):
		magic_cursor.position.x += (tile_size * 2)
	elif x < initial_offset.x + (tile_size * 3):
		magic_cursor.position.x += (tile_size * 3)
	else:
		magic_cursor.position.x += (tile_size * 4)


func _set_cursor_position_y(y):
	if y < initial_offset.y:
		return
	elif y < initial_offset.y + tile_size:
		magic_cursor.position.y += tile_size
	elif y < initial_offset.y + (tile_size * 2):
		magic_cursor.position.y += (tile_size * 2)
	else:
		magic_cursor.position.y += (tile_size * 3)
