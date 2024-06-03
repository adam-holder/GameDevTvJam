extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_tree = $AnimationTree

@export var movement_speed = 80
@export var movement_target: Node2D = null
@onready var exit = get_node("../Exit")

@onready var store : Node2D


var nav_loaded: bool = false
var can_leave: bool = false
var is_leaving: bool = false


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
	store = get_tree().get_root().get_node("Store")

	
func set_movement_target(target_point: Vector2):
	navigation_agent.target_position = target_point
	#print("setmove:",navigation_agent.target_position)

func acquire_target():
	if !is_leaving:
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
		if !is_leaving:
			print("Searching for Position:",navigation_agent.target_position)
			navigation_agent.target_position = movement_target.position
			print("Searching for Position:",navigation_agent.target_position)
		else:
			navigation_agent.target_position = exit.position

	else:
		if !is_leaving:
			print("I'm about to aquire targets")
			acquire_target()
		else:
			movement_target = exit
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
	print("VELOCITY",velocity)
	move_and_slide()
	if !can_leave:
		await able_to_leave()
	await customer_leaves()
	if position.distance_to(exit.position) < 20:
		queue_free()
	
func able_to_leave():
	if !can_leave:
		print("making able to leave")
		await get_tree().create_timer(5).timeout
		var can_shop = true
		if can_shop == true:
			store.shopping()
			can_shop = false
		can_leave = true

func customer_leaves():
	if !is_leaving:
		print("leaving")
		await get_tree().create_timer(10).timeout
		is_leaving = true

	
	
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
