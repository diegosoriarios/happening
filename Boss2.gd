extends Area2D

onready var Bullet = preload("res://BossBullet.tscn")
const MAXHP = 200
var hp = 200
var can_shoot = false

func _ready():
	$UI/Health.max_value = MAXHP
	$UI/Health.value = hp

func _process(delta):
	$UI/Health.value = hp
	for bullet in $Bullets.get_children():
		bullet.position.y += 1
		if bullet.position.y >= 150:
			bullet.queue_free()

func hit(damage):
	hp -= damage
	if hp <= 0:
		get_parent().go_next()

func _on_Timer_timeout():
	if can_shoot:
		var bullet = Bullet.instance()
		bullet.position.x = rand_range(0, 240)
		bullet.position.y = -10
		$Bullets.add_child(bullet)

func _on_Boss_area_entered(area):
	if area.is_in_group("bullet"):
		var damage = get_parent().damage
		hit(damage)

func show_hp_bar():
	can_shoot = true
	$UI.visible = true
