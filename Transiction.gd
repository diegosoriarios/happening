extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if global.level == 1: 
		$Sprite.visible = true
		$Control/Label2.text = "Double Jump"
	elif global.level == 2:
		$Sprite3.visible = true
		$Control/Label2.text = "ShotGun"
	elif global.level == 3:
		$Sprite2.visible = true
		$Control/Label2.text = "Extra life"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func next_level(level):
	level += 1
	get_tree().change_scene("res://Level"+ str(level) + ".tscn")


func _on_Timer_timeout():
	next_level(global.level)
