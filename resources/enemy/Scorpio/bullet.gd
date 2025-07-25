extends bullet_base

func attack(body):
	if body.has_method("take_damage") and body.has_method("player"):
		body.take_damage(damage)
		queue_free()
