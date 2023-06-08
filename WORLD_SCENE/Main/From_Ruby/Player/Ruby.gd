extends KinematicBody
#onready var save_file = SaveFile.g_data
# move and slide
# https://www.youtube.com/watch?v=a0gxFMdhR7w

# information for the player sprite

var velocity = Vector3(0, 0, 0);
var gravity = 5;

const SPEED = 2;
var idelName = Global.idelName if Global.idelName != null else "IdelFront"
var moving = true

var hp = 60
var mana = 69
var dmg = 69

var direction = Vector3(0, 0, 0)
var automove_run_sprite = idelName
var state = MOVE

enum {
	MOVE, 
	AUTOMOVE
}


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

var OppositeDirections = {
	"RunFrontRight": "RunFrontLeft",
	"RunFrontLeft": "RunFrontRight",
	"IdelFrontLeft": "IdelFrontRight",
	"IdelFrontRight": "IdelFrontLeft",	
	"IdelBack": "IdelFront",
	"IdelFront": "IdelBack",	
	"RunFront": "RunBack",
	"RunBack": "RunFront"	
}

func _ready():
	get_node(idelName).show()
	
	pass
	
#	get_node("IdelFrontLeft").hide();
func hideNode(name):
	get_node(name).hide();	

func showNode(name):
	get_node(name).show();	
	
func viewingSprite(hideSprite, showSprite) -> String:
	
	hideNode(hideSprite);
	showNode(showSprite);
	return showSprite;


func _physics_process(delta):
	match (state):
		MOVE:
			move_state(delta)
		AUTOMOVE:
			auto_move_state()
	#		$AnimationPlayer.set("parameters/Idle/blend_position", velocity);
	

func move_state(_delta):
	if Player.move:
		if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
			velocity.x = 0;
			idelName = viewingSprite(idelName, RunToIdel[idelName])
		elif Input.is_action_pressed("ui_right"):
			velocity.x = -SPEED;
			idelName = viewingSprite(idelName, "RunFrontRight");
			
			direction = velocity
			automove_run_sprite = idelName
			
#			print("right: ", direction)
			
		elif Input.is_action_pressed("ui_left"):
			velocity.x = SPEED;
			idelName = viewingSprite(idelName, "RunFrontLeft");
			
			
			direction = velocity
			automove_run_sprite = idelName
#			print("left: ", direction)
			
		else: 
			velocity.x = lerp(velocity.x, 0, 1);
			idelName = viewingSprite(idelName, RunToIdel[idelName]) # only add transition change here
			
		if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_down"):
			velocity.z = 0;
			
		elif Input.is_action_pressed("ui_up"):
			velocity.z = SPEED;
			idelName = viewingSprite(idelName, "RunBack");	
			
			direction = velocity
			automove_run_sprite = idelName
#			print("up: ", direction)		
			
		elif Input.is_action_pressed("ui_down"):
			velocity.z = -SPEED;
			idelName = viewingSprite(idelName, "RunFront");	
			
			direction = velocity
#			automove_run_sprite = idelName
#			print("down: ", direction)		
		else: 
			velocity.z = lerp(velocity.z, 0, 1);
			
			
		
		if not is_on_floor():
			velocity.y = -gravity;
		else:
			idelName = viewingSprite(idelName, RunToIdel[idelName])
		
	#	var snap = Vector3.DOWN
	#	move_and_slide_with_snap(velocity, snap, Vector3.UP, true, 3, deg2rad(30)) # move the character
	#	move_and_slide_with_snap(velocity, Vector3.UP)
		
		move()
		
	else:
		velocity.x = lerp(velocity.x, 0, 1);
		idelName = viewingSprite(idelName, RunToIdel[idelName])
		
		
func move():
	velocity = move_and_slide(velocity)
	
func auto_move ():
	get_node("Timer").start()
	direction = Global.auto_move_direction
	automove_run_sprite = Global.auto_move_run_sprite
	state = AUTOMOVE
	
func auto_move_state():
	velocity = Global.auto_move_direction
	idelName = viewingSprite(idelName, Global.auto_move_run_sprite)
	move()

func _on_Timer_timeout():
	idelName = viewingSprite(idelName, RunToIdel[idelName])
	state = MOVE
	Player.move = true
	
#func get_save_stats():
#	return {
#		'filename' : get_filename(),
#		'parent' : get_parent().get_path(),
#		'x_pos' : global_transform.origin.x,
#		'y_pos' : global_transform.origin.y,
#		'z_pos' : global_transform.origin.z,
#		'stats' : {
#			'hp' : hp,
#			'mana' : mana,
#			'dmg' : dmg
#		}
#
#	}
#
#func load_save_state(stats):
#	global_transform.origin = Vector3(stats.x_pos, stats.y_pos, stats.z_pos)
#	hp = stats.stats.hp
#	mana = stats.stats.mana
#	dmg = stats.stats.dmg

