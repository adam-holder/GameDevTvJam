extends Control
@onready var action1 = $Buttons/Action1
@onready var action2 = $Buttons/Action2
@onready var player_items = $HBoxContainer/LeftBox/PlayerItems
@onready var storage_items = $HBoxContainer/RightBox/StorageItems



var counter = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel") and self.visible == true:
		player_items.clear()
		storage_items.clear()
	if event.is_action_pressed("inventory") and self.visible == true:
		player_items.clear()
		storage_items.clear()


func list_items(picons,pitems,sicons,sitems):
	for i in pitems:
		player_items.add_item(i, load(picons[counter]), true)
		counter += 1
	counter = 0
	for i in sitems:
		storage_items.add_item(i, load(sicons[counter]), true)
		counter += 1
	counter = 0
	self.visible = true


func _on_close_pressed():
	self.visible = false
	player_items.clear()
	storage_items.clear()
