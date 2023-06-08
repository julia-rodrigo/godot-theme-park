extends Node

var money = 800
var move = true
var at_shop = false
var at_conversation = false

var selected_item 
var selected_item_position = 0
var shop_item
var shop_item_position = 0


# load the save files from the directories and intialise a new file
var inventory_resource = load ("res://WORLD_SCENE/Main/Resource/Inventory/Inventory.gd")
var inventory = inventory_resource.new()

var photo_log_resource = load ("res://WORLD_SCENE/Main/Resource/PhotoLog/PhotoLog.gd")
var photo_log = photo_log_resource.new()
