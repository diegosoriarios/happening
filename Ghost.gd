extends KinematicBody2D

const UP = Vector2(0, -1)
var motion = Vector2()
var speed = 200
var gravity = 10
var jump_force = -250
var acceleration = 50
var max_speed = 100
var jumps = 0
var frame = 0
var crouch = false
var stand
var face_right = true
var stabbing = false
var animation = 0
var is_jumping
var velocity = Vector2()
var double_jump_active = false
var sprite_scale
var colision_scale

func _physics_process(delta):
	motion.y += gravity
	var friction = false

	
	if Input.is_action_pressed("ui_right"):
		$Sprite.flip_h = false
		motion.x = min(motion.x + acceleration, max_speed)	
	elif Input.is_action_pressed("ui_left"):
		$Sprite.flip_h = true
		motion.x = max(motion.x - acceleration, -max_speed)
	else:
		friction = true
	
	
	if is_on_floor():
		#$Sprite.play("idle")
		is_jumping = false
		jumps = 0
		if Input.is_action_just_pressed("ui_down"):
			crouch()
		elif Input.is_action_just_pressed("ui_up"):
			is_jumping = true
			motion.y = jump_force
			jumps += 1
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.2)
	else:
		if Input.is_action_just_pressed("ui_up") and jumps < 2 and double_jump_active == true:
			motion.y = jump_force
			is_jumping = true
			jumps += 1
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)
	
	motion = move_and_slide(motion, UP)
	
	if Input.is_action_just_pressed("close"):
		get_tree().quit()
	
	#if global.time >= global.totalTime:
	#	global.time = 0
	#	global.deaths += 1
	#	global.totalTime = (global.deaths + 1) * 10
	#	get_tree().reload_current_scene()

func crouch():
	$Sprite.frame = 1
	#$CollisionShape2D.scale.y = .5
	$Sprite.modulate = Color(1, 1, 1, .3)
	$Colision/CollisionShape2D.scale = Vector2.ZERO
	$Timer.start()

func _ready():
	$AnimationPlayer.play("Run")
	sprite_scale = $Sprite.scale
	colision_scale = $Colision/CollisionShape2D.scale


func _on_Timer_timeout():
	$AnimationPlayer.play("Run")
	$Sprite.modulate = Color(1, 1, 1, 1)
	$Sprite.scale = sprite_scale
	$Colision/CollisionShape2D.scale = colision_scale


func _on_Colision_area_entered(area):
	if area.name == "Target":
		get_parent().transiction = true
	elif area.is_in_group("obstacle"):
		if $Sprite.modulate == Color(1, 1, 1, 1):
			get_parent().score -= get_parent().level * 25
			pass
		#acceleration -= 5
