extends Control

@onready var available_items: ItemList = $AvailableItems
@onready var place_label: Label = $PlaceLabel
@onready var store: Node2D = $".."
@onready var item_name_label = $ItemNameLabel
@onready var item_value_label = $ItemValueLabel
@onready var item_desc_label = $ItemDescLabel
@onready var sell_price = $SellPrice
@onready var percentage_diff_label = $PercentageDiffLabel

signal item_assigned(node,item)

var target: Node2D
var inv_key = -1
var counter = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.visible:
		if inv_key != -1: #TODO: move to own function or setter for better performance
			var perc = sell_price.value/store.player_items[inv_key]["value"]
			var red: Color = Color.RED
			var white: Color = Color.WHITE
			var green: Color = Color.GREEN
			var mperc = 0
			if perc > 1:
				mperc = perc-1
			if perc < 1:
				mperc = 1-perc
			var dperc = int(mperc*100)
			percentage_diff_label.text = str(dperc)+"% Difference"
			if perc >= 1:
				percentage_diff_label.modulate = red.lerp(white,1.0/perc)
			if perc < 1:
				percentage_diff_label.modulate = green.lerp(white, 1.0/(mperc+1))


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


func _on_table_top_open_inventory(source):
	show_inventory("Table - Top")
	target = get_node(source)



func _on_table_mid_open_inventory(source):
	show_inventory("Table - Mid")
	target = get_node(source)


func _on_table_bottom_open_inventory(source):
	show_inventory("Table - Bottom")
	target = get_node(source)


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


func update_description(item_key):
	if item_key >= 0:
		inv_key = item_key
		item_name_label.text = store.player_items[item_key]["name"]
		item_value_label.text = str(store.player_items[item_key]["value"])
		item_desc_label.text = store.player_items[item_key]["desc"]
		sell_price.value = store.player_items[item_key]["value"]
	elif item_key == -1:
		item_name_label.text = ""
		item_value_label.text = ""
		item_desc_label.text = ""
		sell_price.value = 0


func _on_available_items_item_clicked(index, at_position, mouse_button_index):
	var item_to_sell = available_items.get_selected_items()
	for i in item_to_sell: 
		update_description(i)


func _on_up_20_pressed():
	if available_items.is_anything_selected():
		if sell_price.value == store.player_items[inv_key]["value"]:
			print(sell_price.value)
			sell_price.value += int(sell_price.value*0.2)
			print(sell_price.value)


func _on_down_20_pressed():
	if available_items.is_anything_selected():
		if sell_price.value == store.player_items[inv_key]["value"]:
			print(sell_price.value)
			sell_price.value -= int(sell_price.value*0.2)
			print(sell_price.value)


func _on_sell_button_pressed():
	if available_items.is_anything_selected() and sell_price.value > 0:
		target.place_item_on_table()
		var ptarg = target.get_parent()
		var target_icon = ptarg.find_child('ItemSlot')
		target_icon.texture = load(store.player_items[inv_key]["icon"])
		var item: Dictionary = {"name": store.player_items[inv_key]["name"], "value": store.player_items[inv_key]["value"], "price": sell_price.value}
		item_assigned.emit(inv_key,str(ptarg.get_path()),item)
		self.visible = false
		available_items.clear()
		inv_key = -1
		update_description(-1)
