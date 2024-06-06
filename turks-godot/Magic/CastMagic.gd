extends Node2D

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
