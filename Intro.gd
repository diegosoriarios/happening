extends Node2D


onready var label = $Label
onready var label2 = $Label2
onready var label3 = $Label3
onready var label4 = $Label4
var start = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if Input.is_action_just_pressed("close"):
		get_tree().quit()
	elif !start:
		start = true
		start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start_typing():
	$Timer2.start()

func _on_Timer_timeout():
	if label.visible_characters < label.get_total_character_count():
		label.visible_characters += 1
	else:
		if label2.visible_characters < label2.get_total_character_count():
			label2.visible_characters += 1
		else:
			$Animation.play("Move")
			$Timer.stop()


func _on_Timer2_timeout():
	if label3.visible_characters < label3.get_total_character_count():
		label3.visible_characters += 1
	else:
		if label4.visible_characters < label4.get_total_character_count():
			label4.visible_characters += 1
		else:
			$Animation.play("go_in")
			$Timer2.stop()

func next_scene():
	get_tree().change_scene("res://Level.tscn")

func start():
	$Animation.play("Start")
	$Timer.start()
	start = true
