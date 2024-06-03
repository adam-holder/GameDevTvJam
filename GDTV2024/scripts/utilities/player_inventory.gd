extends Control
@onready var action1 = $Buttons/Action1
@onready var action2 = $Buttons/Action2
@onready var player_items = $HBoxContainer/LeftBox/PlayerItems
@onready var storage_items = $HBoxContainer/RightBox/StorageItems
@onready var player_controller = $"../PlayerController"
@onready var storage_controller = $"../StorageController"
@onready var capacity_label = $CapacityLabel

var storage_capacity: int
var counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	capacity_label.text = str(storage_items.item_count)+"/"+str(storage_capacity)+" Slots Used"


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
	capacity_label.text = str(storage_items.item_count)+"/"+str(storage_capacity)+" Slots Used"
	self.visible = true


func _on_close_pressed():
	self.visible = false
	player_items.clear()
	storage_items.clear()


func _on_right_pressed():
	if player_items.is_anything_selected():
		if storage_items.item_count < storage_capacity:
			var items_to_move = player_items.get_selected_items()
			for i in items_to_move: #itemlist array is adjusting item#, need to adjust player inventory to match
				storage_items.add_item(player_items.get_item_text(i),player_items.get_item_icon(i))
				storage_controller.add_from_inv(player_controller.item_inventory[i])
				player_controller.send_to_storage(i)
				player_items.remove_item(i)
				capacity_label.text = str(storage_items.item_count)+"/"+str(storage_capacity)+" Slots Used"

func _on_left_pressed():
	if storage_items.is_anything_selected():
		var items_to_move = storage_items.get_selected_items()
		for i in items_to_move: #itemlist array is adjusting item#, need to adjust player inventory to match
			player_items.add_item(storage_items.get_item_text(i),storage_items.get_item_icon(i))
			player_controller.add_from_inv(storage_controller.storage_items[i])
			storage_controller.send_to_inv(i)
			storage_items.remove_item(i)
			capacity_label.text = str(storage_items.item_count)+"/"+str(storage_capacity)+" Slots Used"
