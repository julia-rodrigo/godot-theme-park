extends HBoxContainer

onready var newPhoto = preload("res://WORLD_SCENE/Main/From_Ruby/Menu/PhotoPanel/PhotoViewer.tscn").instance()
onready var photo_sell_button = newPhoto.get_node("inner/Content/Delete")
onready var photo_image_sprite = newPhoto.get_node("inner/Content/Image/Panel/Image")

var position = 0

func _ready():
	var _not_in_use = Global.connect("player_initialised", self, "_on_player_initialised")
	_on_player_photo_log_changed (Player.photo_log)
	
func _on_player_initialised (_player):
	var _not_in_use = Player.photo_log.connect("photo_log_changed", self, "_on_player_photo_log_changed")
	position = 0
	
func _on_player_photo_log_changed (photo_log):
	for n in get_children():
		n.queue_free()
	
	for photo in photo_log.get_photos ():
		setNewPhoto(photo)
		position += 1
	
#	get_tree().quit()
	position = 0

func setNewPhoto (photo):
	newPhoto.photo_position = position
	print(photo)
	newPhoto.photo = photo
	
	add_child(newPhoto)
	
	newPhoto = preload("res://WORLD_SCENE/Main/From_Ruby/Menu/PhotoPanel/PhotoViewer.tscn").instance()
	photo_sell_button = newPhoto.get_node("inner/Content/Delete")
	photo_image_sprite = newPhoto.get_node("inner/Content/Image/Panel/Image")


