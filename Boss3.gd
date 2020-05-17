extends Area2D

onready var Bullet = preload("res://BossBullet.tscn")
const MAXHP = 500
var hp = 500
var move = false
var move_to_right = false

func _ready():
	$UI/Health.max_value = MAXHP
	$UI/Health.value = hp
	$Node.visible = true
	$Node2.visible = false

func _process(delta):
	if move:
		$Node2.visible = true
		$Node.visible = false
		if move_to_right:
			if $Node.position.x >= -278:
				$Node2.position.x -= 20
				$Node.position.x -= 20
				$CollisionShape2D.position.x -= 20
		else:
			if $Node.position.x <= 0:
				$Node2.position.x += 20
				$Node.position.x += 20
				$CollisionShape2D.position.x += 20
	else:
		$Node2.visible = false
		$Node.visible = true
	$UI/Health.value = hp

func hit(damage):
	hp -= damage
	if hp <= 0:
		get_parent().go_next()

func _on_Timer_timeout():
	if move:
		move = false
	else:
		move = true
		move_to_right = !move_to_right

func _on_Boss_area_entered(area):
	if area.is_in_group("bullet"):
		var damage = get_parent().damage
		hit(damage)

func show_hp_bar():
	$UI.visible = true
