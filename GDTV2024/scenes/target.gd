extends Area2D


func _on_body_entered(body):
	#print("entered")
	await get_tree().create_timer(randi_range(2,5)).timeout
	#print("removing item")
	queue_free()
	pass # Replace with function body.
