extends CharacterBody2D

@export var speed = 100
@onready var animation_tree = $AnimationTree


func _physics_process(_delta):
	velocity = Vector2.ZERO
	if Input.is_key_pressed(KEY_RIGHT):
		velocity.x += speed
	if Input.is_key_pressed(KEY_LEFT):
		velocity.x -= speed
	if Input.is_key_pressed(KEY_UP):
		velocity.y -= speed
	if Input.is_key_pressed(KEY_DOWN):
		velocity.y += speed
			
	velocity = velocity.normalized()*speed
	
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
