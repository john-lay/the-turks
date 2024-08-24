extends Node2D

signal load_battle_1

onready var player = $Player
onready var enemy1 = $Enemy1
onready var enemy2 = $Enemy2
onready var phone_audio = $PhoneAudio
onready var mission_theme_audio = $MissionThemeAudio
onready var turks_theme_audio = $TurksThemeAudio
onready var global = get_node("/root/Global")
onready var overworld_menu = get_node("CanvasLayer/OverworldMenu")
onready var dialog_box_top = get_node("CanvasLayer/DialogBoxTop")
onready var dialog_box_bottom = get_node("CanvasLayer/DialogBoxBottom")
onready var transition = get_node("CanvasLayer/Transition")
onready var camera = get_node("Player/Camera2D")

enum STATE {
	PLAYER_INTRO,
	INITIAL_DIALOG,
	ENEMY_SPOTTED,
	PAN_CAMERA_TO_ENEMY,
	AVALANCHE_DIALOG,
	PAN_CAMERA_TO_PLAYER,
	SPOTTED_DIALOG,
	CONFRONT_PLAYER,
	PAN_CAMERA_TO_CONFRONTATION,
	CONFRONTATION_DIALOG,
	ENEMY1_ENGAGE_PLAYER,
}

var state = STATE.PLAYER_INTRO
var _has_played_phone_audio: bool = false
var _has_played_player_intro: bool = false # cater for debounce in _process
var _has_spotted_enemy: bool = false # cater for debounce in _process
var _has_panned_camera_to_enemy: bool = false # cater for debounce in _process
var _has_panned_camera_to_player: bool = false # cater for debounce in _process
var _has_panned_camera_to_confrontation: bool = false # cater for debounce in _process
var _has_transition_to_battle1: bool = false # cater for debounce in _process
var _camera_before_enemy_spotted: Vector2
var _camera_after_enemy_spotted: Vector2
var _camera_after_player_spotted: Vector2

# debug flags to skip dialog
var _debug_skip_initial_dialog: bool = true
var _debug_skip_avalanche_dialog: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	overworld_menu.visible = false
	dialog_box_top.visible = false
	transition.visible = false
	if dialog_box_top.has_method("set_portrait_top_left"):
		dialog_box_top.set_portrait_top_left()
	dialog_box_bottom.visible = false
	turks_theme_audio.play()
	_player_intro()
	if enemy1.has_method("disable_enemy"):
		enemy1.disable_enemy(Vector2.UP)
	if enemy2.has_method("disable_enemy"):
		enemy2.disable_enemy()


func _player_intro():
	_disable_actors()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == STATE.PLAYER_INTRO:
		_play_player_intro()
	if state == STATE.ENEMY_SPOTTED:
		_play_enemy_spotted()
	if state == STATE.PAN_CAMERA_TO_ENEMY:
		_play_pan_camera_to_enemy()
	if state == STATE.PAN_CAMERA_TO_PLAYER:
		_play_pan_camera_to_player()
	if state == STATE.CONFRONT_PLAYER:
		_play_confront_player()
	if state == STATE.PAN_CAMERA_TO_CONFRONTATION:
		_play_pan_camera_to_confrontation()
	if state == STATE.ENEMY1_ENGAGE_PLAYER:
		_play_enemy1_engage_player()


func _play_player_intro():
	if player.position.x > 140 && !_has_played_phone_audio:
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


func _play_enemy_spotted():
	if player.position.x > 255:
		player.get_node("AnimatedSprite").animation = "move-left"
		player.position.x-=1.5
	else:
		if player.position.y > 45:
			player.get_node("AnimatedSprite").animation = "move-up"
			player.position.y-=1.5
		else:
			player.get_node("AnimatedSprite").animation = "idle-down"
			_enemy_spotted()


func _play_pan_camera_to_enemy():
	var camera_move_complete_x = false
	var camera_move_complete_y = false
	if camera.position.x < _camera_after_enemy_spotted.x:
		camera.position.x += 1
	else:
		camera_move_complete_x = true
	if camera.position.y > _camera_after_enemy_spotted.y:
		camera.position.y -= 1
	else:
		camera_move_complete_y = true
	if camera_move_complete_x && camera_move_complete_y:
		_show_avalanche_dialog()


