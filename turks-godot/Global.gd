extends Node

var g_strings: Dictionary = {
	"battle": {
		"blizzara_exp_points": {
			"en": "Blizzara exp. points      %d",
			"jp": "ブリザラ 経験値   %d"
		},
		"exp_point": {
			"en": "Experience point            %d",
			"jp": "經驗値            %d"
		},
		"obtained": {
			"en": "obtained",
			"jp": "を入手しました"
		},
		"avalanche_soldier": {
			"en": "avalanche soldier         LV %d",
			"jp": "アバランチ兵            LV %d"
		},
		"materia_comet": {
			"en": "Comet Lv %d",
			"jp": "コメットLv %d"
		},
		"materia_thunder": {
			"en": "Thunder Lv %d",
			"jp": "サンダーLv %d"
		},
		"materia_curaga": {
			"en": "Curaga Lv %d",
			"jp": "ケアルガLv %d"
		},
		"materia_blizzara": {
			"en": "Blizzara Lv %d",
			"jp": "ブリザラLv %d"
		},
		"materia_support": {
			"en": "Materia Support",
			"jp": "マテリア援護"
		},
		"materia_spend": {
			"en": "Spend %d MP",
			"jp": "消費MP %d"
		}
	}
}

var g_settings: Dictionary = {
	"lang": "en"
}

enum g_DIALOG_TYPE {
	UNKNOWN,
	BATTLE_INIT_ENEMY,
	BATTLE_PLAYER_EXP
}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


class DialogLine:
	var PathToSentence: Array
	var FormatSentence: Array
	
	func _init(pathToSentence: Array, formatSentence: Array = []):
		PathToSentence = pathToSentence
		FormatSentence = formatSentence


class DialogPage:
	var Lines: Array
	
	func _init(lines: Array):
		Lines = lines

