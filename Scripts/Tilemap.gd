extends Node2D

onready var item = preload("res://Scenes/Item.tscn")

func get_player():
	if has_node("Player"):
		return $Player
	return false

func update_label(value):
	get_parent().update_label(value)


func _ready():
	var items = [["apple", 8], ["prut", 8], ["pebble", 8], ["branch", 4]]
	for i in range(100):
		randomize()
		var a = int(rand_range(0, 4))
		var new_item = item.instance()
		$Items.add_child(new_item)
		new_item.set_item(items[a])
		new_item.position = Vector2(int(rand_range(0, 32 * 44)), int(rand_range(0, 32 * 28)))
	add_to_group(GlobalVars.saving_group)
	SceneChanger.game_ready()

func _unhandled_input(event):
	if event.is_action_pressed("Alt"):
		for i in get_tree().get_nodes_in_group(GlobalVars.entity_gropup):
			i.toggle_hp_bar()
			


func save():
	var data = {
		"filename": get_filename(),
		"player": $Player.save(),
		"items": [],
		"nature": [],
		"animals": []
	}
	for item in $Items.get_children():
		data["items"].append(item.save())
	
	for object in $Nature.get_children():
		data["nature"].append(object.save())

	for animal in $Animals.get_children():
		data["animals"].append(animal.save())
	
	return data

func load_from_data(data):
	for item in $Items.get_children():
		$Items.remove_child(item)
		item.queue_free()
		
	for object in $Nature.get_children():
		$Nature.remove_child(object)
		object.queue_free()
	
	for animal in $Animals.get_children():
		$Animals.remove_child(animal)
		animal.queue_free()
	
	var p = $Player
	remove_child($Player)
	p.queue_free()
	
	var new_player = load(data["player"]["filename"]).instance()
	add_child(new_player)
	new_player.name = "Player"
	new_player.load_from_data(data["player"])
	
	get_parent().connect_player_to_death()
	
	for i in data["items"]:
		var item = load(i["filename"]).instance()
		$Items.add_child(item)
		item.load_from_data(i)
		
	for i in data["nature"]:
		var item = load(i["filename"]).instance()
		$Nature.add_child(item)
		item.load_from_data(i)
		
	for i in data["animals"]:
		var item = load(i["filename"]).instance()
		$Animals.add_child(item)
		item.load_from_data(i)
	
