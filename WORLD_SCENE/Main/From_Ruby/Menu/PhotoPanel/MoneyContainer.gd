extends HBoxContainer

onready var money_label = $margin/money

func _process(_delta):
	if money_label.text != ("$ %s.00" % [Player.money]):
		money_label.text = ("$ %s.00" % [Player.money])
		print("money changed")
