extends CanvasLayer

onready var shopkeeper_dialogue = preload("res://WORLD_SCENE/Main/Shop/ShopkeeperDialogue.tscn").instance()

var dialogue
var merchandise
var shopkeeper_name
var shop_name

onready var shop_panel = $fillSizeFlags/VBoxContainer/marginBottomAndFillOnly/ShopPanel
onready var shop_name_label = $fillSizeFlags/VBoxContainer/marginBottomAndFillOnly/ShopPanel/outerMargin/innerVbox/TopHbox/ShopName
onready var shop_container = $fillSizeFlags/VBoxContainer
#onready var shopkeeper_dialogue = $fillSizeFlags/VBoxContainer/ShopkeeperDialogue

onready var newItem = preload("res://WORLD_SCENE/Main/Shop/ItemListShop.tscn").instance()
onready var item_name_button = newItem.get_node("item/name")
onready var item_info_label = newItem.get_node("item/details/info")

onready var item_list = $fillSizeFlags/VBoxContainer/marginBottomAndFillOnly/ShopPanel/outerMargin/innerVbox/ContentMargin/SeparateMargin/Body/ScrollLeft/ItemList

onready var item_tags = $fillSizeFlags/VBoxContainer/marginBottomAndFillOnly/ShopPanel/outerMargin/innerVbox/ContentMargin/SeparateMargin/Body/ScrollContainer/ItemList/information/panel/container/tags
onready var item_selected_name = item_tags.get_node("name")
onready var item_selected_cost = item_tags.get_node("cost")
onready var item_selected_description = item_tags.get_node("description")
#onready var item_selected_buy_button = item_tags.get_node("input/details")

onready var amount_own = item_tags.get_node("input/details/owned")

onready var finished_shopping_button = $fillSizeFlags/VBoxContainer/marginBottomAndFillOnly/ShopPanel/outerMargin/innerVbox/TopHbox/Finished
onready var buy_button = $fillSizeFlags/VBoxContainer/marginBottomAndFillOnly/ShopPanel/outerMargin/innerVbox/ContentMargin/SeparateMargin/Body/ScrollContainer/ItemList/information/panel/container/tags/input/buy
onready var item_selected_selling_cost = $"fillSizeFlags/VBoxContainer/marginBottomAndFillOnly/ShopPanel/outerMargin/innerVbox/ContentMargin/SeparateMargin/Body/ScrollContainer/ItemList/Item1/inner/Content/Selling Price/sell"
onready var viewport_selected_item = $fillSizeFlags/VBoxContainer/marginBottomAndFillOnly/ShopPanel/outerMargin/innerVbox/ContentMargin/SeparateMargin/Body/ScrollContainer/ItemList/Item1/inner/Content/Panel/Viewport

var item_position = 0

signal shopping_ended # emit signal item_bought

func _process(_delta):
	if Player.shop_item != null:
		item_selected_name.text = Player.shop_item.name
		item_selected_cost.text = "Cost: $ %d.00" % Player.shop_item.buying_cost
		item_selected_selling_cost.text = "Selling Cost: $%d.00" % Player.shop_item.selling_cost
		amount_own.text = "Owned: %d" % [Player.inventory.get_item_amount(Player.shop_item.name)]
		item_selected_description.text = Player.shop_item.description
		
		if viewport_selected_item.get_children()[0].name != Player.shop_item.sprite._bundled.names[0]:
			print(viewport_selected_item.get_children()[0].name )
			print(Player.shop_item.sprite._bundled.names[0])
			
			viewport_selected_item.get_children()[0].queue_free()
			viewport_selected_item.add_child((Player.shop_item.sprite).instance())
			
	elif merchandise.size() > 0:
		Player.shop_item = merchandise[0]
		Player.shop_item_position = 0
		buy_button.disabled = false
	else:
		item_selected_name.text = "This shop has no more items"
		item_selected_description.text = "Everything is gone. Thanks for coming buy and enjoy the festival!"
		buy_button.disabled = true
		_on_Finished_pressed()
		
		
func _ready():
	Player.at_shop = true
	shop_name_label.text = shop_name
	
	update_item_list()
	shop_container.get_child(1).queue_free()
	run_shopkeeper_dialogue(["Please have a look!"])
	
func run_shopkeeper_dialogue (comment):
	
	shopkeeper_dialogue.shopkeeper_name = shopkeeper_name
	shopkeeper_dialogue.dialogue = comment
	shop_container.add_child(shopkeeper_dialogue)
	
	
	
func update_item_list ():
	for i in item_list.get_children():
		i.queue_free()
		
	for item in merchandise:
		
		item_name_button.text = item.name
		item_info_label.text = "1"
		newItem.item = item
		newItem.button_position = item_position
		
		item_list.add_child(newItem)
		
		item_position += 1
	
		newItem = preload("res://WORLD_SCENE/Main/Shop/ItemListShop.tscn").instance()
		item_name_button = newItem.get_node("item/name")
		item_info_label = newItem.get_node("item/details/info")

	item_position = 0
	pass
	
func _on_Finished_pressed():
	emit_signal("shopping_ended")
	Player.shop_item = null
	Player.shop_item_position = 0
	Player.at_shop = false
	
	Global.shopkeeper_updated_merchandise = merchandise
	
	queue_free()

func _on_buy_pressed():
	
	if Player.money < Player.shop_item.buying_cost:
		shopkeeper_dialogue.queue_free()
		shopkeeper_dialogue = preload("res://WORLD_SCENE/Main/Shop/ShopkeeperDialogue.tscn").instance()
		run_shopkeeper_dialogue(["Aa, you might wanna work a bit more for that"])
		update_item_list()
		return
	else:
		Player.money -= Player.shop_item.buying_cost
	
	print("\nhere:", Player.shop_item.name)
	print(Player.shop_item_position, "\n----------")
	
	Player.inventory.add_item(Player.shop_item.name, 1)
	merchandise.remove(Player.shop_item_position)
	
	Player.shop_item_position = 0
	Player.shop_item = null
	
	Global.shopkeeper_updated_merchandise = merchandise
	update_item_list()
	
	shopkeeper_dialogue.queue_free()
	shopkeeper_dialogue = preload("res://WORLD_SCENE/Main/Shop/ShopkeeperDialogue.tscn").instance()
	
	run_shopkeeper_dialogue(["Thank you!"])
