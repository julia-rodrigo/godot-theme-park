#extends Node
#
## this is the code to get all the adventure files 
## from "res://Resource/Adventures/Adventure/"
#
#var photos = Array ()
#var photo_log_path = "res://PHOTO_LOG/"
#
#func _ready():
#	var directory = Directory.new()
#	directory.open(photo_log_path) 
#	directory.list_dir_begin () 
#
#	var filename = directory.get_next()
#	while (filename):
#		if not directory.current_is_dir():
#			photos.append(load("res://PHOTO_LOG/%s" % filename))
#		filename = directory.get_next()
#
## check if the item exists
#
#func get_photo (photo_name):
#	for i in photos:
#		if i.name == photo_name:
#			return i
#
#	return null
#
#func update_photos (current_player_photo_log):
#	for photo in current_player_photo_log:
#		var screenshot_path = photo.screenshot_path
#
#		# Retrieve the captured image
#		var image = photo.photo_reference
#
#		image.save_png(screenshot_path)
#
#func delete_list_files_in_directory():
#	var files = []
#	var dir = Directory.new()
#	dir.open(photo_log_path)
#	dir.list_dir_begin()
#
#	while true:
#		var file = dir.get_next()
#		if file == "":
#			break
#		elif not file.begins_with("."):
#			files.append(file)
#
#	dir.list_dir_end()
#
#	return files
##var file = File.new()
##file.open("user://screenshot-test.png", File.READ)
##var buffer = file.get_buffer(file.get_len())
##file.close()
##
##var image = Image.new()
##image.load_png_from_buffer(buffer)
##
##var image_texture = ImageTexture.new()
##image_texture.create_from_image(image)
##
##sprite.texture = image_texture
