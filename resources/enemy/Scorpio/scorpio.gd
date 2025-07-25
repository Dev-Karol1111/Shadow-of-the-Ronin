extends EnemyBase


func _physics_process(_delta: float) -> void:
	super._physics_process(_delta)
	
	if is_dead:
		return
	if player and !good_relation:
		sprite.flip_h = true
		sprite.flip_v = true
		
		var direction = (player.position - position).normalized()
		velocity = direction * move_speed
		
		sprite.flip_v = direction.x < 0
		
		look_at(player.position)
		move_and_slide()
