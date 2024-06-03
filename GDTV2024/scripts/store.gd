extends Node2D

## GUI
@onready var hud = $HUD
@onready var preferred_item_prompt = $PreferredItemPrompt
@onready var player_inventory = $PlayerInventory
@onready var robot_inventory = $RobotInventory
@onready var melt_prompt = $MeltPrompt
@onready var dialogue_2 = $MeltPrompt/Dialogue2


## Controllers
@onready var robot = $RobotController
@onready var player = $PlayerController
@onready var storage = $StorageController

## Buttons
@onready var upgrades_button = $UpgradesButton
@onready var inventory_button = $InventoryButton
@onready var open_button = $OpenButton

@onready var last_stand = $LastStand

const BLANK = preload("res://visuals/blank.png")

@export_category("Game Settings")
## Total number of days the game will go for
@export var total_days: int = 7
## Total amount of money to be owed to Nom Took
@export var total_owed: int = 9999
## Times of day
@export var times: Array = ["Morning","Afternoon","Night"]
@export var starting_items: int = 6
@export var storage_max: int = 6
@export var base_appeal: float = 0.50

var money: int
var resources: int
var day: int = 0
var time: String = times[0]
var payed: int
var day_favorite: String
var day_appeal: float
var item_pref: String
var appeal: float = 0.0
var items_sold:int = 0

var save_exists: bool = false
var items = Items.new()

var robot_items : Dictionary = {}
var player_items: Dictionary = {}
var storage_items: Dictionary = {}
var store_items: Dictionary = {}

