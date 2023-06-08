extends KinematicBody

#onready var save_file = SaveFile.g_data
# move and slide
# https://www.youtube.com/watch?v=a0gxFMdhR7w
onready var conversation_area = $ConversationArea
onready var dialogue_box = preload("res://WORLD_SCENE/Main/From_Ruby/NPC/NPCInteractions/NPCDialogues/DialogueBox.tscn").instance()

onready var velocity = Vector3(0, 0, 0);
onready var gravity = 5;
onready var timer = $Timer
const SPEED = 1.3;

export (String) var character_name = "No name"

export (Array, String) var message = [
	"oh this is a message", "um yeah"
]

export (Array, String) var after_buy = [
	"Thank you!"
]

export (Array, String) var see_you = [
	"later!"
]

export (String) var talk_to_me = "Hi there"
export (bool) var stay_still = false

export (Resource) var held_item

export (bool) var shopkeeper = false
export (bool) var buyer = false
export (String) var shop_name = "This is a shop name"

export (Array, Resource) var items_to_buy = [ { "name": "[this item has no name: DEFAULT VAL]" } ]

var idelName = "IdelFront"
var moving = true

var RunToIdel = {
	"RunFrontRight": "IdelFrontRight",
	"RunFrontLeft": "IdelFrontLeft",
	"IdelFrontLeft": "IdelFrontLeft",
	"IdelFrontRight": "IdelFrontRight",	
	"IdelBack": "IdelBack",
	"IdelFront": "IdelFront",	
	"RunFront": "IdelFront",
	"RunBack": "IdelBack"	
}


var limit = 1
var start_position 

#	get_node("IdelFrontLeft").hide();
func hideNode(name):
	get_node(name).hide();	

func showNode(name):
	get_node(name).show();	
	
func viewingSprite(hideSprite, showSprite) -> String:
	
	hideNode(hideSprite);
	showNode(showSprite);
	return showSprite;
	
	
var DIRECTION = [ "RunFrontRight", "RunFrontLeft", "RunFront", "RunBack" ]
var NEW_IDEL_POS = [ "IdelFrontRight", "IdelFrontLeft", "IdelFront", "IdelBack" ]

var current_move 
var current_direction

func choose (array):
	return array[randi() % array.size()]
	
enum {
	IDEL,
	NEW_DIRECTION,
	MOVE
}

func _ready():
#	print("here with ", character_name)
	
	conversation_area.character_name = character_name
	conversation_area.message = message
	conversation_area.talk_panel.get_node("inner/separate/press").text = talk_to_me
	
	conversation_area.shopkeeper = shopkeeper
	conversation_area.items_to_buy = items_to_buy
	conversation_area.shop_name = shop_name
	
	
	start_position = velocity
	
	get_node(idelName).show()
	if not is_on_floor():
		velocity.y = -gravity;
		velocity = move_and_slide(velocity)	
	
	current_move = choose ([IDEL])
	choose_move()
	$Timer.wait_time = 0.05
	
#	$Timer.stop() # to stop the NPC

func _on_Timer_timeout():
	if stay_still:
		moving = false
		current_move = choose ([IDEL, NEW_DIRECTION])
		$Timer.wait_time = choose([1, 1.5])

		
	else:
		if current_move == MOVE:
			$Timer.wait_time = choose([1, 1.5])
			current_move = choose ([IDEL, NEW_DIRECTION])
			
		if current_move == NEW_DIRECTION:
			
			current_move = choose ([MOVE, IDEL])
			
			if current_move == IDEL:
				$Timer.wait_time = choose([1, 1.5])
			else:
				$Timer.wait_time = choose([0.5])
			
		elif current_move == IDEL:
			current_move = choose ([NEW_DIRECTION])
			$Timer.wait_time = choose([0.5])
		
	choose_move()
	

func choose_move ():
	match current_move:
		IDEL:
			idelName = viewingSprite(idelName, RunToIdel[idelName])	
			moving = false	
			pass
		NEW_DIRECTION:
			idelName = viewingSprite(idelName, choose(NEW_IDEL_POS))
			moving = false
		MOVE:
			moving = true
			idelName = viewingSprite(idelName, choose(DIRECTION))			
	
func _process(_delta):
	if moving:
#		print ("start: ",  velocity )
		
		if idelName == "RunFrontRight":
			velocity.x = -SPEED;
			idelName = viewingSprite(idelName, "RunFrontRight");
			current_direction = idelName
			
		elif idelName == "RunFrontLeft":
			velocity.x = SPEED;
			idelName = viewingSprite(idelName, "RunFrontLeft");
			current_direction = idelName
			
		elif idelName == "RunBack":
			velocity.z = SPEED;
			idelName = viewingSprite(idelName, "RunBack");	
			current_direction = idelName
					
		elif idelName == "RunFront":
			velocity.z = -SPEED;
			idelName = viewingSprite(idelName, "RunFront");		
			current_direction = idelName
				
		else: 
			velocity = Vector3(lerp(velocity.x, 0, 1), 0, lerp(velocity.z, 0, 1))
		
		if not is_on_floor():
			velocity.y = -gravity;
		else:
			idelName = viewingSprite(idelName, RunToIdel[idelName])
		
		velocity = move_and_slide(velocity)
	else:
		velocity = Vector3(lerp(velocity.x, 0, 1), 0, lerp(velocity.z, 0, 1))
		
		idelName = viewingSprite(idelName, RunToIdel[idelName])
		

func _on_ConversationArea_body_entered(body):
#	print(body.name)
	if body.name == "Ruby":
		moving = false
		timer.stop()


func _on_ConversationArea_body_exited(body):
#	print(body.name)
	if body.name == "Ruby":
		moving = true
		timer.start()
