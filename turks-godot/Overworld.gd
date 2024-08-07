extends Node2D

onready var player = $Player
onready var phone_audio = $PhoneAudio
onready var overworld_menu = get_node("CanvasLayer/OverworldMenu")

enum STATE {
	PLAYER_INTRO,
	INITIAL_DIALOG,
}

var state = STATE.PLAYER_INTRO
var has_played_phone_audio: bool = false



# Called when the node enters the scene tree for the first time.
func _ready():
	overworld_menu.visible = false
	_player_intro()


func _player_intro():
	_disable_actors()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == STATE.PLAYER_INTRO:
		if player.position.x > 140 && !has_played_phone_audio:
			_play_phone_audio()
		if player.position.x < 160:
			player.get_node("AnimatedSprite").animation = "move-right"
			player.position.x+=1.5
		else:
			player.get_node("AnimatedSprite").animation = "idle-right"
			yield(get_tree().create_timer(1.0), "timeout")
			player.get_node("AnimatedSprite").animation = "phone"
			state = STATE.INITIAL_DIALOG
			_show_initial_dialog()


func _show_initial_dialog():
	print("show initial dialog")


func _play_phone_audio():
	if !has_played_phone_audio:
		has_played_phone_audio = true
		phone_audio.play()


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
