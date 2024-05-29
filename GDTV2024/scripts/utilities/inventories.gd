extends Control
@onready var inventory_type = $InventoryType
@onready var action1 = $Buttons/Action1
@onready var action2 = $Buttons/Action2



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func list_items(type,items):
	if type == "robot":
		inventory_type.text = "Robot Inventory"
		action1.text = "Take All"
		for i in items:
			get_node("ItemList").add_item(i, null, false) #TODO: add item icon links
		self.visible = true
	elif type == "storage":
		inventory_type.text = "Your Storage"
		action1.text = "Move to Inventory"
		#TODO: add items
		self.visible = true
	elif type == "inventory":
		inventory_type.text = "Your Inventory"
		action1.text = "Move to Storage"
		action2.visible = true
		action2.text = "Melt for Resources"
		#TODO: add items
		self.visible = true

func _on_action_1_pressed():
	if action1.text == "Robot Inventory":
		self.visible = false


func _on_action_2_pressed():
	action2.visible = false
	self.visible = false
