extends Control

@onready var robot_text = $RobotText
@onready var weapon = $VBoxContainer/Weapons
@onready var valuable = $VBoxContainer/Valuables
@onready var med = $VBoxContainer/Meds
@onready var book = $VBoxContainer/Books
@onready var food = $VBoxContainer/Food
@onready var next = $VBoxContainer/Continue

signal pref_changed(pref)

@export var default_text: String = "What type of item should I prioritize looking for, friend?"
var additional_text: String = ""

var preferred_type: String = ""
var favorite_type: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func display(favorite):
	hide_unhide()
	favorite_type = favorite
	additional_text = "I believe due to the announcement "+favorite_type+"-type items may sell especially well tomorrow."
	robot_text.text = default_text + " " + additional_text
	self.visible = true
	#show node

func _on_weapons_pressed():
	preferred_type = "weapon"
	pref_changed.emit(preferred_type)
	hide_unhide()
	response_dialogue()

func _on_valuables_pressed():
	preferred_type = "valuable"
	pref_changed.emit(preferred_type)
	hide_unhide()
	response_dialogue()

func _on_meds_pressed():
	preferred_type = "med"
	pref_changed.emit(preferred_type)
	hide_unhide()
	response_dialogue()

func _on_books_pressed():
	preferred_type = "book"
	pref_changed.emit(preferred_type)
	hide_unhide()
	response_dialogue()

func _on_food_pressed():
	preferred_type = "food"
	pref_changed.emit(preferred_type)
	hide_unhide()
	response_dialogue()

func _on_continue_pressed():
	self.hide()


func response_dialogue():
	if favorite_type == preferred_type:
		robot_text.text = "Excellent choice! I will endevor to find as many "+favorite_type+"-type items as possible. Sleep well, human."
	else:
		robot_text.text = "As you wish, human. I will look for all the "+favorite_type+"-type items I can. Good night."


func hide_unhide():
	if next.visible == false:
		weapon.visible = false
		valuable.visible = false
		med.visible = false
		book.visible = false
		food.visible = false
		next.visible = true
	else:
		weapon.visible = true
		valuable.visible = true
		med.visible = true
		book.visible = true
		food.visible = true
		next.visible = false
