#extends Node2D
extends Sprite2D

@onready var item_slot = $ItemSlot

signal open_inventory(node_path)

var is_holding_item: bool = false
var current_item: Dictionary = {}
var sell_price: int = 0
var value: int = 0

func place_item_on_table():
	is_holding_item = true
	## Player is no longer holding item


func remove_item_from_table():
	is_holding_item = false
	## Player is now holding an item


func _physics_process(delta):
	animate_bounce()


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)):
			if is_holding_item == false:
				open_inventory.emit(get_path())


func set_item(item,price):
	current_item = item
	sell_price = price
	value = current_item["value"]
	item_slot.texture = load(current_item["icon"])


func animate_bounce():
	if is_holding_item == true:
		pass 
		#TODO: bounce ItemSlot.position.y a teeny bit
		#TODO: add DropShadow sprite and adjust DropShadow.scale a teeny bit
	