const TARGET = preload("res://scenes/target.tscn")
const CUSTOMER = preload("res://scenes/customer.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	if save_exists:
		pass #TODO: create load function to bring in save data
	else:
		hud.change_value("total",total_owed)
		hud.change_value("time",time)
		hud.change_value("day",day)
		morning_phase()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event.is_action_pressed("inventory"):
		if player_inventory.visible == true:
			player_inventory.visible = false
		if player_inventory.visible == false and robot_inventory.visible == false:
			send_item_list()
			print(player_items)
			player_inventory.visible = true
	if event.is_action_pressed("ui_cancel"):
		if player_inventory.visible == true:
			player_inventory.visible = false
		if robot_inventory.visible == true:
			robot_inventory.visible == false


func morning_phase():
	# update the day count
	time = times[0]
	hud.change_value("time",time)
	day += 1
	hud.change_value("day",1)
	upgrades_button.visible = true
	inventory_button.visible = true
	open_button.visible = true
	player_inventory.storage_capacity = storage_max
	# add any queued resources to the resource total
	resources = 6 #TODO: REMOVE
	resources += player.queued_resources
	hud.resources = resources
	player.queued_resources = 0
	player.resources = resources
	appeal = base_appeal
	#update store vars with controller vars
	update_items()
	
	if day < total_days:
		if day == 1: 
			robot_items = robot.generate_loot(starting_items)
			var inventory: Array = []
			var inventory_icons: Array = []
			for i in robot_items:
				var name_cost: String = str(robot_items[i]["name"])+" - "+str(robot_items[i]["value"])
				inventory.append(name_cost)
				inventory_icons.append(robot_items[i]["icon"])
			robot_inventory.list_items(inventory_icons,inventory)
			player.add_from_robot(robot.robot_items)
			player_items = player.item_inventory
		elif day == 2:
			robot_items = robot.generate_loot(starting_items, item_pref)
			var inventory: Array = []
			var inventory_icons: Array = []
			for i in robot_items:
				var name_cost: String = str(robot_items[i]["name"])+" - "+str(robot_items[i]["value"])
				inventory.append(name_cost)
				inventory_icons.append(robot_items[i]["icon"])
			robot_inventory.list_items(inventory_icons,inventory)
			player.add_from_robot(robot.robot_items)
			player_items = player.item_inventory
		else:
			robot_items = robot.generate_loot(starting_items, item_pref)
			var inventory: Array = []
			var inventory_icons: Array = []
			for i in robot_items:
				var name_cost: String = str(robot_items[i]["name"])+" - "+str(robot_items[i]["value"])
				inventory.append(name_cost)
				inventory_icons.append(robot_items[i]["icon"])
			robot_inventory.list_items(inventory_icons,inventory)
			player.add_from_robot(robot.robot_items)
			player_items = player.item_inventory
	else: #FINAL DAY
		pass


func afternoon_phase():
	time = times[1]
	hud.change_value("time",time)
	upgrades_button.visible = false
	inventory_button.visible = false
	open_button.text = "Close Stand"
	calculate_appeal()
	compile_targets()
	spawn_customer()
	if day < total_days:
		if day == 1:
			pass
		elif day == 2:
			pass
		else:
			pass
	else: #FINAL DAY
		pass


func evening_phase():
	time = times[2]
	open_button.visible = false
	hud.change_value("time",time)
	stock_to_inv()
	if day < total_days:
		if day == 1:
			melt_dialogue()
			set_day_favorite_type()
			preferred_item_prompt.display(day_favorite)
		elif day == 2:
			set_day_favorite_type()
			preferred_item_prompt.display(day_favorite)
		else:
			set_day_favorite_type()
			preferred_item_prompt.display(day_favorite)
	else: #FINAL DAY
		if payed >= total_owed:
			ending("good")
		else:
			ending("bad")


func _on_button_pressed():
	#SceneManager.SwitchScene("Ending")
	#set_day_favorite_type()
	if time == times[0]:
		afternoon_phase()
	elif time == times[1]:
		evening_phase()
	elif time == times[2]:
		morning_phase()


func set_day_favorite_type():
	day_favorite = items.item_types.pick_random()
	hud.select_announcement(day_favorite)


func inv_to_storage():
	#TODO: show inventory, allow selecting multipe, add keys to array
	# on accept call this function
	var selected: Array = []
	for i in selected:
		var sitem = player.send_to_storage(selected[i-1])
		storage.add_item_to_storage(sitem)


func storage_to_inv():
	#TODO: show inventory, allow selecting multipe, add keys to array
	# on accept call this function
	var selected: Array = []
	for i in selected:
		var sitem = storage.send_to_inv(selected[i-1])
		player.add_item_to_inv(sitem)

func stock_to_inv():
	var found: Dictionary = {}
	var count = 0
	for i in store_items: #TODO: make seperate function/move to inv or controller script?
		print("i: ",store_items[i])
		var itype = store_items[i]["type"]
		var irare = store_items[i]["rarity"]
		if itype == "weapon":
			if irare == "common":
				for j in items.weapon_common:
					if items.weapon_common[j]["name"] == store_items[i]["name"]:
						found[player_items.keys().size()+count] = items.weapon_common[j]
			if irare == "rare":
				for j in items.weapon_rare:
					if items.weapon_rare[j]["name"] == (store_items[i]["name"]):
						found[store_items.keys().size()+count] = items.weapon_rare[j]
		if itype == "valuable":
			if irare == "common":
				for j in items.valuable_common:
					if items.valuable_common[j]["name"] == (store_items[i]["name"]):
						found[store_items.keys().size()+count] = items.valuable_common[j]
			if irare == "rare":
				for j in items.valuable_rare:
					if items.valuable_rare[j]["name"] == (store_items[i]["name"]):
						found[store_items.keys().size()+count] = items.valuable_rare[j]
		if itype == "med":
			if irare == "common":
				for j in items.med_common:
					if items.med_common[j]["name"] == (store_items[i]["name"]):
						found[store_items.keys().size()+count] = items.med_common[j]
			if irare == "rare":
				for j in items.med_rare:
					if items.med_rare[j]["name"] == (store_items[i]["name"]):
						found[store_items.keys().size()+count] = items.med_rare[j]
		if itype == "book":
			if irare == "common":
				for j in items.book_common:
					if items.book_common[j]["name"] == (store_items[i]["name"]):
						found[store_items.keys().size()+count] = items.book_common[j]
			if irare == "rare":
				for j in items.book_rare:
					if items.book_rare[j]["name"] == (store_items[i]["name"]):
						found[store_items.keys().size()+count] = items.book_rare[j]
		if itype == "food":
			if irare == "common":
				for j in items.food_common:
					if items.food_common[j]["name"] == (store_items[i]["name"]):
						found[store_items.keys().size()+count] = items.food_common[j]
			if irare == "rare":
				for j in items.food_rare:
					if items.food_rare[j]["name"] == (store_items[i]["name"]):
						found[store_items.keys().size()+count] = items.food_rare[j]
		count += 1
	print("found: ",found)
	print("player inventory (store): ", player_items)
	print("player inventory (player): ", player.item_inventory)
	player.item_inventory.merge(found)
	print("post append: ", player.item_inventory)
	update_items("player")
	#send_item_list()
	

func update_items(type = "all"):
	if type == "all":
		robot_items = robot.robot_items
		player_items = player.item_inventory
		storage_items = storage.storage_items
	if type == "robot":
		robot_items = robot.robot_items
	if type == "player":
		player_items = player.item_inventory
	if type == "storage":
		storage_items = storage.storage_items


func send_item_list():
	var picons : Array = []
	var pitems : Array = []
	var sicons : Array = []
	var sitems : Array = []
	for i in player_items:
		var name_cost: String = str(player_items[i]["name"]+" - "+str(player_items[i]["value"]))
		pitems.append(name_cost)
		picons.append(player_items[i]["icon"])
	for i in storage_items:
		var name_cost: String = str(storage_items[i]["name"]+" - "+str(storage_items[i]["value"]))
		sitems.append(name_cost)
		sicons.append(player_items[i]["icon"])
	player_inventory.list_items(picons, pitems, sicons, sitems)


func melt_dialogue():
	dialogue_2.text = "Currently you have "+str(player_items.keys().size())+" items in your inventory, and "+str(storage_items.keys().size())+" out of "+str(storage_max)+" items in your storage."
	melt_prompt.visible = true
	#await get_tree().create_timer(2.0).timeout
	#TODO: dialogue for "do you want to melt x remaining items for upgrade material?
	#TODO: button options for melt & open inventory
	
func ending(type):
	if type == "good":
		SceneManager.SwitchScene("Ending")
	if type == "bad":
		SceneManager.SwitchScene("Ending")


func _on_preferred_item_prompt_pref_changed(pref):
	item_pref = pref


func _on_to_store_inventory_item_assigned(key, node, item):
	store_items[node] = item
	print(store_items.keys())
	player.send_to_storage(key) #remove item from inventory & adjust keys

func compile_targets():
	for k in len(store_items.keys()):
		var target_instance = TARGET.instantiate()
		target_instance.global_position = get_node(store_items.keys()[k]).global_position
		print(target_instance)
		print(target_instance.global_position)
		var targetCollection = get_tree().get_nodes_in_group("navTargets")[0]
		#get_node(store_items.keys()[k])
		targetCollection.add_child(target_instance)
		#target_instance.connect("body_entered", target_instance._on_body_entered)

func spawn_customer():
	print("I would like to talk to your manager")
	var new_customer = CUSTOMER.instantiate()
	new_customer.position = Vector2(0,0)
	$LastStand.add_child(new_customer)
	items_sold = 0
	
func shopping():
	if items_sold == 0:
		for i in store_items.keys().size():
			var chance = randf()
			print("chance: ",chance)
			if chance < appeal:
				money += store_items[store_items.keys()[i]]["price"]
				hud.change_value("money",store_items[store_items.keys()[i]]["price"])
				print("buying "+store_items[store_items.keys()[i]]["name"])
				print(store_items.keys()[i])
				var node = get_node(NodePath(store_items.keys()[i]))
				print(node)
				var node_icon = node.find_child("ItemSlot")
				print(node_icon)
				node_icon.texture = BLANK
				items_sold = 1
				break
				#TODO: send signal to customer to go home immediately
	
func calculate_appeal():
	var stock_count = float(store_items.keys().size())
	var total_spots = float(last_stand.total_spots)
	var items_appeal = stock_count/100 
	var stocked_appeal = ((total_spots/stock_count)/total_spots)/5
	var favorite_appeal: float = 0.0
	if day_favorite != "":
		var count = 0
		for i in store_items:
			if store_items[i]["type"] == day_favorite:
				count+=1
		favorite_appeal = (count/total_spots)/5
	var rare_appeal: float = 0.0
	var rcount = 0
	for i in store_items:
		if store_items[i]["rarity"] == "rare":
			rcount += 1
	rare_appeal = (rcount/total_spots)/10
	var upgrades_appeal = float(last_stand.upgrade_level)/100
	appeal += (items_appeal + stocked_appeal + upgrades_appeal + rare_appeal + favorite_appeal)
	if appeal > 1:
		appeal = 0.99
	print(appeal)


func _on_melt_items_pressed():
	player.melt_items(player_items)
	melt_prompt.visible = false


func _on_manage_items_pressed():
	send_item_list()
	melt_prompt.visible = false
