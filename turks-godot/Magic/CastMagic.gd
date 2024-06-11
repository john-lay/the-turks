extends Node2D

signal close
signal cast_spell
signal finished

onready var magic_cursor = $MagicCursor
onready var thunder_animation = $ThunderAnimation

var initial_offset:Vector2 = Vector2(16, 26)
var tile_size: int = 52
var max_offset_x:int = initial_offset.x + (tile_size * 3)
var max_offset_y:int = initial_offset.y + (tile_size * 2)
var animation_started:bool = false
var animation_finished:bool = false
var manage_input: bool = false
var should_do_damage: bool = false
var damage: int


# Called when the node enters the scene tree for the first time.
func _ready():
	thunder_animation.visible = false
	# Materia Lv x 25 + Magic x Character Lv + 25
	damage = 1 * 25 + 0 * 1 + 25


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (self.is_visible_in_tree() && manage_input):
		_get_input()
		if (animation_started && !animation_finished):
			_has_finished_thunder_animation()


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
#		print("magic emitting close signal")
		manage_input = false
		emit_signal("close")
	if (Input.is_action_just_pressed("ui_accept")):
#		print("magic emitting cast spell signal")
		emit_signal("cast_spell")


func set_cursor_position(player_position: Vector2):
	magic_cursor.visible = true
	magic_cursor.position = Vector2.ZERO
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


func _has_finished_thunder_animation():
	var last_thunder_frame: int = 4
	if (thunder_animation.get_frame() == last_thunder_frame):
		thunder_animation.visible = false
		animation_finished = true
		animation_started = false
		manage_input = false
		thunder_animation.stop()
		thunder_animation.set_frame(0)
		emit_signal("finished", should_do_damage, damage)


func animate_spell():
	magic_cursor.visible = false
	
	thunder_animation.position.x = magic_cursor.position.x
	thunder_animation.position.y = magic_cursor.position.y - tile_size	
	thunder_animation.visible = true
	thunder_animation.play("default")
	animation_finished = false
	animation_started = true


func should_manage_input():
	# add a slight delay to prevent materia menu input being read here
	yield(get_tree().create_timer(0.5), "timeout")
	manage_input = true


func _on_MagicCursor_body_entered(body):
	if body.is_in_group("enemy_group"):
#		print("cursor collided with ", body.name)
		if body.has_method("show_finger"):
			body.show_finger()
			should_do_damage = true


func _on_MagicCursor_body_exited(body):
	if body.is_in_group("enemy_group"):
#		print("cursor no longer collided with ", body.name)
		if body.has_method("hide_finger"):
			body.hide_finger()
			should_do_damage = false