func _play_pan_camera_to_player():
	var camera_move_complete_x = false
	var camera_move_complete_y = false
	if camera.position.x > _camera_after_player_spotted.x:
		camera.position.x -= 1
	else:
		camera_move_complete_x = true
	if camera.position.y < _camera_after_player_spotted.y:
		camera.position.y += 1
	else:
		camera_move_complete_y = true
	if camera_move_complete_x && camera_move_complete_y:
		_show_player_spotted_dialog()


func _play_confront_player():
	if enemy1.position.y < player.position.y + 32:
		enemy1.get_node("AnimatedSprite").animation = "move-down"
		enemy1.position.y += 1.5
	else:
		player.get_node("AnimatedSprite").animation = "idle-right"
		enemy1.get_node("AnimatedSprite").animation = "stationary-left"
		state = STATE.PAN_CAMERA_TO_CONFRONTATION


func _play_enemy1_engage_player():
	if enemy1.position.x > player.position.x + 90:
		enemy1.get_node("AnimatedSprite").animation = "move-left"
		enemy1.position.x -= 1.5
	else:
		enemy1.get_node("AnimatedSprite").animation = "stationary-left"
		_play_battle_transition()


func _play_battle_transition():
	transition.visible = true
	if transition.scale.y < 1:
		transition.scale.y += 0.02
	else:
		_transition_to_battle1()


func _transition_to_battle1():
	if !_has_transition_to_battle1:
		_has_transition_to_battle1 = true
		emit_signal("load_battle_1")


func _play_pan_camera_to_confrontation():
	if camera.position.x < _camera_after_player_spotted.x + 52:
		camera.position.x += 1
	else:
		_show_confrontation_dialog()


func _enemy_spotted():
	if !_has_spotted_enemy:
		_has_spotted_enemy = true
		_pan_camera_to_enemy()


func _pan_camera_to_enemy():
	_camera_before_enemy_spotted = camera.position
	_camera_after_enemy_spotted = Vector2(camera.position.x + 100, camera.position.y - 25)
	state = STATE.PAN_CAMERA_TO_ENEMY


func _show_confrontation_dialog():
	if !_has_panned_camera_to_confrontation:
		_has_panned_camera_to_confrontation = true
		state = STATE.CONFRONTATION_DIALOG
#		if _debug_skip_avalanche_dialog:
#			_dialog_finished()
#		else:
#			_show_avalanche_dialog1()
		_show_confrontation_dialog1()


func _show_confrontation_dialog1():
	if (dialog_box_top.has_method("write_pages")):
		var pathToPage1Sentence1 = ["confrontation_1", "page1line1"]
		var page1line1 = global.DialogLine.new(pathToPage1Sentence1)
		var page1 = global.DialogPage.new([page1line1], global.g_PORTRAITS.AVALANCHE)
		
		var pathToPage2Sentence1 = ["confrontation_1", "page2line1"]
		var page2line1 = global.DialogLine.new(pathToPage2Sentence1)
		var pathToPage2Sentence2 = ["confrontation_1", "page2line2"]
		var page2line2 = global.DialogLine.new(pathToPage2Sentence2)
		var page2 = global.DialogPage.new([page2line1, page2line2], global.g_PORTRAITS.AVALANCHE)

		var pages: Array = [page1, page2]
		dialog_box_top.write_pages(pages, global.g_DIALOG_TYPE.CONFRONTATION_1)
		if dialog_box_top.has_method("show_text_box"):
			dialog_box_top.show_text_box()
		dialog_box_top.visible = true


func _show_confrontation_dialog2():
	if (dialog_box_bottom.has_method("write_pages")):
		var pathToPage1Sentence1 = ["character", "shotgun"]
		var page1line1 = global.DialogLine.new(pathToPage1Sentence1)
		var pathToPage1Sentence2 = ["confrontation_2", "page1line2"]
		var page1line2 = global.DialogLine.new(pathToPage1Sentence2)
		var pathToPage1Sentence3 = ["confrontation_2", "page1line3"]
		var page1line3 = global.DialogLine.new(pathToPage1Sentence3)
		var page1 = global.DialogPage.new([page1line1, page1line2, page1line3], global.g_PORTRAITS.SHOTGUN)
		
		var pages: Array = [page1]
		dialog_box_bottom.write_pages(pages, global.g_DIALOG_TYPE.CONFRONTATION_2)
		if dialog_box_bottom.has_method("show_text_box"):
			dialog_box_bottom.show_text_box()
		dialog_box_bottom.visible = true


