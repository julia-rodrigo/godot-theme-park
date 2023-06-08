extends Control

signal dialogue_ended # emit signal and signal sounded in this script. go to another scrips
# and continue after this signal

var name_of_character = "YO PLAYER"
var dialogue = [
	"Hello Player",
	"Welcome to the game",
	"xD"
]

onready var character_name = $outer/Panel/inner/list/name
onready var message = $outer/Panel/inner/list/message
onready var tween = $outer/Panel/Tween
onready var continue_label = $outer/Panel/inner/list/continue

var dialogue_index = 0
var finished = false


func _ready():
	Player.at_conversation = true
	character_name.text = name_of_character
	load_dialogue()
	
func _process(_delta):
	continue_label.visible = finished
	Player.move = false
	
	if Input.is_action_just_pressed("ui_accept"):
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
		Player.move = true	
		emit_signal("dialogue_ended")
		Player.at_conversation = false
		queue_free()
	
	dialogue_index += 1


func _on_Tween_tween_completed(_object, _key):
	finished = true
	


func _on_Panel_pressed():
	print("click: ", name_of_character)
	load_dialogue()
