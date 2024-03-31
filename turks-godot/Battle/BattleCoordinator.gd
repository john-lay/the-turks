extends Node2D

# Declare member variables here. Examples:
onready var player = $player
onready var enemy = $enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	enable_player_attack()

func enable_player_attack():
	if (player.has_method("enable_attack")):
		player.enable_attack()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_enemy_request_player_position():
	if (enemy.has_method("player_position_received")):
		enemy.player_position_received(player.position)
