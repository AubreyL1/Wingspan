extends CharacterBody2D


const SPEED = 20.0
const JUMP_VELOCITY = -600.0

var inertia = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	inertia += SPEED
	if direction > 0:
		velocity.x = inertia
	elif direction < 0:
		velocity.x = -1 * inertia
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		inertia -= 50
	#Limits speed
	if inertia > 500:
		inertia = 500
	elif inertia < 0:
		inertia = 0
		
	move_and_slide()
