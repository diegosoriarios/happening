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
var hp = 3

onready var Bullet = preload("res://Bullet.tscn")

func _physics_process(delta):
	motion.y += gravity
	var friction = false
	
	for bullet in $Bullets.get_children():
		bullet.position.x += 3
		if bullet.position.x >= 240:
			bullet.queue_free()

	if get_parent().boss:
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
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	motion = move_and_slide(motion, UP)
	
	if Input.is_action_just_pressed("close"):
		get_tree().quit()
	
	#if global.time >= global.totalTime:
	#	global.time = 0
	#	global.deaths += 1
	#	global.totalTime = (global.deaths + 1) * 10
	#	get_tree().reload_current_scene()

func crouch():
	$Sprite.visible = false
	$Crouch.visible = true
	#$Sprite.scale.y = .09
	$CollisionShape2D.scale.y = .2
	$Timer.start()

func _ready():
	if get_parent().level > 1:
		double_jump_active = true
	sprite_scale = $Sprite.scale
	colision_scale = $CollisionShape2D.scale
	$AnimationPlayer.play("Run")
	get_parent().update_hp(hp)

func shoot():
	var bullet = Bullet.instance()
	bullet.position = position
	$Bullets.add_child(bullet)

func _on_Timer_timeout():
	$Sprite.visible = true
	$Crouch.visible = false
	#$Sprite.scale = sprite_scale
	$AnimationPlayer.play("Run")
	$CollisionShape2D.scale = colision_scale

func die():
	get_tree().reload_current_scene()

func _on_Colision_area_entered(area):
	if area.is_in_group("obstacle") and get_parent().ghost_mode == false and area.name != "Target" and get_parent().transiction == false:
		hp -= 1
		get_parent().update_hp(hp)
		if hp <= 0:
			get_parent().transiction = true
			get_parent().chase_enemy(area)
	elif area.is_in_group("enemy_bullet"):
		hp -= 1
		get_parent().update_hp(hp)
		if hp <= 0:
			get_tree().reload_current_scene()
