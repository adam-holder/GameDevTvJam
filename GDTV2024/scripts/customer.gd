extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_tree = $AnimationTree

@export var movement_speed = 80
@export var movement_target: Node2D = null

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
	if movement_target:
		set_movement_target(movement_target.global_position)

	
func set_movement_target(target_point: Vector2):
	navigation_agent.target_position = target_point
	#print("setmove:",navigation_agent.target_position)

func acquire_target():
	print("We out here acquiring targets")
	var stall_targets = get_tree().get_nodes_in_group("navTargets")[0]
	print("Stall Targets",stall_targets)
	var available_targets = stall_targets.get_children()
	print("Available Targets",available_targets)
	if !available_targets.is_empty():
		var new_target = available_targets[0]
		movement_target = new_target
		print("TARGET POSITION",new_target.global_position,"LOCAL",new_target.position)
	
func _physics_process(_delta):

	if !nav_loaded:
		nav_loaded = true
		return
	if movement_target:
		print("Searching for Position:",navigation_agent.target_position)
		navigation_agent.target_position = movement_target.position
		print("Searching for Position:",navigation_agent.target_position)

	else:
		print("I'm about to aquire targets")
		acquire_target()
	if navigation_agent.is_navigation_finished():
		return
	
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	print("Pos:",position)
	print("GlobalPos:",global_position)
	print("Next Pos",next_path_position)
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
