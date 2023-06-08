extends Button

#signal shopkeeper_dialogue_ended
var shopkeeper_name = "YO PLAYER"
var dialogue = [
	"Hello Player",
	"Welcome to the game",
	"xD"
]

onready var character_name = $inner/list/name
onready var message = $inner/list/message
onready var tween = $Tween
onready var continue_label = $inner/list/continue

var dialogue_index = 0
var finished = false

var dialogue_finished = false

func _ready():
	Player.at_conversation = true
	character_name.text = shopkeeper_name
	load_dialogue()
	
func _process(_delta):
	continue_label.visible = finished

	if Input.is_action_just_pressed("ui_accept") and !dialogue_finished:
		load_dialogue()

func load_dialogue():
	if dialogue_index < dialogue.size():
		finished = false
		message.bbcode_text = dialogue[dialogue_index]
		message.percent_visible = 0
		tween.interpolate_property(
			message, "percent_visible", 0, 1, 1, 
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		tween.start()
	else:
#		emit_signal("shopkeeper_dialogue_ended")
		dialogue_finished = true
		
	dialogue_index += 1


func _on_Tween_tween_completed(_object, _key):
	finished = true

func _on_ShopkeeperDialogue_pressed():
	print("SHOPKEEPER PRESSED")
	load_dialogue()
