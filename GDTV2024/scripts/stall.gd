extends Node2D

@onready var ready_stall = $ReadyStall
@onready var broken_stall = $BrokenStall

var is_holding_item: bool = false
var is_ready_to_present: bool = false

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
	## Player is no longer holding item
	
func remove_item_from_stall():
	is_holding_item = false
	## Player is now holding an item