func _show_confrontation_dialog3():
	if (dialog_box_top.has_method("write_pages")):
		var pathToPage1Sentence1 = ["confrontation_3", "page1line1"]
		var page1line1 = global.DialogLine.new(pathToPage1Sentence1)
		var pathToPage1Sentence2 = ["confrontation_3", "page1line2"]
		var page1line2 = global.DialogLine.new(pathToPage1Sentence2)
		var pathToPage1Sentence3 = ["confrontation_3", "page1line3"]
		var page1line3 = global.DialogLine.new(pathToPage1Sentence3)
		var page1 = global.DialogPage.new([page1line1, page1line2, page1line3], global.g_PORTRAITS.AVALANCHE)
		
		var pages: Array = [page1]
		dialog_box_top.write_pages(pages, global.g_DIALOG_TYPE.CONFRONTATION_3)
		dialog_box_top.visible = true


func _show_player_spotted_dialog():
	if !_has_panned_camera_to_player:
		_has_panned_camera_to_player = true
		state = STATE.SPOTTED_DIALOG
#		if _debug_skip_avalanche_dialog:
#			_dialog_finished()
#		else:
#			_show_avalanche_dialog1()
		
		if player.has_method("show_emote"):
			player.show_emote()
		if enemy1.has_method("disable_enemy"):
			enemy1.disable_enemy(Vector2.LEFT)
		if enemy1.has_method("show_emote"):
			enemy1.show_emote()
		_show_player_spotted_dialog1()


func _show_player_spotted_dialog1():
	if (dialog_box_bottom.has_method("write_pages")):
		var pathToPage1Sentence1 = ["player_spotted_1", "page1line1"]
		var page1line1 = global.DialogLine.new(pathToPage1Sentence1)
		var page1 = global.DialogPage.new([page1line1], global.g_PORTRAITS.AVALANCHE)

		var pages: Array = [page1]
		dialog_box_bottom.write_pages(pages, global.g_DIALOG_TYPE.PLAYER_SPOTTED_DIALOG_1)
		if dialog_box_bottom.has_method("show_text_box"):
			dialog_box_bottom.show_text_box()
		dialog_box_bottom.visible = true


func _show_player_spotted_dialog2():
	if (dialog_box_bottom.has_method("write_pages")):
		var pathToPage1Sentence1 = ["character", "shotgun"]
		var page1line1 = global.DialogLine.new(pathToPage1Sentence1)
		var pathToPage1Sentence2 = ["player_spotted_2", "page1line2"]
		var page1line2 = global.DialogLine.new(pathToPage1Sentence2)
		var page1 = global.DialogPage.new([page1line1, page1line2], global.g_PORTRAITS.SHOTGUN)
				
		var pathToPage2Sentence1 = ["player_spotted_2", "page2line1"]
		var page2line1 = global.DialogLine.new(pathToPage2Sentence1)
		var page2 = global.DialogPage.new([page2line1], global.g_PORTRAITS.SHOTGUN)
		
		var pages: Array = [page1, page2]
		dialog_box_bottom.write_pages(pages, global.g_DIALOG_TYPE.PLAYER_SPOTTED_DIALOG_2)
		if dialog_box_bottom.has_method("show_text_box"):
			dialog_box_bottom.show_text_box()
		dialog_box_bottom.visible = true


func _show_avalanche_dialog():
	if !_has_panned_camera_to_enemy:
		_has_panned_camera_to_enemy = true
		state = STATE.AVALANCHE_DIALOG
		if _debug_skip_avalanche_dialog:
			_dialog_finished()
		else:
			_show_avalanche_dialog1()


