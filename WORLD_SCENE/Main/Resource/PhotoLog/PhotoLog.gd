extends Resource

class_name PhotoLog 

signal photo_log_changed
export var _photos = Array () setget set_photos, get_photos

func set_photos (new_photos):
	_photos = new_photos
	emit_signal ("photo_log_changed", self)

func get_photos ():
	return _photos

func get_photo (index):
	return _photos [index]

func get_photo_by_name (photo_name):
	for photo in _photos:
		if photo.name == photo_name:
			return photo

	print("this photo does not exist in your photo logs")

func add_photo (photo, photo_texture, photo_path, photo_name):
	print(photo)
	
	var new_photo = {
			photo_reference = photo,
			texture = photo_texture,
			screenshot_path = photo_path,
			name = photo_name
	}
		
	_photos.append (new_photo)
	emit_signal("photo_log_changed", self) # Player.inventory


func remove_photo (position): # subtract item by amount
	if(position > (_photos.size() - 1)):
		print("cannot remove photo amount at: ", position)
		return

	var photo_to_remove = _photos[position]

	print ("REMOVE photo position: ", position)
	print ("photo name: ", photo_to_remove.name)

	_photos.remove(position)

	emit_signal("photo_log_changed", self)


func remove_photo_by_name (photo_name):
	var photo_to_remove = get_photo_by_name(photo_name)

	if photo_to_remove == null:
		print("... oh, this item is not in your inventory it seems")	
		return 

	for photo in _photos :
		if photo_to_remove.name == photo.name:
			_photos.remove(photo_name)

	emit_signal("photo_log_changed", self)



