extends Area

export (Resource) var item

# perhaps make the item sprite an instance

func _on_PickableItem_body_entered(body):
	if (body == Global.player):
		Player.inventory.add_item(item.name, 1)
		queue_free()
		print("Obtained %s!" % item.name)
		