func _show_avalanche_dialog1():
	if (dialog_box_bottom.has_method("write_pages")):
		var pathToPage1Sentence1 = ["avalanche_dialog_1", "page1line1"]
		var page1line1 = global.DialogLine.new(pathToPage1Sentence1)
		var pathToPage1Sentence2 = ["avalanche_dialog_1", "page1line2"]
		var page1line2 = global.DialogLine.new(pathToPage1Sentence2)
		var pathToPage1Sentence3 = ["avalanche_dialog_1", "page1line3"]
		var page1line3 = global.DialogLine.new(pathToPage1Sentence3)
		var page1 = global.DialogPage.new([page1line1, page1line2, page1line3], global.g_PORTRAITS.AVALANCHE)

		var pathToPage2Sentence1 = ["avalanche_dialog_1", "page2line1"]
		var page2line1 = global.DialogLine.new(pathToPage2Sentence1)
		var page2 = global.DialogPage.new([page2line1], global.g_PORTRAITS.AVALANCHE)
		
		var pathToPage3Sentence1 = ["avalanche_dialog_1", "page3line1"]
		var page3line1 = global.DialogLine.new(pathToPage3Sentence1)
		var pathToPage3Sentence2 = ["avalanche_dialog_1", "page3line2"]
		var page3line2 = global.DialogLine.new(pathToPage3Sentence2)
		var page3 = global.DialogPage.new([page3line1, page3line2], global.g_PORTRAITS.AVALANCHE)
		
		var pages: Array = [page1, page2, page3]
		dialog_box_bottom.write_pages(pages, global.g_DIALOG_TYPE.AVALANCHE_DIALOG_1)
		if dialog_box_bottom.has_method("show_text_box"):
			dialog_box_bottom.show_text_box()
		dialog_box_bottom.visible = true


func _show_avalanche_dialog2():
	if (dialog_box_top.has_method("write_pages")):
		var pathToPage1Sentence1 = ["avalanche_dialog_2", "page1line1"]
		var page1line1 = global.DialogLine.new(pathToPage1Sentence1)
		var pathToPage1Sentence2 = ["avalanche_dialog_2", "page1line2"]
		var page1line2 = global.DialogLine.new(pathToPage1Sentence2)
		var page1 = global.DialogPage.new([page1line1, page1line2], global.g_PORTRAITS.AVALANCHE)

		var pages: Array = [page1]
		dialog_box_top.write_pages(pages, global.g_DIALOG_TYPE.AVALANCHE_DIALOG_2)
		if dialog_box_top.has_method("show_text_box"):
			dialog_box_top.show_text_box()
		dialog_box_top.visible = true


func _show_avalanche_dialog3():
	if (dialog_box_bottom.has_method("write_pages")):
		var pathToPage1Sentence1 = ["character", "shotgun"]
		var page1line1 = global.DialogLine.new(pathToPage1Sentence1)
		var pathToPage1Sentence2 = ["avalanche_dialog_3", "page1line2"]
		var page1line2 = global.DialogLine.new(pathToPage1Sentence2)
		var page1 = global.DialogPage.new([page1line1, page1line2], global.g_PORTRAITS.SHOTGUN)
				
		var pathToPage2Sentence1 = ["avalanche_dialog_3", "page2line1"]
		var page2line1 = global.DialogLine.new(pathToPage2Sentence1)
		var pathToPage2Sentence2 = ["avalanche_dialog_3", "page2line2"]
		var page2line2 = global.DialogLine.new(pathToPage2Sentence2)
		var pathToPage2Sentence3 = ["avalanche_dialog_3", "page2line3"]
		var page2line3 = global.DialogLine.new(pathToPage2Sentence3)
		var page2 = global.DialogPage.new([page2line1, page2line2, page2line3], global.g_PORTRAITS.SHOTGUN)
		
		var pages: Array = [page1, page2]
		dialog_box_bottom.write_pages(pages, global.g_DIALOG_TYPE.AVALANCHE_DIALOG_3)
		if dialog_box_bottom.has_method("show_text_box"):
			dialog_box_bottom.show_text_box()
		dialog_box_bottom.visible = true


func _show_initial_dialog():
	if !_has_played_player_intro:
		_has_played_player_intro = true
		_disable_actors() # causes player to idle-animation
		if _debug_skip_initial_dialog:
			_dialog_finished()
		else:
			_show_initial_dialog1()


