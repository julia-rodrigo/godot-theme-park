extends Resource

class_name Inventory 

signal inventory_changed
export var _items = Array () setget set_items, get_items

func set_items (new_items):
	_items = new_items
	emit_signal ("inventory_changed", self)

func get_items ():
	return _items

func get_item (index):
	return _items [index]
	
func get_size():
	return _items.size()
	
func get_item_amount (item_name):
	var amount = 0
	for item in _items:
		if item.item_reference.name == item_name:
			amount += item.amount
#	print("amount of %s in the bag: %d" % [item_name.to_upper(), amount])
	return amount
	
func get_item_by_name (item_name):
	for item in _items:
		if item.item_reference.name == item_name:
			return item
	
	print("this item does not exist in your inventory yet")
	
func add_item (item_name, amount):
	if amount <= 0:
		print("the item amount it negative so we cant add the itme in Inventory.gd: ", amount)
		return
		
	var item = ItemDatabase.get_item(item_name)
	if not item:
		print ("could not find item Inventory.gd: ", item_name)
		return
	
	var remaining_amount = amount
	var max_stack_size = item.max_stack_size if item.stackable else 1
	
	if item.stackable :
		for i in range(_items.size()):
			if remaining_amount == 0:
				break
			
			var inventory_item = _items[i]
			
			if inventory_item.item_reference.name != item.name:
				continue
			
			if inventory_item.amount < max_stack_size:
				var original_amount = inventory_item.amount
				inventory_item.amount = min (original_amount +  remaining_amount, max_stack_size)
				remaining_amount -= inventory_item.amount - original_amount
			
			
	while remaining_amount > 0:
		var new_item = {
			item_reference = item,
			amount = min(remaining_amount, max_stack_size)
		}
		
		_items.append (new_item)
		remaining_amount -= new_item.amount
		
	emit_signal("inventory_changed", self) # Player.inventory
	
	
func subtract_item (position, amount): # subtract item by amount
	
	if(position > (_items.size() - 1)):
		print("cannot remove item amount at: ", position)
		return
		
	var inventory_item = _items[position]
	
	print ("position: ", position)
	print ("inventory_item name: ", inventory_item.item_reference.name)
	
	print ("amount in inventory is: ", inventory_item.amount)
	print ("amount we need to take off: ", amount)
	
	
	if amount <= 0:
		print("\nSUBTRACT ITEM: we cant use a negative amount of item in this inventory Inventory.gd: ", amount)
		return
		
	
	if (amount > inventory_item.amount):
		print("we cannot remove %d items from %d items in the bag" % [amount, inventory_item.amount])
		return

	
	_items[position].amount = inventory_item.amount - amount
	print("the item remaining:_items[position] ", _items[position])
	
	if _items[position].amount == 0 : 
		print("no more left, must remove")
		
		Player.selected_item = null
		Player.selected_item_position = 0
		_items.remove(position)
	
	emit_signal("inventory_changed", self)
	
	
func subtract_item_by_name (item_name, amount):
	var item_to_remove = get_item_by_name(item_name)
	
	if item_to_remove == null:
		print("... oh, this item is not in your inventory it seems")	
		return 
		
		
	var subtracted_amount = 0
	var position = 0
	var finished = false
	
	for item in _items :
		if item_to_remove.item_reference.name == item.item_reference.name:
			for _i in item.amount:
				subtract_item(position, 1)
				subtracted_amount += 1
				if subtracted_amount == amount:
					finished = true
					break
		else:
			position += 1
		
		if finished:
			break
	
	print("removes %d %s from your inventory" % [subtracted_amount, item_to_remove.item_reference.name])
	
	emit_signal("inventory_changed", self)
	
	
	
