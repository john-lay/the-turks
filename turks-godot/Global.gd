extends Node

const g_DISPLAY_PLAYER_NAME = "DISPLAY_PLAYER_NAME"

var g_colors: Dictionary = {
	"turquoise": Color("66ffff"),
	"pink": Color("b41f76")
}

var g_strings: Dictionary = {
	"battle": {
		"thunder_exp_points": {
			"en": "Thunder exp. points      %d",
			"jp": "サンダー 経験値   %d"
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
	"character": {
		"shotgun": {
			"en": "[Shotgun]",
			"jp": "【シオン】",
			"color": g_colors["turquoise"]
		},
		"tseng": {
			"en": "[Tseng]",
			"jp": "【シォン】",
			"color": g_colors["turquoise"]
		}
	},
	"combat_tutorial": {
		# page1line1 = ["character"]["shotgun"]
		"page1line2": {
			"en": g_DISPLAY_PLAYER_NAME,
			"jp": g_DISPLAY_PLAYER_NAME
		},
		"page1line3": {
			"en": "What's going on?",
			"jp": "どうした?"
		},
		"page2line1": {
			"en": "Why are you engaging",
			"jp": "なぜ、"
		},
		"page2line2": {
			"en": "in battle?",
			"jp": "戦闘をしている?"
		},
		"page3line1": {
			"en": "You do know how to fight, \ndon't you?",
			"jp": "戦闘方法を教える"
		},
		"interested": {
			"en": "No, teach me",
			"jp": "聞きたいわ"
		},
		"not_interested": {
			"en": "I already know",
			"jp": "興味なしです"
		},
		"page4line1": {
			"en": "If you bump into someone",
			"jp": "敵意を持つ奴と"
		},
		"page4line2": {
			"en": "hostile, combat will begin.",
			"jp": "ぶつかると戦闘開始だ"
		},
		"page5line1": {
			"en": "Press the Enter key",
			"jp": "キーを押し続ける",
			"color": g_colors["pink"]
		},
		"page5line2": {
			"en": "to attack the enemy",
			"jp": "自動的に敵を追って"
		},
		"page5line3": {
			"en": "",
			"jp": "攻撃する"
		},
		"page6line1": {
			"en": "Be careful out there.",
			"jp": "慎重に行け"
		},
	},
	"overworld_menu": {
		"status": {
			"en": "Status",
			"jp": "ステータス"
		},
		"item": {
			"en": "Item",
			"jp": "アイテム"
		},
		"materia_equipment": {
			"en": "Materia Equip.",
			"jp": "マテリア装備"
		},
		"member_list": {
			"en": "Member List",
			"jp": "メンバーリスト"
		},
		"options": {
			"en": "Options",
			"jp": "オプション"
		},
		"return_to_hq": {
			"en": "Return to HQ",
			"jp": "本部に戻る"
		}
	},
	"intro_dialog_1": {
		# page1line1 = ["character"]["tseng"]
		"page1line2": {
			"en": "These are your orders.",
			"jp": "任務だ"
		},
		"page1line3": {
			"en": "You're to patrol Sector 8.",
			"jp": "八番街の警備にあたれ"
		},
		"page2line1": {
			"en": "This is standard work",
			"jp": "タークスの初仕事は"
		},
		"page2line2": {
			"en": "for all new Turks.",
			"jp": "八番街の警備"
		},
		"page3line1": {
			"en": "It's company tradition.",
			"jp": "これが我々の伝統だ"
		},
		"page4line1": {
			"en": "Your seniors Reno, Rude",
			"jp": "先輩のレノやルード、"
		},
		"page4line2": {
			"en": "and even I started off",
			"jp": "もちろん私も"
		},
		"page4line3": {
			"en": "with this work.",
			"jp": "この仕事から始まった"
		},
	},
	"intro_dialog_2": {
		# page1line1 = ["character"]["shotgun"]
		"page1line2": {
			"en": "Understood.",
			"jp": "了解しました"
		},
		"page2line1": {
			"en": "I'll bring down all",
			"jp": "怪しい奴は"
		},
		"page2line2": {
			"en": "suspicious characters.",
			"jp": "私が すべて"
		},
		"page2line3": {
			"en": "",
			"jp": "仕留めるわ"
		},
	},
	"intro_dialog_3": {
		# page1line1 = ["character"]["tseng"]
		"page1line2": {
			"en": "There's no need to",
			"jp": "そう力むな"
		},
		"page1line3": {
			"en": "go that far.",
			"jp": ""
		},
		"page2line1": {
			"en": "The war is over and",
			"jp": "戦争も終わり、"
		},
		"page2line2": {
			"en": "the city is at peace,",
			"jp": "街は平和になったから"
		},
		"page2line3": {
			"en": "so I doubt you'll run into",
			"jp": "特に問題はないと思う"
		},
		"page3line1": {
			"en": "any big problems.",
			"jp": "仕事に慣れるつもりで"
		},
		"page3line2": {
			"en": "This job should get you",
			"jp": "任務にあたれ"
		},
		"page3line3": {
			"en": "used to your future duties.",
			"jp": ""
		},
	},
	"intro_dialog_4": {
		# page1line1 = ["character"]["shotgun"]
		"page1line2": {
			"en": "That's too bad",
			"jp": "残念"
		},
		"page2line1": {
			"en": "Sounds like it's going to",
			"jp": "退屈そうね"
		},
		"page2line2": {
			"en": "be boring.",
			"jp": ""
		},
		"page3line1": {
			"en": "Well, I guess that's the",
			"jp": "まあ、 初任務だし"
		},
		"page3line2": {
			"en": "sort of work your start",
			"jp": "こんなものかしら"
		},
		"page3line3": {
			"en": "off with.",
			"jp": ""
		},
	},
	"intro_dialog_5": {
		# page1line1 = ["character"]["tseng"]
		"page1line2": {
			"en": "Before you start",
			"jp": "任務開始の前に"
		},
		"page1line3": {
			"en": "working,",
			"jp": ""
		},
		"page2line1": {
			"en": "make sure you've got",
			"jp": "マテリア装備の確認を"
		},
		"page2line2": {
			"en": "some Materia on you.",
			"jp": "しておけ"
		},
		"page2line3": {
			"en": "If you don't already",
			"jp": ""
		},
		"page3line1": {
			"en": "have some, return to",
			"jp": "装備していないならば"
		},
		"page3line2": {
			"en": "headquarters and get",
			"jp": "本部に戻って"
		},
		"page3line3": {
			"en": "some ready.",
			"jp": "装備した方がいしま"
		},
		"page4line1": {
			"en": "Select Materia Creation",
			"jp": "部メニューから"
		},
		"page4line2": {
			"en": "from the HQ menu.",
			"jp": "【コテリア生活】を"
		},
		"page4line3": {
			"en": "You can create Materia",
			"jp": "選択すると"
		},
		"page5line1": {
			"en": "that way. If you've got",
			"jp": "マテリアを"
		},
		"page5line2": {
			"en": "Materia,",
			"jp": "生成できる"
		},
		"page6line1": {
			"en": "you can use magic",
			"jp": "マテリアを装備すれば"
		},
		"page6line2": {
			"en": "when you're in battles.",
			"jp": "戦闘中に魔法が使える"
		},
		"page6line3": {
			"en": "If you use magic,",
			"jp": ""
		},
		"page7line1": {
			"en": "battles will become a",
			"jp": "魔法を使うと"
		},
		"page7line2": {
			"en": "lot easier for you.",
			"jp": "戦闘が有利になる"
		},
		"page7line3": {
			"en": "Make use of it.",
			"jp": "活用しろ"
		},
	},
	"avalanche_dialog_1": {
		"page1line1": {
			"en": "The long awaited day",
			"jp": "神羅 (しんら) への"
		},
		"page1line2": {
			"en": "of Shinra's downfall",
			"jp": "積年の恨みを"
		},
		"page1line3": {
			"en": "is in sight.",
			"jp": "晴らすときが来た"
		},
		"page2line1": {
			"en": "Don't mess up now.",
			"jp": "しくじるな"
		},
		"page3line1": {
			"en": "Down with the Shinra!",
			"jp": "神羅(しんら) に"
		},
		"page3line2": {
			"en": "",
			"jp": "裁きを!"
		},
	},
	"avalanche_dialog_2": {
		"page1line1": {
			"en": "Down with the Shinra!",
			"jp": "神羅(しんら) に"
		},
		"page1line2": {
			"en": "",
			"jp": "裁きを!"
		},
	},
	"avalanche_dialog_3": {
		# page1line1 = ["character"]["shotgun"]
		"page1line2": {
			"en": "I smell something big!",
			"jp": "事件の匂い!"
		},
		"page2line1": {
			"en": "It's finally getting",
			"jp": "やっと"
		},
		"page2line2": {
			"en": "interesting.",
			"jp": "おもしろく"
		},
		"page2line3": {
			"en": "",
			"jp": "なってきたわ"
		},
	},
	"player_spotted_1": {
		"page1line1": {
			"en": "Who's there!?",
			"jp": "誰だ!?"
		},
	},
	"player_spotted_2": {
		# page1line1 = ["character"]["shotgun"]
		"page1line2": {
			"en": "No way.",
			"jp": "うそ"
		},
		"page2line1": {
			"en": "They spotted me?",
			"jp": "見つかった?"
		},
	},
	"confrontation_1": {
		"page1line1": {
			"en": "That uniform...",
			"jp": "その制服は・・・"
		},
		"page2line1": {
			"en": "The Shinra Company's",
			"jp": "神羅(しんら)の"
		},
		"page2line2": {
			"en": "Turks!?",
			"jp": "タークス!?"
		},
	},
	"confrontation_2": {
		# page1line1 = ["character"]["shotgun"]
		"page1line2": {
			"en": "You have a problem",
			"jp": "それが何か問題でも?"
		},
		"page1line3": {
			"en": "with that?",
			"jp": ""
		},
	},
	"confrontation_3": {
		"page1line1": {
			"en": "Since you overheard",
			"jp": "計画を開かれちゃ"
		},
		"page1line2": {
			"en": "our plans, we'll have",
			"jp": "死んでもらうしかない!"
		},
		"page1line3": {
			"en": "to get rid of you!",
			"jp": ""
		},
	},
}

var g_settings: Dictionary = {
	"lang": "en", # jp
	"player_name": "エレン" # Ellen
}

enum g_ORDINAL {
	UNKNOWN,
	FIRST,
	SECOND,
}

enum g_DIALOG_TYPE {
	UNKNOWN,
	BATTLE_INIT_ENEMY,
	BATTLE_PLAYER_EXP,
	BATTLE_COMBAT_TUTORIAL,
	BATTLE_MORE_COMBAT_TUTORIAL,
	INTRO_DIALOG_1,
	INTRO_DIALOG_2,
	INTRO_DIALOG_3,
	INTRO_DIALOG_4,
	INTRO_DIALOG_5,
	AVALANCHE_DIALOG_1,
	AVALANCHE_DIALOG_2,
	AVALANCHE_DIALOG_3,
	PLAYER_SPOTTED_DIALOG_1,
	PLAYER_SPOTTED_DIALOG_2,
	CONFRONTATION_1,
	CONFRONTATION_2,
	CONFRONTATION_3,
}

enum g_PORTRAITS {
	UNKNOWN,
	TSENG,
	SHOTGUN,
	AVALANCHE
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

