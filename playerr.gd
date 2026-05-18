extends CharacterBody2D

const Gravity:int = 4200
const Jump_speed:int = -1200
func _physics_process(delta):
	velocity.y += Gravity * delta

	if is_on_floor():
		if not get_parent().game_running:
			$AnimatedSprite2D.play("Idle")
		else:
			# Player is running on the floor when the game is running
			$AnimatedSprite2D.play("run")

			# Jump when UP arrow is pressed
			if Input.is_key_pressed(KEY_UP):
				velocity.y = Jump_speed
				$sound2.play()
	else:
		# In the air (falling)
		$AnimatedSprite2D.play("jump")

	move_and_slide()
