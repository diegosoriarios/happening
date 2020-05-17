extends Node2D


onready var Wall = preload("res://Wall.tscn")
onready var Ghost = preload("res://Ghost.tscn")
onready var Player = preload("res://Player.tscn")
onready var Boss = preload("res://Boss2.tscn")
var y_positions = [0, 70, 180]#[0, 32, 48, 160]

var ghost_mode = false
var transiction = false
var target
var score = 251
var boss
var damage = int(rand_range(2,5))
var level = 2

func _ready():
	randomize()
	$Player.position = $PlayerPosition.position
	$HP.text = "HP: " + str($Player.hp)

func _process(delta):
	if score <= 0:
		get_tree().change_scene("res://GameOver.tscn")
	elif score >= 1001:
		if $Obstacles.get_child_count() == 0:
			if boss:
				boss.show_hp_bar()
		for child in $Obstacles.get_children():
			child.queue_free()
		if boss:
			if boss.position.x >= 200:
				boss.position.x -= 1
	else:
		$Score.text = "Score: " + str(int(score))
		if target and !transiction:
			target.position.x -= .1
		if transiction:
			$Songs/Normal.stop()
			$Songs/Ghost.stop()
			if !ghost_mode:
				$Player.position.x += 1
				if $Player.position.x >= $GhostPosition.position.x:
					$Player.queue_free()
					generate_ghost()
					transiction = false
					ghost_mode = true
			else:
				$Ghost.position.x -= 1
				if $Ghost.position.x <= $PlayerPosition.position.x:
					$Ghost.queue_free()
					target.queue_free()
					target = null
					generate_player()
					transiction = false
					ghost_mode = false
		else:
			if ghost_mode:
				score -= delta * 10
				if $Obstacles.get_child_count() > 0:
					for child in $Obstacles.get_children():
						child.queue_free()
				for obstacle in $GhostObstacles.get_children():
					obstacle.position.x += 3
					if obstacle.position.x > 260:
						obstacle.queue_free()
			else:
				score += delta * 10
				if $GhostObstacles.get_child_count() > 0:
					for child in $GhostObstacles.get_children():
						child.queue_free()
				for obstacle in $Obstacles.get_children():
					obstacle.position.x -= 3
					if obstacle.position.x < -20:
						obstacle.queue_free()

func _on_Timer_timeout():
	if score >= 1000:
		$Timer.stop()
		$Songs/Normal.stop()
		$Songs/Boss.play()
		$Score.text = "Score: 1000"
		boss = Boss.instance()
			#boss.position.x = 200
			#boss.position.y = 90
		add_child(boss)
	else:
		if ghost_mode:
			var wall = Wall.instance()
			wall.position.x = -20
			#wall.scale.y = rand_range(.5, 1)
			wall.position.y = y_positions[int(rand_range(0, y_positions.size()))]
			$GhostObstacles.add_child(wall)
		else:
			var wall = Wall.instance()
			wall.position.x = 300
			#wall.scale.y = rand_range(.5, 1)
			var index = int(rand_range(0, y_positions.size()))
			if index == 0:
				wall.find_node("Ceilling").visible = true
				wall.find_node("Sprite").visible = false
				#wall.find_node("AnimationPlayer").play("RunFloor")
			elif index == 1:
				wall.find_node("Wall").visible = true
				wall.find_node("Sprite").visible = false
			elif index == 2:
				wall.find_node("Floor").visible = true
				wall.find_node("Sprite").visible = false
				wall.find_node("AnimationPlayer").play("RunFloor")
			wall.position.y = y_positions[index]
			$Obstacles.add_child(wall)

func generate_ghost():
	var ghost = Ghost.instance()
	ghost.position = $GhostPosition.position
	$Songs/Ghost.play()
	add_child(ghost)

func generate_player():
	var player = Player.instance()
	player.position = $PlayerPosition.position
	player.hp = 1
	$Songs/Normal.play()
	add_child(player)

func chase_enemy(enemy):
	var new_enemy = Wall.instance()
	new_enemy.position = enemy.position
	new_enemy.scale = enemy.scale
	target = new_enemy
	target.find_node("Sprite").modulate = Color(1, 1, 1)
	enemy.queue_free()
	target.set_name("Target")
	add_child(target)

func go_next():
		if score >= 1000:
			get_tree().change_scene("res://Level3.tscn")

func update_hp(hp):
	$HP.text = "HP: " + str(hp)