func _show_initial_dialog1():
	if (dialog_box_top.has_method("write_pages")):
		var pathToPage1Sentence1 = ["character", "tseng"]
		var page1line1 = global.DialogLine.new(pathToPage1Sentence1)
		var pathToPage1Sentence2 = ["intro_dialog_1", "page1line2"]
		var page1line2 = global.DialogLine.new(pathToPage1Sentence2)
		var pathToPage1Sentence3 = ["intro_dialog_1", "page1line3"]
		var page1line3 = global.DialogLine.new(pathToPage1Sentence3)
		var page1 = global.DialogPage.new([page1line1, page1line2, page1line3], global.g_PORTRAITS.TSENG)
		
		var pathToPage2Sentence1 = ["intro_dialog_1", "page2line1"]
		var page2line1 = global.DialogLine.new(pathToPage2Sentence1)
		var pathToPage2Sentence2 = ["intro_dialog_1", "page2line2"]
		var page2line2 = global.DialogLine.new(pathToPage2Sentence2)
		var page2 = global.DialogPage.new([page2line1, page2line2], global.g_PORTRAITS.TSENG)

		var pathToPage3Sentence1 = ["intro_dialog_1", "page3line1"]
		var page3line1 = global.DialogLine.new(pathToPage3Sentence1)
		var page3 = global.DialogPage.new([page3line1], global.g_PORTRAITS.TSENG)
		
		var pathToPage4Sentence1 = ["intro_dialog_1", "page4line1"]
		var page4line1 = global.DialogLine.new(pathToPage4Sentence1)
		var pathToPage4Sentence2 = ["intro_dialog_1", "page4line2"]
		var page4line2 = global.DialogLine.new(pathToPage4Sentence2)
		var pathToPage4Sentence3 = ["intro_dialog_1", "page4line3"]
		var page4line3 = global.DialogLine.new(pathToPage4Sentence3)
		var page4 = global.DialogPage.new([page4line1, page4line2, page4line3], global.g_PORTRAITS.TSENG)
		
		var pages: Array = [page1, page2, page3, page4]
		dialog_box_top.write_pages(pages, global.g_DIALOG_TYPE.INTRO_DIALOG_1)
		dialog_box_top.visible = true


func _show_initial_dialog2():
	if (dialog_box_bottom.has_method("write_pages")):
		var pathToPage1Sentence1 = ["character", "shotgun"]
		var page1line1 = global.DialogLine.new(pathToPage1Sentence1)
		var pathToPage1Sentence2 = ["intro_dialog_2", "page1line2"]
		var page1line2 = global.DialogLine.new(pathToPage1Sentence2)
		var page1 = global.DialogPage.new([page1line1, page1line2], global.g_PORTRAITS.SHOTGUN)
				
		var pathToPage2Sentence1 = ["intro_dialog_2", "page2line1"]
		var page2line1 = global.DialogLine.new(pathToPage2Sentence1)
		var pathToPage2Sentence2 = ["intro_dialog_2", "page2line2"]
		var page2line2 = global.DialogLine.new(pathToPage2Sentence2)
		var pathToPage2Sentence3 = ["intro_dialog_2", "page2line3"]
		var page2line3 = global.DialogLine.new(pathToPage2Sentence3)
		var page2 = global.DialogPage.new([page2line1, page2line2, page2line3], global.g_PORTRAITS.SHOTGUN)
		
		var pages: Array = [page1, page2]
		dialog_box_bottom.write_pages(pages, global.g_DIALOG_TYPE.INTRO_DIALOG_2)
		dialog_box_bottom.visible = true


