extends CharacterBody2D

var health = 100
var player_alive = true
var attack_in_progress = false
var enemy_inattack_range = false
var enemy_attack_cooldown = true

#const speed = 100
var current_dir = "none"
var speed = 100

var playerState #variable for which sprite to use

#movement function
func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	
	if health <= 0:
		player_alive = false
		health = 0
		print("You have fallen...")
		self.queue_free() #change this to transition to an end screen
	var direction = Input.get_vector("left", "right", "up", "down") #variable that takes in keyboard input
	
	# idle state
	if direction.x == 0 and direction.y == 0:
		playerState = "Idle"
	else:
		playerState = "walking"

	velocity = direction * speed
	move_and_slide()
	
	play_anim(direction, playerState)
	
func play_anim(dir, state):
	if state == "Idle":
		$AnimatedSprite2D.play("Idle")
		
#func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	#left and right directional movement
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk-sideways")
		elif movement == 0:
			anim.play("idle-side")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("walk-sideways")
		elif movement == 0:
			anim.play("idle-side")
	#up and down directional movement
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk-up")
		elif movement == 0:
			anim.play("idle-back")
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk-down")
		elif movement == 0:
			anim.play("idle-front")

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true
	
func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 10
		enemy_attack_cooldown = false
		$attackCooldown.start()
		print("You have been hit, health is at ", health)
		
func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
	if state == "walking":
		if dir.y == -1:
			$AnimatedSprite2D.play("N-walk")
		if dir.x == 1:
			$AnimatedSprite2D.play("E-walk")
		if dir.x == -1:
			$AnimatedSprite2D.play("W-walk")
		if dir.y == 1:
			$AnimatedSprite2D.play("S-walk")

		if dir.x > 0.5 and dir.y < -0.5:
			$AnimatedSprite2D.play("NE-walk")
		if dir.x > 0.5 and dir.y > 0.5:
			$AnimatedSprite2D.play("SE-walk")
		if dir.x < -0.5 and dir.y > 0.5:
			$AnimatedSprite2D.play("SW-walk")
		if dir.x < -0.5 and dir.y < -0.5:
			$AnimatedSprite2D.play("NW-walk")
	
func player():
	pass
