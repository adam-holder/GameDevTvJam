extends Control

@onready var load_game = $ButtonContainer/LoadGame

# Called when the node enters the scene tree for the first time.
func _ready():
	check_for_save()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func check_for_save():
	load_game.hide()
	pass #TODO: check for save, if exists: show load game button


func _on_new_game_pressed():
	SceneManager.SwitchScene("Intro")


func _on_load_game_pressed():
	pass # Replace with function body.


func _on_settings_pressed():
	print("no settings yet") #TODO: add settings menu, hiding button in the meantime


func _on_credits_pressed():
	SceneManager.SwitchScene("Credits")


func _on_quit_pressed():
	SceneManager.QuitGame()
