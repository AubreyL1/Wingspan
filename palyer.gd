extends CharacterBody2D


const JUMP_VELOCITY = -600.0

var lastDir = 0
var speed = 10
var dashing = false
var dashTime = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor()&&!dashing:
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction > 0:
		#Moves right
		if velocity.x < 0:
			speed = 50
		else:
			speed = 20
		velocity.x += speed
		lastDir = direction

	elif direction < 0:
		#Moves left
		if velocity.x > 0:
			speed = 50
		else:
			speed = 20
		velocity.x -= speed
		lastDir = direction
	else:
		#Stops the Bird when no movement keys are pressed
		speed = move_toward(velocity.x, 0, 30)
		velocity.x = speed
		
	#Limits speed of player
	if velocity.x > 1000:
		velocity.x -= 40
	elif velocity.x < -1000:
		velocity.x += 40
		
	dash()
	dashTime+=1
	print(dashTime)
	move_and_slide()

# Handle Dash.
func dash():
	if (Input.is_action_just_pressed("ui_accept")&&dashTime > 60):
		dashTime = 0
		dashing = true
	if (Input.is_action_just_pressed("ui_accept")&&dashTime > 60)||(dashTime < 15&&dashing):
		velocity.x = 2000*lastDir
		dashing = true
		velocity.y = 0
	elif dashTime == 15:
		dashing = false
		velocity.x = 0
