extends Node2D

onready var player = $Player
onready var overworld_menu = get_node("CanvasLayer/OverworldMenu")


# Called when the node enters the scene tree for the first time.
func _ready():
	overworld_menu.visible = false


func _enable_actors():
	if (player.has_method("enable_player")):
		player.enable_player()


func _disable_actors():
	if (player.has_method("disable_player")):
		player.disable_player()


func _on_Player_player_select():
	_disable_actors()
	overworld_menu.visible = true
	if overworld_menu.has_method("should_manage_input"):
		overworld_menu.should_manage_input()


func _on_OverworldMenu_close():
	_enable_actors()
	overworld_menu.visible = false


func _on_OverworldMenu_select(option):
	print("overworld menu option selected: ", option)
