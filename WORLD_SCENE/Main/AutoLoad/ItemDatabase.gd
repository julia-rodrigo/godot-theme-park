extends Node

# this is the code to get all the adventure files 
# from "res://Resource/Adventures/Adventure/"

var items = Array ()

func _ready():
	var directory = Directory.new()
	directory.open("res://WORLD_SCENE/Main/Item/ItemRepository/") 
	directory.list_dir_begin () 
	
	var filename = directory.get_next()
	while (filename):
		if not directory.current_is_dir():
			items.append(load("res://WORLD_SCENE/Main/Item/ItemRepository/%s" % filename))
		filename = directory.get_next()
		
# check if the item exists

func get_item (item_name):
	for i in items:
		if i.name == item_name:
			return i
		
	return null
