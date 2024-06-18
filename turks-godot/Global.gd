extends Node

const g_DISPLAY_PLAYER_NAME = "DISPLAY_PLAYER_NAME"

var g_colors: Dictionary = {
	"turquoise": Color("66ffff"),
	"pink": Color("b41f76")
}

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
	},
	"combat_tutorial": {
		"shotgun": {
			"en": "[Shotgun]",
			"jp": "【シオン】",
			"color": g_colors["turquoise"]
		},
		"page1line2": {
			"en": "DISPLAY_PLAYER_NAME",
			"jp": "DISPLAY_PLAYER_NAME"
		},
		"page1line3": {
			"en": "What's wrong?",
			"jp": "どうした?"
		},
		"page2line1": {
			"en": "Why are you fighting?",
			"jp": "なぜ、"
		},
		"page2line2": {
			"en": "",
			"jp": "戦闘をしている?"
		},
		"page3line1": {
			"en": "Learn how to fight?",
			"jp": "戦闘方法を教える"
		},
		"interested": {
			"en": "I want to hear it",
			"jp": "聞きたいわ"
		},
		"not_interested": {
			"en": "I'm not interested",
			"jp": "興味なしです"
		},
		"page4line1": {
			"en": "If you bump into someone hostile,",
			"jp": "敵意を持つ奴と"
		},
		"page4line2": {
			"en": "combat will begin.",
			"jp": "ぶつかると戦闘開始だ"
		},
		"page5line1": {
			"en": "Hold down a key",
			"jp": "キーを押し続ける"
		},
		"page5line2": {
			"en": "to automatically track",
			"jp": "自動的に敵を追って"
		},
		"page5line3": {
			"en": "and attack enemies.",
			"jp": "攻撃する"
		},
		"page6line1": {
			"en": "Proceed with caution.",
			"jp": "慎重に行け"
		},
	}
}

var g_settings: Dictionary = {
	"lang": "en",
	"player_name": "エレン" # Ellen
}

enum g_DIALOG_TYPE {
	UNKNOWN,
	BATTLE_INIT_ENEMY,
	BATTLE_PLAYER_EXP,
	BATTLE_COMBAT_TUTORIAL
}

enum g_PORTRAITS {
	UNKNOWN,
	TSUNG
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
	var Colour: Color
	
	func _init(pathToSentence: Array, formatSentence: Array = []):
		PathToSentence = pathToSentence
		FormatSentence = formatSentence


class DialogPage:
	var Lines: Array
	var Portrait: int
	
	func _init(lines: Array, portrait: int = g_PORTRAITS.UNKNOWN):
		Lines = lines
		Portrait = portrait


class DialogHeading:
	var Text: String
	var Colour: Color
	
	func _init(text: String, colour: Color):
		Text = text
		Colour = colour

