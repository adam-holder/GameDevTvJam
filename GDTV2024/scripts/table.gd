extends Node2D

var is_holding_item: bool = false

func place_item_on_table():
	is_holding_item = true
	## Player is no longer holding item
	
func remove_item_from_table():
	is_holding_item = false
	## Player is now holding an item