func _show_initial_dialog3():
	if (dialog_box_top.has_method("write_pages")):
		var pathToPage1Sentence1 = ["character", "tseng"]
		var page1line1 = global.DialogLine.new(pathToPage1Sentence1)
		var pathToPage1Sentence2 = ["intro_dialog_3", "page1line2"]
		var page1line2 = global.DialogLine.new(pathToPage1Sentence2)
		var pathToPage1Sentence3 = ["intro_dialog_3", "page1line3"]
		var page1line3 = global.DialogLine.new(pathToPage1Sentence3)
		var page1 = global.DialogPage.new([page1line1, page1line2, page1line3], global.g_PORTRAITS.TSENG)
		
		var pathToPage2Sentence1 = ["intro_dialog_3", "page2line1"]
		var page2line1 = global.DialogLine.new(pathToPage2Sentence1)
		var pathToPage2Sentence2 = ["intro_dialog_3", "page2line2"]
		var page2line2 = global.DialogLine.new(pathToPage2Sentence2)
		var pathToPage2Sentence3 = ["intro_dialog_3", "page2line3"]
		var page2line3 = global.DialogLine.new(pathToPage2Sentence3)
		var page2 = global.DialogPage.new([page2line1, page2line2, page2line3], global.g_PORTRAITS.TSENG)

		var pathToPage3Sentence1 = ["intro_dialog_3", "page3line1"]
		var page3line1 = global.DialogLine.new(pathToPage3Sentence1)
		var pathToPage3Sentence2 = ["intro_dialog_3", "page3line2"]
		var page3line2 = global.DialogLine.new(pathToPage3Sentence2)
		var pathToPage3Sentence3 = ["intro_dialog_3", "page3line3"]
		var page3line3 = global.DialogLine.new(pathToPage3Sentence3)
		var page3 = global.DialogPage.new([page3line1, page3line2, page3line3], global.g_PORTRAITS.TSENG)
		
		var pages: Array = [page1, page2, page3]
		dialog_box_top.write_pages(pages, global.g_DIALOG_TYPE.INTRO_DIALOG_3)
		dialog_box_top.visible = true


func _show_initial_dialog4():
	if (dialog_box_bottom.has_method("write_pages")):
		var pathToPage1Sentence1 = ["character", "shotgun"]
		var page1line1 = global.DialogLine.new(pathToPage1Sentence1)
		var pathToPage1Sentence2 = ["intro_dialog_4", "page1line2"]
		var page1line2 = global.DialogLine.new(pathToPage1Sentence2)
		var page1 = global.DialogPage.new([page1line1, page1line2], global.g_PORTRAITS.SHOTGUN)

		var pathToPage2Sentence1 = ["intro_dialog_4", "page2line1"]
		var page2line1 = global.DialogLine.new(pathToPage2Sentence1)
		var pathToPage2Sentence2 = ["intro_dialog_4", "page2line2"]
		var page2line2 = global.DialogLine.new(pathToPage2Sentence2)
		var page2 = global.DialogPage.new([page2line1, page2line2], global.g_PORTRAITS.SHOTGUN)
		
		var pathToPage3Sentence1 = ["intro_dialog_4", "page3line1"]
		var page3line1 = global.DialogLine.new(pathToPage3Sentence1)
		var pathToPage3Sentence2 = ["intro_dialog_4", "page3line2"]
		var page3line2 = global.DialogLine.new(pathToPage3Sentence2)
		var pathToPage3Sentence3 = ["intro_dialog_4", "page3line3"]
		var page3line3 = global.DialogLine.new(pathToPage3Sentence3)
		var page3 = global.DialogPage.new([page3line1, page3line2, page3line3], global.g_PORTRAITS.SHOTGUN)
		
		var pages: Array = [page1, page2, page3]
		dialog_box_bottom.write_pages(pages, global.g_DIALOG_TYPE.INTRO_DIALOG_4)
		dialog_box_bottom.visible = true


