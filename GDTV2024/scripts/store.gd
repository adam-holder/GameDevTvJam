extends Node2D

@onready var hud = $HUD

@export_category("Game Settings")
## Total number of days the game will go for
@export var total_days: int = 7
## Total amount of money to be owed to Nom Took
@export var total_owed: int = 9999
## Item categories
@export var item_types: Array = ["Weapon","Valuable","Meds","Books","Food"]
## Times of day
@export var times: Array = ["Morning","Afternoon","Night"]

var money: int
var resources: int
var day: int = 1
var time: String = times[0]
var payed: int
var day_favorite: String
var day_appeal: float

var save_exists: bool = false

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
	

func morning_phase():
	if day == 1: 
		pass
	elif day == 2:
		pass
	else:
		pass

func afternoon_phase():
	if day == 1:
		pass
	elif day == 2:
		pass
	else:
		pass
	
func evening_phase():
	if day == 1:
		pass
	elif day == 2:
		pass
	else:
		pass

func _on_button_pressed():
	#SceneManager.SwitchScene("Ending")
	set_day_favorite_type()

func set_day_favorite_type():
	day_favorite = item_types.pick_random()
	print("day favorite set to "+day_favorite)
	hud.select_announcement(day_favorite)
