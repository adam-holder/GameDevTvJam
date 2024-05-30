extends Control
@onready var inventory_type = $InventoryType
@onready var action1 = $Buttons/Action1
@onready var action2 = $Buttons/Action2
@onready var item_list = $ItemList

var counter = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel") and self.visible == true:
		item_list.clear()
	if event.is_action_pressed("inventory") and self.visible == true:
		item_list.clear()


func list_items(type,icons,items):
	if type == "robot":
		inventory_type.text = "Robot Inventory"
		action1.text = "Take All"
		for i in items:
			item_list.add_item(i, load(icons[counter]), false) #TODO: add item icon links
			counter += 1
		self.visible = true
		counter = 0
	elif type == "storage":
		inventory_type.text = "Your Storage"
		action1.text = "Move to Inventory"
		for i in items:
			item_list.add_item(i,null, true)
		self.visible = true
	elif type == "inventory":
		inventory_type.text = "Your Inventory"
		action1.text = "Move to Storage"
		action2.visible = true
		action2.text = "Melt for Resources"
		for i in items:
			item_list.add_item(i, load(icons[counter]), true)
			counter += 1
		self.visible = true
		counter = 0


func _on_action_1_pressed():
	if inventory_type.text == "Robot Inventory":
		#does nothing because there are no choices to be made & moving done in store.gd
		self.visible = false
		item_list.clear()


func _on_action_2_pressed():
	action2.visible = false
	self.visible = false


func _on_close_pressed():
	self.visible = false
	item_list.clear()
