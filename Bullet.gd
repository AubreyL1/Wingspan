extends CharacterBody2D

const BULLET_SPEED = 1000
var bullet_direction = Vector2.ZERO

func _ready():
	$CollisionShape2D.set_disabled(true)

func _physics_process(delta):
	var motion = bullet_direction * BULLET_SPEED * delta
	move_and_collide(motion)
	var collision = move_and_collide(motion)
	if collision:
		queue_free()

func set_direction(direction):
	bullet_direction = direction.normalized()

func _on_VisibilityNotifier2D_screen_exited():
	# Deletes the bullet when it exits the screen.
	queue_free()
	
func _on_timer_timeout():
	$CollisionShape2D.set_disabled(false)
	print($CollisionShape2D.is_disabled())