func _show_initial_dialog5():
	if (dialog_box_top.has_method("write_pages")):
		var pathToPage1Sentence1 = ["character", "tseng"]
		var page1line1 = global.DialogLine.new(pathToPage1Sentence1)
		var pathToPage1Sentence2 = ["intro_dialog_5", "page1line2"]
		var page1line2 = global.DialogLine.new(pathToPage1Sentence2)
		var pathToPage1Sentence3 = ["intro_dialog_5", "page1line3"]
		var page1line3 = global.DialogLine.new(pathToPage1Sentence3)
		var page1 = global.DialogPage.new([page1line1, page1line2, page1line3], global.g_PORTRAITS.TSENG)
		
		var pathToPage2Sentence1 = ["intro_dialog_5", "page2line1"]
		var page2line1 = global.DialogLine.new(pathToPage2Sentence1)
		var pathToPage2Sentence2 = ["intro_dialog_5", "page2line2"]
		var page2line2 = global.DialogLine.new(pathToPage2Sentence2)
		var pathToPage2Sentence3 = ["intro_dialog_5", "page2line3"]
		var page2line3 = global.DialogLine.new(pathToPage2Sentence3)
		var page2 = global.DialogPage.new([page2line1, page2line2, page2line3], global.g_PORTRAITS.TSENG)

		var pathToPage3Sentence1 = ["intro_dialog_5", "page3line1"]
		var page3line1 = global.DialogLine.new(pathToPage3Sentence1)
		var pathToPage3Sentence2 = ["intro_dialog_5", "page3line2"]
		var page3line2 = global.DialogLine.new(pathToPage3Sentence2)
		var pathToPage3Sentence3 = ["intro_dialog_5", "page3line3"]
		var page3line3 = global.DialogLine.new(pathToPage3Sentence3)
		var page3 = global.DialogPage.new([page3line1, page3line2, page3line3], global.g_PORTRAITS.TSENG)
		
		var pathTopage4Sentence1 = ["intro_dialog_5", "page4line1"]
		var page4line1 = global.DialogLine.new(pathTopage4Sentence1)
		var pathTopage4Sentence2 = ["intro_dialog_5", "page4line2"]
		var page4line2 = global.DialogLine.new(pathTopage4Sentence2)
		var pathTopage4Sentence3 = ["intro_dialog_5", "page4line3"]
		var page4line3 = global.DialogLine.new(pathTopage4Sentence3)
		var page4 = global.DialogPage.new([page4line1, page4line2, page4line3], global.g_PORTRAITS.TSENG)
		
		var pathTopage5Sentence1 = ["intro_dialog_5", "page5line1"]
		var page5line1 = global.DialogLine.new(pathTopage5Sentence1)
		var pathTopage5Sentence2 = ["intro_dialog_5", "page5line2"]
		var page5line2 = global.DialogLine.new(pathTopage5Sentence2)
		var page5 = global.DialogPage.new([page5line1, page5line2], global.g_PORTRAITS.TSENG)
		
		var pathTopage6Sentence1 = ["intro_dialog_5", "page6line1"]
		var page6line1 = global.DialogLine.new(pathTopage6Sentence1)
		var pathTopage6Sentence2 = ["intro_dialog_5", "page6line2"]
		var page6line2 = global.DialogLine.new(pathTopage6Sentence2)
		var pathTopage6Sentence3 = ["intro_dialog_5", "page6line3"]
		var page6line3 = global.DialogLine.new(pathTopage6Sentence3)
		var page6 = global.DialogPage.new([page6line1, page6line2, page6line3], global.g_PORTRAITS.TSENG)
		
		var pathTopage7Sentence1 = ["intro_dialog_5", "page7line1"]
		var page7line1 = global.DialogLine.new(pathTopage7Sentence1)
		var pathTopage7Sentence2 = ["intro_dialog_5", "page7line2"]
		var page7line2 = global.DialogLine.new(pathTopage7Sentence2)
		var pathTopage7Sentence3 = ["intro_dialog_5", "page7line3"]
		var page7line3 = global.DialogLine.new(pathTopage7Sentence3)
		var page7 = global.DialogPage.new([page7line1, page7line2, page7line3], global.g_PORTRAITS.TSENG)
		
		var pages: Array = [page1, page2, page3, page4, page5, page6, page7]
		dialog_box_top.write_pages(pages, global.g_DIALOG_TYPE.INTRO_DIALOG_5)
		dialog_box_top.visible = true


func _play_phone_audio():
	if !_has_played_phone_audio:
		_has_played_phone_audio = true
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


