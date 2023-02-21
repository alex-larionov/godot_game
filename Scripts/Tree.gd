extends "res://Scripts/Nature_object.gd"

onready var texture = 0

func _ready():
	randomize()
	var a = int(rand_range(1, 4))
	$Sprite.texture = load("res://Sprites/tree%s.png" % str(a))
	texture = a
	

func save():
	var data = .save()
	data["texture"] = texture
	return data


func load_from_data(data):
	.load_from_data(data)
	$Sprite.texture = load("res://Sprites/tree%s.png" % str(data["texture"]))
