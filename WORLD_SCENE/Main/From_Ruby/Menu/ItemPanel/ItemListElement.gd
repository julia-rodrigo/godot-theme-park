extends MarginContainer

onready var item_name_button = $item/name
onready var item_info_label = $item/details/info
var button_position = 0
var item

# get the item when pressed
func _on_name_pressed():
	print("button pressed: ", (self.name))
	item = Player.inventory.get_item(button_position)
	Player.selected_item = item.item_reference
	Player.selected_item_position = button_position
	
	print(Player.selected_item.name)
	print(Player.selected_item_position)
	
