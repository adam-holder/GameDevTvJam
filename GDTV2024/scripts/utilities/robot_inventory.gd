extends Control

@onready var robot_items = $RobotItems
@onready var take_all = $TakeAll
@onready var robot_label = $RobotLabel


var counter = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel") and self.visible == true:
		self.visible = false
		robot_items.clear()
	if event.is_action_pressed("inventory") and self.visible == true:
		self.visible = false
		robot_items.clear()


func list_items(icons,items):
	for i in items:
		robot_items.add_item(i, load(icons[counter]), false)
		counter += 1
	self.visible = true
	counter = 0


func _on_take_all_pressed():
	self.visible = false
	robot_items.clear()


func _on_close_pressed():
	self.visible = false
	robot_items.clear()

