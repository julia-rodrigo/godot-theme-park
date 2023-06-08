extends Area

onready var dialogue_box = preload("res://WORLD_SCENE/Main/From_Ruby/NPC/NPCInteractions/NPCDialogues/DialogueBox.tscn").instance()
onready var character_name_label = dialogue_box.get_node("outer/Panel/inner/list/name")
onready var conversation_button = $MarginContainer/VBoxContainer/EnterConversationButton

onready var shop_area = preload("res://WORLD_SCENE/Main/Shop/ShopArea.tscn").instance()

onready var talk_panel = $MarginContainer/VBoxContainer/center/TalkToMe

var character_name = "NO CHARACTER NAME!"
var message = [ "NO MESSEAGES EITHER", "oops", "I WONDER WHY"]
var talk_to_me = "interact"

var can_interact = false
var player_body 

var shopkeeper
var items_to_buy = []
var shop_name

func _ready():
	talk_panel.get_node("inner/separate/press").text = talk_to_me
	talk_panel.hide()
	conversation_button.hide()
	conversation_button.disabled = true

func _on_ConversationArea_body_entered(body):
#	print(body.name)
	
	if body.name == 'Ruby':
		player_body = body 
		talk_panel.show()
		conversation_button.show()
		conversation_button.disabled = false
		can_interact = true

func _on_ConversationArea_body_exited(body):
#	print(body.name)
	
	if body.name == 'Ruby':
		talk_panel.hide()
		conversation_button.hide()		
		conversation_button.disabled = true
		
		can_interact = false

func _unhandled_input(_event):
	if Input.is_key_pressed(KEY_W) and can_interact and Player.move:
		start_conversation()
		

func start_conversation():
	if shopkeeper and items_to_buy.size() == 0:
		dialogue_box.dialogue = ['Thanks to you, I got everything sold!', 'Really appreciate it man xD']
		dialogue_box.name_of_character = character_name
		add_child(dialogue_box)
		dialogue_box = preload("res://WORLD_SCENE/Main/From_Ruby/NPC/NPCInteractions/NPCDialogues/DialogueBox.tscn").instance()
		return
			
	dialogue_box.dialogue = message
	dialogue_box.name_of_character = character_name
	add_child(dialogue_box)

	dialogue_box.connect("dialogue_ended", self, "_finished_conversation")
	dialogue_box = preload("res://WORLD_SCENE/Main/From_Ruby/NPC/NPCInteractions/NPCDialogues/DialogueBox.tscn").instance()

func _finished_shopping ():
#	print("\nShopping with " + character_name + " finished")
	
	dialogue_box.dialogue = [ "See you again :D"]
	dialogue_box.name_of_character = character_name
	
	items_to_buy = Global.shopkeeper_updated_merchandise
	
	add_child(dialogue_box)
	
	dialogue_box.connect("dialogue_ended", self, "move_again")
	dialogue_box = preload("res://WORLD_SCENE/Main/From_Ruby/NPC/NPCInteractions/NPCDialogues/DialogueBox.tscn").instance()

func move_again():
	Player.move = true

func _finished_conversation ():
#	print("\nconversation with " + character_name + " finished")
	if shopkeeper:
		Player.move = false
		Global.shopkeeper_updated_merchandise = items_to_buy
		
		shop_area.dialogue = message
		shop_area.merchandise = items_to_buy
		shop_area.shopkeeper_name = character_name
		shop_area.shop_name = shop_name
		
		add_child(shop_area)
		shop_area.connect("shopping_ended", self, "_finished_shopping")
		shop_area = preload("res://WORLD_SCENE/Main/Shop/ShopArea.tscn").instance()

func _on_EnterConversationButton_pressed():
	if can_interact and Player.move:
#		print(character_name, "...BUTTTON PRESSED")
		start_conversation()
