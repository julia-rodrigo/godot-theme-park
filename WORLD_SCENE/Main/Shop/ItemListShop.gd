extends MarginContainer

onready var item_name_button = $item/name
onready var item_info_label = $item/details/info
var button_position = 0
var item

# get the item when pressed
func _on_name_pressed():
#	item = Player.inventory.get_item(button_position)
	Player.shop_item = item
	Player.shop_item_position = button_position
	
	
