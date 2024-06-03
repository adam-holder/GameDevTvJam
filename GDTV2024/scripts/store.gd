extends Node2D

## GUI
@onready var hud = $HUD
@onready var preferred_item_prompt = $PreferredItemPrompt
@onready var player_inventory = $PlayerInventory
@onready var robot_inventory = $RobotInventory


## Controllers
@onready var robot = $RobotController
@onready var player = $PlayerController
@onready var storage = $StorageController

## Buttons
@onready var upgrades_button = $UpgradesButton
@onready var inventory_button = $InventoryButton
@onready var open_button = $OpenButton


@export_category("Game Settings")
## Total number of days the game will go for
@export var total_days: int = 7
## Total amount of money to be owed to Nom Took
@export var total_owed: int = 9999
## Times of day
@export var times: Array = ["Morning","Afternoon","Night"]
@export var starting_items: int = 6
@export var storage_max: int = 6

var money: int
var resources: int
var day: int = 0
var time: String = times[0]
var payed: int
var day_favorite: String
var day_appeal: float
var item_pref: String

var save_exists: bool = false
var items = Items.new()

var robot_items : Dictionary = {}
var player_items: Dictionary = {}
var storage_items: Dictionary = {}
var store_items: Dictionary = {}

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
	resources = 6
	resources += player.queued_resources
	hud.resources = resources
	player.queued_resources = 0
	player.resources = resources
	
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
		else:
			robot_items = robot.generate_loot(starting_items, item_pref)
	else: #FINAL DAY
		pass


func afternoon_phase():
	time = times[1]
	hud.change_value("time",time)
	upgrades_button.visible = false
	inventory_button.visible = false
	open_button.visible = false
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
	hud.change_value("time",time)
	if day < total_days:
		if day == 1:
			melt_prompt()
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

func melt_prompt():
	pass
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
	#loop
	#Append.get_node(store_items.keys()[i]).global_position
	player.send_to_storage(key) #remove item from inventory & adjust keys
