extends CharacterBody2D


const SPEED = 500
const SHOOT_DELAY = 3
var shoot_timer = SHOOT_DELAY

@export var player:Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

# Import the Bullet scene
const BulletScene = preload("res://Bullet.tscn")

func _physics_process(delta: float) -> void:
	var player_position = player.global_position
	var enemy_position = global_position
	var direction = player_position - enemy_position
	direction = direction.normalized()

	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	
	if position.distance_to(nav_agent.target_position) < 20:
		velocity = Vector2(0, 0)
	else:
		velocity = dir*SPEED
		
	move_and_slide()
	
	shoot_timer -= delta

	if shoot_timer <= 0.25:
		var bullet_instance = BulletScene.instantiate() 
		bullet_instance.global_position = global_position
		bullet_instance.set_direction(direction) 
		get_parent().add_child(bullet_instance)
	if shoot_timer <= 0:
		shoot_timer = SHOOT_DELAY

func makepath() -> void:
	var rng = RandomNumberGenerator.new()
	nav_agent.target_position.x = player.global_position.x + rng.randf_range(-250,250)
	nav_agent.target_position.y = player.global_position.y + rng.randf_range(-350,-100)

func _on_timer_timeout():
	makepath()
