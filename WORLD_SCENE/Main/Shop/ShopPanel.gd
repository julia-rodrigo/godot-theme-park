extends Panel

onready var newItem = preload("res://WORLD_SCENE/Main/From_Ruby/Menu/ItemPanel/ItemListElement.tscn").instance()
onready var item_name_button = newItem.get_node("item/name")
onready var item_info_label = newItem.get_node("item/details/info")

onready var item_list = $outerMargin/innerVbox/ContentMargin/SeparateMargin/Body/ScrollLeft/ItemList
var position = 0
var merchandise

onready var item_tags = $outerMargin/innerVbox/ContentMargin/SeparateMargin/Body/ScrollContainer/ItemList/information/panel/container/tags
onready var item_selected_name = item_tags.get_node("name")
onready var item_selected_cost = item_tags.get_node("cost")
onready var item_selected_description = item_tags.get_node("description")
onready var item_selected_buy_button = item_tags.get_node("input/details")

onready var amount_own = item_tags.get_node("input/details/owned")

signal item_bought # emit signal item_bought

func _process(_delta):
	if Player.selected_item != null:
		item_selected_name.text = Player.selected_item.name
		item_selected_cost.text = "Cost: $ %d.00" % Player.selected_item.buying_cost
		item_selected_description.text = Player.selected_item.description
		
	elif Player.inventory.get_size() > 0:
		Player.selected_item = Player.inventory.get_item(0).item_reference
		Player.selected_item_position = 0
	else:
		item_selected_name.text = "You have an empty bag"
		item_selected_description.text = "You dont have anything in your bag. It would be nice to buy something rn since we are in a festival. Go ahead and talk to the people around you. You can buy soemthings at the stand"
		
func _ready():
	var _not_in_use = Global.connect("player_initialised", self, "_on_player_initialised")
	_on_player_inventory_changed (Player.inventory)
	
func _on_player_initialised (_player):
	var _not_in_use = Player.inventory.connect("inventory_changed", self, "_on_player_inventory_changed")
	position = 0
	
func _on_player_inventory_changed (inventory):
	for n in item_list.get_children():
		n.queue_free()
	
	for item in inventory.get_items ():
		setNewItem(item, item.item_reference.name, item.amount)
		position += 1
	
#	get_tree().quit()
	position = 0

func setNewItem (item, item_name, item_info):
	newItem.button_position = position
	item_name_button.text = item_name
	item_info_label.text = "%s" % [item_info]
	print(item)
	newItem.item = item
	newItem.button_position = position
	
	item_list.add_child(newItem)
	
	newItem = preload("res://WORLD_SCENE/Main/From_Ruby/Menu/ItemPanel/ItemListElement.tscn").instance()
	item_name_button = newItem.get_node("item/name")
	item_info_label = newItem.get_node("item/details/info")

func _on_delete_pressed():
	if Player.inventory.get_size() > 0:
		print("button pressed: ", (self.name))
		Player.money += Player.selected_item.selling_cost
		print(Player.selected_item_position)
		var _deleted_item = Player.inventory.subtract_item(Player.selected_item_position, 1)
	
