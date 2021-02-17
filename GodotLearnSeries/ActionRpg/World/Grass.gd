extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func create_grass_effect():
		# var GrassEffect = load("res://Effects/GrassEffect.tscn") #get scene
		# preload. load once use every time.
		var grassEffect = GrassEffect.instance() # create instance from scene
		get_parent().add_child(grassEffect)
		# var world = get_tree().current_scene # when playing get current scene
		# world.add_child(grassEffect)
		grassEffect.global_position = global_position # set position to grass

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
