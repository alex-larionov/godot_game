extends Area2D


var damaged = false
var damage = 0

func _ready():
	$Timer.start(0.1)

func set_damage(dmg):
	damage = dmg


func _process(delta):
	if not damaged and get_overlapping_bodies() != []:
		for i in get_overlapping_bodies():
			if i in get_tree().get_nodes_in_group(GlobalVars.animal_group):
				i.reduce_hp(damage)
		damaged = true


func _on_Timer_timeout():
	get_parent().remove_child(self)
	queue_free()
