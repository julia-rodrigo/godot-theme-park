extends Button

onready var photo_sell_button = $inner/Content/Delete
onready var photo_image_sprite = $inner/Content/Image/Panel/Image
var photo_position = 0
var photo

func _ready():
	var file = File.new()
	file.open(photo.screenshot_path, File.READ)
	file.close()
	print("here: ", photo)
	photo_image_sprite.texture = photo.texture
	


func _on_Delete_pressed():
	print("button pressed: ", (self.name))
	var dir = Directory.new()
	dir.remove(photo.screenshot_path)
	Player.money += 52
	var _deleted_photo = Player.photo_log.remove_photo(photo_position)
	
