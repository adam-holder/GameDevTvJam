extends Node2D
#region --------------Stall Variables---------------------
##Base Left Stall Variables
@onready var base_left_stall_0 = $"Base Left Stall/Stall0"
@onready var base_left_stall_1 = $"Base Left Stall/Stall1"
@onready var base_left_stall_2 = $"Base Left Stall/Stall2"
@onready var base_left_stall_3 = $"Base Left Stall/Stall3"

##Extra Left Stall Variables
@onready var extra_left_stall_0 = $"Extra Left Stall/Stall0"
@onready var extra_left_stall_1 = $"Extra Left Stall/Stall1"
@onready var extra_left_stall_2 = $"Extra Left Stall/Stall2"
@onready var extra_left_stall_3 = $"Extra Left Stall/Stall3"

##Base Right Stall Variables
@onready var base_right_stall_0 = $"Base Right Stall/Stall0"
@onready var base_right_stall_1 = $"Base Right Stall/Stall1"
@onready var base_right_stall_2 = $"Base Right Stall/Stall2"
@onready var base_right_stall_3 = $"Base Right Stall/Stall3"

##Extra Right Stall Variables
@onready var extra_right_stall_0 = $"Extra Right Stall/Stall0"
@onready var extra_right_stall_1 = $"Extra Right Stall/Stall1"
@onready var extra_right_stall_2 = $"Extra Right Stall/Stall2"
@onready var extra_right_stall_3 = $"Extra Right Stall/Stall3"

##Base Right Stall Variables
@onready var top_stall_0 = $"Top Stall/Stall0"
@onready var top_stall_1 = $"Top Stall/Stall1"
@onready var top_stall_2 = $"Top Stall/Stall2"
#endregion ----------------Stall Variables---------------------
var upgrade_level:int = 0
var total_spots: int = 3

func upgrade_stalls():
	upgrade_level += 1
	if upgrade_level == 1:
		## upgrade base left
		base_left_stall_0.set_stall_to_ready()
		base_left_stall_1.set_stall_to_ready()
		base_left_stall_2.set_stall_to_ready()
		base_left_stall_3.set_stall_to_ready()
		total_spots += 4
	if upgrade_level == 2:
		## upgrade base right
		base_right_stall_0.set_stall_to_ready()
		base_right_stall_1.set_stall_to_ready()
		base_right_stall_2.set_stall_to_ready()
		base_right_stall_3.set_stall_to_ready()
		total_spots += 4
	if upgrade_level == 3:
		## upgrade top
		top_stall_0.set_stall_to_ready()
		top_stall_1.set_stall_to_ready()
		top_stall_2.set_stall_to_ready()
		total_spots += 3
	if upgrade_level == 4:
		## upgrade extra left
		extra_left_stall_0.set_stall_to_ready()
		extra_left_stall_1.set_stall_to_ready()
		extra_left_stall_2.set_stall_to_ready()
		extra_left_stall_3.set_stall_to_ready()
		total_spots += 4
	if upgrade_level == 5:
		## upgrade extra right
		extra_right_stall_0.set_stall_to_ready()
		extra_right_stall_1.set_stall_to_ready()
		extra_right_stall_2.set_stall_to_ready()
		extra_right_stall_3.set_stall_to_ready()
		total_spots += 4
