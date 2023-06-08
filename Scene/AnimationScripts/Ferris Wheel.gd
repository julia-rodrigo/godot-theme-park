extends Spatial

func _ready():
	var anim = get_node("AnimationPlayer").get_animation("CircleAction003")
	anim.set_loop(true)
	get_node("AnimationPlayer").play("CircleAction003")
