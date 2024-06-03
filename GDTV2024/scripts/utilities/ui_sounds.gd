extends Node

@export var root_path : NodePath

@onready var sounds = {
	&"UI_button_beep" : AudioStreamPlayer.new(),
	&"UI_other_popup" : AudioStreamPlayer.new(),
	&"UI_robot_popup" : AudioStreamPlayer.new()
}
# Called when the node enters the scene tree for the first time.
func _ready():
	assert(root_path != null, "Empty root path for UI Sounds!")
	
	for i in sounds.keys():
		sounds[i].stream = load("res://audio/sfx/"+str(i)+".wav")
		sounds[i].bus = &"UI"
		add_child(sounds[i])
		
	install_sounds(get_node(root_path))

func install_sounds(node: Node):
	for i in node.get_children():
		if i is Button:
			#i.mouse_entered.connect(ui_sfx_play.bind(&"SOUND NAME HERE"))
			i.pressed.connect(ui_sfx_play.bind(&"UI_button_beep"))
			
func ui_sfx_play(sound : StringName):
	sounds[sound].play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
