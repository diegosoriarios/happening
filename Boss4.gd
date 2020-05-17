extends Area2D

onready var Bullet = preload("res://BossBullet.tscn")
const MAXHP = 750
var hp = 750
var can_shoot = false

func _ready():
	$UI/Health.max_value = MAXHP
	$UI/Health.value = hp

func _process(delta):
	$UI/Health.value = hp
	for i in $Bullets.get_child_count():
		var bullet = $Bullets.get_child(i)
		bullet.rotation = deg2rad(45 * i)
		bullet.position += Vector2(1, 0).rotated(bullet.rotation) * 150 * delta

func hit(damage):
	hp -= damage
	if hp <= 0:
		get_parent().go_next()

func _on_Timer_timeout():
	$AnimationTimer.start()
	for sprites in $Node.get_children():
		sprites.position.y += 8
	if can_shoot:
		var x_pos = rand_range(64, 120)
		for i in range(8):
			var bullet = Bullet.instance()
			bullet.position.x = x_pos
			bullet.position.y = 40
			$Bullets.add_child(bullet)

func _on_Boss_area_entered(area):
	if area.is_in_group("bullet"):
		var damage = get_parent().damage
		hit(damage)

func show_hp_bar():
	can_shoot = true
	$UI.visible = true


func _on_AnimationTimer_timeout():
	for sprites in $Node.get_children():
		sprites.position.y -= 8
		$AnimationTimer.stop()
