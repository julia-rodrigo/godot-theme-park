extends TextureRect


func _process(_delta):
	var tex = get_parent().get_node("Viewport").get_texture()
	texture = tex
	return
