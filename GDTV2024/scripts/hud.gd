extends Control

@onready var day_count = $Datetime/Day
@onready var current_time = $Datetime/Time
@onready var money_amt = $Funds/LabelContainer/Money/MoneyAmt
@onready var resources_amt = $Funds/LabelContainer/Resources/ResourcesAmt
@onready var owed_amt = $Funds/LabelContainer/Owed/OwedAmt
@onready var broadcast_text = $Broadcast/BroadcastText
@onready var broadcast = $Broadcast
@onready var pause_screen = $PauseScreen
@onready var robot_inventory = $"../RobotInventory"
@onready var player_inventory = $"../PlayerInventory"


@export var scroll_speed: int = 500
var paused: bool = false

var day: int:
	set(day_num):
		day = day_num
		print("day was changed")
		day_count.text = "Day "+str(day)+","
var time: String:
	set(time_str):
		time = time_str
		print("time was changed")
		current_time.text = str(time)
var money: int:
	set(m_amt):
		money = m_amt
		print("money was changed")
		money_amt.text = str(money)
var resources: int:
	set(r_amt):
		resources = r_amt
		print("resouces was changed")
		resources_amt.text = str(resources)
var payed: int:
	set(p_amt):
		payed = p_amt
		print("payment was changed")
		owed_amt.text = str(payed)+'/'+str(total_owed)
var total_owed: int:
	set(total):
		total_owed = total
		print("total was changed")
		owed_amt.text = str(payed)+'/'+str(total_owed)
var announcment_type : String = ""

var weapon_announcements: Array = [
	"weapon phrase 0",
	"weapon phrase 1",
	"weapon phrase 2",
	"weapon phrase 3",
	"weapon phrase 4"]
var valuable_announcements: Array = [
	"valuable phrase 0",
	"valuable phrase 1",
	"valuable phrase 2",
	"valuable phrase 3",
	"valuable phrase 4"]
var meds_announcements: Array = [
	"meds phrase 0",
	"meds phrase 1",
	"meds phrase 2",
	"meds phrase 3",
	"meds phrase 4"]
var book_announcements: Array = [
	"book phrase 0",
	"book phrase 1",
	"book phrase 2",
	"book phrase 3",
	"book phrase 4"]
var food_announcements: Array = [
	"food phrase 0",
	"food phrase 1",
	"food phrase 2",
	"food phrase 3",
	"food phrase 4"]


# Called when the node enters the scene tree for the first time.
func _ready():
	day_count.text = 'Day '+str(day)+','
	current_time.text = time
	money_amt.text = str(money)
	resources_amt.text = str(resources)
	owed_amt.text = str(payed)+'/'+str(total_owed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	if broadcast.visible && broadcast_text.position.x > -broadcast_text.size.x && !paused:
		broadcast_text.position.x = lerp(broadcast_text.position.x,broadcast_text.position.x - scroll_speed * delta,0.25 )
	if broadcast.visible && broadcast_text.position.x <= -broadcast_text.size.x:
		broadcast.visible = false
		#TODO: fix jitter & account for text longer than the textbox size

func _input(event):
	#putting this here so we can set HUD to Always process and leave Store at Inherit
	#this lets us unpause after pausing (theoretically)
	#TODO: figure out why pause doesn't pause announcement scroll despite Broadcast & children being set to pausable
	if event.is_action_pressed("ui_cancel") and (robot_inventory.visible == false and player_inventory.visible == false):
		SceneManager.PauseGame()
		if pause_screen.visible:
			paused = false
			pause_screen.visible = false
		else:
			pause_screen.visible = true
			paused = true
	
func select_announcement(type):
	if type == "weapon":
		broadcast_text.text = weapon_announcements.pick_random()
	elif type == "valuable":
		broadcast_text.text = valuable_announcements.pick_random()
	elif type == "med":
		broadcast_text.text = meds_announcements.pick_random()
	elif type == "book":
		broadcast_text.text = book_announcements.pick_random()
	elif type == "food":
		broadcast_text.text = food_announcements.pick_random()
	else:
		broadcast_text.text = "ERROR: INCORRECT TYPE PASSED"
		print("ERROR: INCORRECT TYPE PASSED")
	broadcast.visible = true

func change_value(change_type,amt):
	if change_type == "total":
		total_owed = amt
	if change_type == "payment":
		payed += amt
	if change_type == "money":
		money += amt
	if change_type == "resources":
		resources += amt
	if change_type == "day":
		day += amt
	if change_type == "time":
		time = amt
