extends CanvasLayer

# this is saving all the options for when the player selects a panel to look at

#onready var save_file = SaveFile.g_data
export var mainGameScene : PackedScene

onready var photo_button = $Options/TopMarginContainer/SideMarginContainer/ButtonOptions/Button5/MarginContainer/PhotoButton
onready var item_button = $Options/TopMarginContainer/SideMarginContainer/ButtonOptions/Button1/MarginContainer/ItemButton
onready var take_photo_button = $Options/TopMarginContainer/SideMarginContainer/ButtonOptions/Button4/MarginContainer/TakePhotoButton

onready var text_box = $Options/TextBox

onready var photo_panel = $fillSizeFlags/marginBottomAndFillOnly/PhotoPanel
onready var item_panel = $fillSizeFlags/marginBottomAndFillOnly/ItemPanel

var panel_being_viewed = null
var new_panel_view = null
var disabled_everything_bool = false

func _process(_delta):
	if Player.at_shop:
		disable_everything(true)
	elif Player.at_conversation:
		disable_everything(true)
	else:
		disable_everything(false)
	
func disable_everything (yes):
	disabled_everything_bool = yes
	Global.disable_keyboard_options = yes
	photo_button.disabled = yes
	take_photo_button.disabled = yes
	item_button.disabled = yes
	
func _input(event):
#	if ev is InputEventKey and ev.scancode == KEY_M and not ev.echo:
	
	if( not Global.disable_keyboard_options):
		if event is InputEventKey:
			if event.is_pressed() == false:
				match event.scancode :
					KEY_A:
						item_preference()
					KEY_S:
						photo_preference()
					KEY_E:
						Player.inventory.add_item("Bright Red Apple", 10)
						Player.inventory.add_item("Miniature Coffee Shop", 1)
						
						
#						Player.creaventory.add_creature("Hasven")
#						Player.get_inventory_items()
#						Player.inventory.subtract_item(Player.inventory.get_item(0), 1)

#						Player.inventory.subtract_item(0, 1) # subtract item in this position, and the mount
					
					KEY_P:
						capture_photo()

	#				KEY_UP:
	#					print("face back")
	#
	#				KEY_DOWN:
	#					print("face front")
	#
	#				KEY_LEFT:
	#					print("face left")
	#
	#				KEY_RIGHT:
	#					print("face right")

					_:
	#					print("Another key'!! :)")
						pass

var photo_count = 1
func capture_photo():
	
	var current_time = Time.get_time_dict_from_system()
	var current_date = Time.get_date_string_from_system()
	var photo_name = "%s-%dh%dm%ds" % [current_date, current_time.hour, current_time.minute, current_time.second ]
	var screenshot_path = "res://WORLD_SCENE/Main/PHOTO_LOG/%s.png" % [photo_name]
	photo_count += 1
	
	# Retrieve the captured image
	var image = get_tree().get_root().get_texture().get_data()

	# Flip it on the y-axis (because it's flipped)
	image.flip_y()
	
	image.save_png(screenshot_path)
	
	var file = File.new()
	file.open(screenshot_path, File.READ)
	var buffer = file.get_buffer(file.get_len())
	file.close()

	var photo = Image.new()
	photo.load_png_from_buffer(buffer)

	var image_texture = ImageTexture.new()
	image_texture.create_from_image(photo)

#	sprite.texture = image_texture

	Player.photo_log.add_photo(image, image_texture, screenshot_path, photo_name)
	
	display_text("Photo captured!")
	
	
	

func _on_PhotoButton_pressed():
	photo_preference()

func _on_ItemButton_pressed():
	item_preference()

func _on_TakePhotoButton_pressed():
	capture_photo()

func display_text (text):
	$Options/TextBox/MarginContainer/Label.text = text	
	text_box.show()	
	timerYieldTextbox(0.5)
	
func timerYieldTextbox(cooldown):
	var _not_in_use = get_tree().create_timer(cooldown).connect("timeout", self, "textBoxHideAfterTimer")
	
func textBoxHideAfterTimer():
	text_box.hide()
	
func item_preference() :
	if not Player.at_shop:
		print("item")
		new_panel_view = item_panel
		panel_viewing()
	else:
		print("Now is not the time!")
		display_text("Now is not the time! Need to concentrate :<")

func photo_preference():
	if not Player.at_shop:
		
		print("photo")
		new_panel_view = photo_panel
		panel_viewing()
	else:
		print("Now is not the time!")
		display_text("Now is not the time! Need to concentrate :<")

onready var other_panels_view = $fillSizeFlags

func panel_viewing():
	if disabled_everything_bool == true:
		return 
		
	if panel_being_viewed == null:
		other_panels_view.visible = true
		panel_being_viewed = new_panel_view
		panel_being_viewed.visible = true
		Player.move = false
		
	elif new_panel_view == panel_being_viewed:
		other_panels_view.visible = false		
		new_panel_view.visible = false
		panel_being_viewed = null
		new_panel_view = null
		Player.move = true
		
		
	elif(new_panel_view != panel_being_viewed):
		panel_being_viewed.visible = false
		panel_being_viewed = new_panel_view
		new_panel_view.visible = true
		Player.move = false
		
	else:
		print("ERROR at help.gd")
	
	
	
		



