extends StaticBody2D

@onready var ready_stall = $ReadyStall
@onready var broken_stall = $BrokenStall
@onready var item_slot = $ItemSlot
@onready var store = $"."

var is_holding_item: bool = false
var is_ready_to_present: bool = false

signal open_inventory(node_path)
var current_item: Dictionary = {}
var sell_price: int = 0
var value: int = 0

func set_stall_to_ready():
	is_ready_to_present = true
	#Visually represent pedestal is ready
	ready_stall.visible = true
	broken_stall.visible = false
	

func place_item_on_stall():
	if !is_ready_to_present:
		print("Can't place item")
		pass
	is_holding_item = true
	self.get_node("BuyZone").visible = true
	#.visable = true
	## Player is no longer holding item
	
func remove_item_from_stall():
	is_holding_item = false
	## Player is now holding an item
	
	
func _physics_process(delta):
	animate_bounce()
	

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if ready_stall.get_rect().has_point(to_local(event.position)):
			if is_holding_item == false and is_ready_to_present == true:
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
