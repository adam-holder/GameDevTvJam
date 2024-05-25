extends Node2D

@onready var hud = $HUD

@export_category("Game Settings")
## Total number of days the game will go for
@export var total_days: int = 7
## Total amount of money to be owed to Nom Took
@export var total_owed: int = 9999

var money: int
var resources: int
var day: int
var time: String
var payed: int

# Called when the node enters the scene tree for the first time.
func _ready():
	hud.change_value("total",total_owed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	SceneManager.SwitchScene("Ending")
