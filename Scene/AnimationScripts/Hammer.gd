extends Spatial


func _ready():
	var anim = get_node("AnimationPlayer").get_animation("Cylinder001Action")
	anim.set_loop(true)
	get_node("AnimationPlayer").play("Cylinder001Action")
