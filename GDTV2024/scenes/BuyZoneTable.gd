extends Area2D

func _on_body_entered(body):
	if body.is_in_group("Customer"):	
		print("entered")
		await get_tree().create_timer(randi_range(2,5)).timeout
		print("disabling item")
		self.visible = false
		pass # Replace with function body.
