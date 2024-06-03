extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_tree = $AnimationTree

@export var movement_speed = 100
@export var movement_target: Node2D

var nav_loaded: bool = false

func _ready():
	#print(movement_target.position)
	#print(movement_target.global_position)
	set_physics_process(false)
	call_deferred("actor_setup")

func actor_setup():
	await get_tree().physics_frame
	set_physics_process(true)
	#print("actorset: ",movement_target.position)
	set_movement_target(movement_target.global_position)

	
func set_movement_target(target_point: Vector2):
	navigation_agent.target_position = target_point
	#print("setmove:",navigation_agent.target_position)
	
func _physics_process(_delta):
	#velocity = Vector2.ZERO
	#if Input.is_key_pressed(KEY_RIGHT):
		#velocity.x += speed
	#if Input.is_key_pressed(KEY_LEFT):
		#velocity.x -= speed
	#if Input.is_key_pressed(KEY_UP):
		#velocity.y -= speed
	#if Input.is_key_pressed(KEY_DOWN):
		#velocity.y += speed
		
	if movement_target:
		navigation_agent.target_position = movement_target.global_position
	if !nav_loaded:
		nav_loaded = true
		return
	
	if navigation_agent.is_navigation_finished():
		return
	
	var current_agent_position: Vector2 = global_position
	#print("Pos:",position)
	#print("GlobalPos:",global_position)

	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	#print("Next Pos",next_path_position)
	#print("targetPos:",movement_target.position)
	#print("goal: ",navigation_agent.target_position)
	
	#velocity = current_agent_position.direction_to(next_path_position).normalized()*movement_speed
	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity*movement_speed
	velocity = new_velocity
	
	move_and_slide()

func _process(_delta):
	if velocity != Vector2.ZERO:
		set_walking(true)
		update_blend_position()
	else:
		set_walking(false)
	
func set_walking(value):
	animation_tree["parameters/conditions/is_walking"] = value
	animation_tree["parameters/conditions/is_idle"] = not value
	
func update_blend_position():
	animation_tree["parameters/Idle/blend_position"] = velocity
	animation_tree["parameters/Walk/blend_position"] = velocity
