extends bullet_base

func _ready() -> void:
	super._ready()
	sprite.flip_h = true

func test(flip):
	if !flip:
		rotation -= 45
	else:
		rotation += 45

func attack(body):
	if body.has_method("take_damage") and not body.has_method("player") and not body in attacked:
		attacked.append(body)
		body.take_damage(damage)
		queue_free()
