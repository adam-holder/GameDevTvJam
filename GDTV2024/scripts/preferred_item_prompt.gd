extends Control

@onready var robot_text = $RobotText

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
	favorite_type = favorite
	additional_text = "I believe due to the announcement "+favorite_type+"-type items may sell especially well tomorrow."
	robot_text.text = default_text + " " + additional_text
	self.visible = true
	#show node

func _on_weapons_pressed():
	preferred_type = "weapon"
	pref_changed.emit(preferred_type)
	#disable other buttons
	if favorite_type == preferred_type:
		robot_text.text = "Excellent choice! I will endevor to find as many "+favorite_type+"-type items as possible. Sleep well, human."
	else:
		robot_text.text = "As you wish, human. I will look for all the "+favorite_type+"-type items I can. Good night."
	#timer?
	#hide node

func _on_valuables_pressed():
	preferred_type = "valuable"
	pref_changed.emit(preferred_type)


func _on_meds_pressed():
	preferred_type = "med"
	pref_changed.emit(preferred_type)


func _on_books_pressed():
	preferred_type = "book"
	pref_changed.emit(preferred_type)


func _on_food_pressed():
	preferred_type = "food"
	pref_changed.emit(preferred_type)
