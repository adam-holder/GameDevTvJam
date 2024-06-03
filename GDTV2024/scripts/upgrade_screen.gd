extends Control

@onready var last_stand = $"../LastStand"
@onready var upgrade_items = $UpgradeItems
@onready var player_controller = $"../PlayerController"
@onready var resources_label = $ResourcesLabel
@onready var hud = $"../HUD"

@export var upgrade_types: Array = ["Stall"]
@export var max_stall_upgrade: int = 5
@export var stall_upgrade_costs: Array[int] = [2,4,6,8,10]

var stall_upgrade_level: int

# Called when the node enters the scene tree for the first time.
func _ready():
	stall_upgrade_level = last_stand.upgrade_level
	print(stall_upgrade_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func list_upgrades():
	upgrade_items.clear()
	for i in max_stall_upgrade:
		if stall_upgrade_level < i:
			upgrade_items.add_item("Stall Upgrade LVL "+str(i+1)+" \n- "+str(stall_upgrade_costs[i])+" Materials",null,false)
		else:
			if stall_upgrade_level > i:
				upgrade_items.add_item("LVL "+str(i+1)+" Already Purchased",null,false)
			else:
				upgrade_items.add_item("Stall Upgrade LVL "+str(i+1)+" \n- "+str(stall_upgrade_costs[i])+" Materials")

func show_upgrades():
	list_upgrades()
	resources_label.text = "Materials: "+str(player_controller.resources)
	self.visible = true

func _on_close_pressed():
	self.visible = false


func _on_purchase_label_pressed():
	if upgrade_items.is_anything_selected():
		var upgrade = upgrade_items.get_selected_items()[0]
		if player_controller.resources >= stall_upgrade_costs[upgrade]:
			player_controller.resources -= stall_upgrade_costs[upgrade]
			resources_label.text = "Resources: "+str(player_controller.resources)
			hud.change_value("resources",-stall_upgrade_costs[upgrade])
			last_stand.upgrade_stalls()
			stall_upgrade_level = last_stand.upgrade_level
			self.visible = false
		else:
			print("not enough resources")
