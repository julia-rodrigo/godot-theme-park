tool # to export resources
extends Resource
class_name Item

export (String) var name
export (int) var amount = 1
export (int) var buying_cost = 50
export (int) var selling_cost = 20

export (PackedScene) var sprite

export (String, MULTILINE) var description
export var stackable : bool = false
export var max_stack_size : int = 1


func addAmount (x: int):
	amount += x

func getAmount ():
	return amount

func getSprite () -> PackedScene:
	return sprite

func _ready():
	if max_stack_size == null:
		max_stack_size = 1
