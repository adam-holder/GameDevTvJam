extends Node2D

var item_inventory: Dictionary = {}
var queued_resources: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func melt_items(inventory: Dictionary):
	for i in inventory.size():
		queued_resources += 1
	inventory.clear()

func add_from_robot(items):
	item_inventory = items
	
	
func add_from_inv(item):
	item_inventory[item_inventory.size()] = item
	
	
func send_to_storage(item_key):
	var send = item_inventory[item_key]
	item_inventory.erase(item_key)
	return send
