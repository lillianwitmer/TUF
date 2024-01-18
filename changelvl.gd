extends Area2D


@export var next_level = ""



func _on_body_entered(body):
	if body.is_in_group("player"):
		var lvl = "res://end_1.tscn"