func _on_DialogBoxTop_dialog_complete(dialog_type):
#	print("dialog box top complete [", dialog_type, "]")
	if dialog_type == global.g_DIALOG_TYPE.INTRO_DIALOG_1:
		if dialog_box_top.has_method("hide_text_box"):
			dialog_box_top.hide_text_box()
		_show_initial_dialog2()
	if dialog_type == global.g_DIALOG_TYPE.INTRO_DIALOG_3:
		if dialog_box_top.has_method("hide_text_box"):
			dialog_box_top.hide_text_box()
		if dialog_box_bottom.has_method("show_text_box"):
			dialog_box_bottom.show_text_box()
		_show_initial_dialog4()
	if dialog_type == global.g_DIALOG_TYPE.INTRO_DIALOG_5:
		_dialog_finished()
	if dialog_type == global.g_DIALOG_TYPE.AVALANCHE_DIALOG_2:
		if dialog_box_top.has_method("hide_text_box"):
			dialog_box_top.hide_text_box()
		if dialog_box_bottom.has_method("hide_text_box"):
			dialog_box_bottom.hide_text_box()
		dialog_box_top.visible = false
		dialog_box_bottom.visible = false
		_show_avalanche_dialog3()
	if dialog_type == global.g_DIALOG_TYPE.CONFRONTATION_1:
		if dialog_box_top.has_method("hide_text_box"):
			dialog_box_top.hide_text_box()
		_show_confrontation_dialog2()
	if dialog_type == global.g_DIALOG_TYPE.CONFRONTATION_3:
		dialog_box_top.visible = false
		state = STATE.ENEMY1_ENGAGE_PLAYER


func _on_DialogBoxBottom_dialog_complete(dialog_type):
#	print("dialog box bottom complete [", dialog_type, "]")
	if dialog_type == global.g_DIALOG_TYPE.INTRO_DIALOG_2:
		if dialog_box_bottom.has_method("hide_text_box"):
			dialog_box_bottom.hide_text_box()
		if dialog_box_top.has_method("show_text_box"):
			dialog_box_top.show_text_box()
		_show_initial_dialog3()
	if dialog_type == global.g_DIALOG_TYPE.INTRO_DIALOG_4:
		if dialog_box_bottom.has_method("hide_text_box"):
			dialog_box_bottom.hide_text_box()
		if dialog_box_top.has_method("show_text_box"):
			dialog_box_top.show_text_box()
		_show_initial_dialog5()
	if dialog_type == global.g_DIALOG_TYPE.AVALANCHE_DIALOG_1:
		if dialog_box_bottom.has_method("hide_text_box"):
			dialog_box_bottom.hide_text_box()
		if dialog_box_top.has_method("show_text_box"):
			dialog_box_top.show_text_box()
		_show_avalanche_dialog2()
	if dialog_type == global.g_DIALOG_TYPE.AVALANCHE_DIALOG_3:
		dialog_box_bottom.visible = false
		_player_spotted()
	if dialog_type == global.g_DIALOG_TYPE.PLAYER_SPOTTED_DIALOG_1:
		_show_player_spotted_dialog2()
	if dialog_type == global.g_DIALOG_TYPE.PLAYER_SPOTTED_DIALOG_2:
		_confront_player()
	if dialog_type == global.g_DIALOG_TYPE.CONFRONTATION_2:
		if dialog_box_bottom.has_method("hide_text_box"):
			dialog_box_bottom.hide_text_box()
		if dialog_box_top.has_method("show_text_box"):
			dialog_box_top.show_text_box()
		_show_confrontation_dialog3()


func _player_spotted():
	_has_played_phone_audio = false
	_play_phone_audio()
	_camera_after_player_spotted = Vector2(_camera_before_enemy_spotted.x, _camera_before_enemy_spotted.y + 20)
	state = STATE.PAN_CAMERA_TO_PLAYER


func _confront_player():
	if player.has_method("hide_emote"):
		player.hide_emote()
	if enemy1.has_method("hide_emote"):
			enemy1.hide_emote()
	dialog_box_bottom.visible = false
	state = STATE.CONFRONT_PLAYER


func _dialog_finished():
	dialog_box_top.visible = false
	dialog_box_bottom.visible = false
	turks_theme_audio.stop()
	mission_theme_audio.play()
	_enable_actors()


func _on_EnemySpotted_body_entered(body):
	if body.name == player.name:
		if player.has_method("show_emote") && player.has_method("hide_emote"):
			_disable_actors()
			player.show_emote()
			yield(get_tree().create_timer(0.5), "timeout")
			player.hide_emote()
			state = STATE.ENEMY_SPOTTED
