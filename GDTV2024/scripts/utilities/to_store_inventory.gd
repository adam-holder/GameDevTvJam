extends Control

@onready var available_items: ItemList = $AvailableItems
@onready var place_label: Label = $PlaceLabel
@onready var store: Node2D = $".."



var counter = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel") and self.visible == true:
		self.visible = false
		available_items.clear()
	if event.is_action_pressed("inventory") and self.visible == true:
		self.visible = false
		available_items.clear()


func list_items(icons,items):
	for i in items:
		available_items.add_item(i, load(icons[counter]), true)
		counter += 1
	self.visible = true
	counter = 0


func _on_take_all_pressed():
	self.visible = false
	available_items.clear()


func _on_close_pressed():
	self.visible = false
	available_items.clear()


func _on_table_top_open_inventory():
	show_inventory("Table - Top")


func _on_table_mid_open_inventory():
	show_inventory("Table - Mid")


func _on_table_bottom_open_inventory():
	show_inventory("Table - Bottom")


func show_inventory(place):
	place_label.text = "Select Item for "+place
	var player_items = store.player_items
	var picons : Array = []
	var pitems : Array = []
	for i in player_items:
		var name_cost: String = str(player_items[i]["name"]+" - "+str(player_items[i]["value"]))
		pitems.append(name_cost)
		picons.append(player_items[i]["icon"])
	print(pitems)
	list_items(picons, pitems)
	self.visible = true

func _on_select_pressed() -> void:
	if available_items.is_anything_selected():
		var item_to_sell = available_items.get_selected_items()
		for i in item_to_sell: 
			print(i)
