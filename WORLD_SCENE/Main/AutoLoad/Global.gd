extends Node

var idelName
var help_preferences = true
var disable_keyboard_options = false
	
var shopkeeper_updated_merchandise

# get the saved resources path of the game system
var inventory_save_path = "res://WORLD_SCENE/Main/SAVED_GAME_FILES/inventory.tres"
var photo_log_save_path = "res://WORLD_SCENE/Main/SAVED_GAME_FILES/photo_log.tres"

# get ready a the player initialise signal 
signal player_initialised

# this is the player body
var player

#var current_scene_name = "WorldNonVr"
var current_scene_name = "HalfWorldMap"
#var current_scene_name = "Test"
#var current_scene_name = "Android"



func _process(_delta):
	
	# check if a player exists
	if not player:
		print("player initialised")
		initialise_player ()
		return

# for making sure there are no errors once the scene changes
func disconnect_player():
	Player.inventory.disconnect("inventory_changed", self, "_on_player_inventory_changed")
	Player.photo_log.disconnect("photo_log_changed", self, "_on_player_photo_log_changed")
	
	player = null

# when the scene changes emit a player initialisation to connect all the functions below	
func initialise_player():
	player = get_tree().get_root().get_node("/root/" + current_scene_name + "/Ruby")
	
	emit_signal("player_initialised", player)
	
	Player.inventory.connect("inventory_changed", self, "_on_player_inventory_changed")
	Player.photo_log.connect("photo_log_changed", self, "_on_player_photo_log_changed")
	
	
	var directory = Directory.new();
	
	var existing_inventory = directory.file_exists(inventory_save_path)
	var existing_photo_log = directory.file_exists(photo_log_save_path)
	

	if existing_inventory:
		existing_inventory = load(inventory_save_path)
#		print("Existing items: ", existing_inventory.get_items())
		Player.inventory.set_items(existing_inventory.get_items()) # GET ITEMS WITH AN 'S'
		print("an inventory exists")
	else:
		# lets give the player 3 pieces of apple
		Player.inventory.add_item("Bright Red Apple", 10)
		print("no inventory exists...")
		
	if existing_photo_log:
		existing_photo_log = load(photo_log_save_path)
		Player.photo_log.set_photos(existing_photo_log.get_photos()) # GET ITEMS WITH AN 'S'

#		print("first creature attacks: ", Player.creaventory.get_creatures()[1].available_attacks)
		print("a photo_log exists")

	else:
		# lets give the player 3 pieces of apple
#		Player.creaventory.add_creature("Feet")
#		Player.creaventory.add_creature_found(Player.randomFinder.find_random_creature(Global.creature_encounter_list).resource)
		print("no photo_log yet..")
		
func _on_player_inventory_changed(inventory):
	var _not_in_use = ResourceSaver.save(inventory_save_path, inventory)
#
func _on_player_photo_log_changed(photo_log):
#	print("creaventory saved: ", Player.creaventory.get_creatures())
	var _not_in_use = ResourceSaver.save(photo_log_save_path, photo_log)

