extends Node2D

var storage_items: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_from_inv(item):
	storage_items[storage_items.size()] = item
	
func send_to_inv(item_key):
	if item_key+1 == storage_items.size():
		storage_items.erase(item_key)
	else:
		for i in storage_items.size()-(item_key+1):
			var k = item_key+i
			print("k: ",k)
			storage_items[k] = storage_items[k+1]
		storage_items.erase(storage_items.size()-1)
