extends Node2D

@onready var ready_stall = $ReadyStall
@onready var broken_stall = $BrokenStall

func set_stall_to_ready():
	ready_stall.visible = true
	broken_stall.visible = false
