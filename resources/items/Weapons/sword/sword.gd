extends Area2D

@export var item: SwordData

@onready var player = get_parent().get_parent()
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


var is_attacking: bool
var attacked_things: Array

var damage
var smooth_follow
var distance_from_player

func _ready() -> void:
	is_attacking = false
	damage = item.damage
	smooth_follow = item.smooth_follow
	distance_from_player = item.distance_from_player
	
	sprite.frames = item.texture

func _process(delta):
	if is_attacking:
		for body in get_overlapping_bodies():
			if body.has_method("take_damage") and !body.has_method("player") and !body in attacked_things:
				attacked_things.append(body)
				body.take_damage(damage)
		
		for area in get_overlapping_areas():
			if area.has_method("take_damage") and !area.has_method("player") and !area in attacked_things:
				attacked_things.append(area)
				area.take_damage(0)
	
	var player_pos = player.global_position
	var mouse_pos = get_global_mouse_position()

	var direction = (mouse_pos - player_pos).normalized()
	var target_pos = player_pos + direction * distance_from_player

	global_position = global_position.lerp(target_pos, smooth_follow * delta)
	
	rotation = direction.angle()
	
	if mouse_pos.x < player_pos.x:
		sprite.flip_v = true
		player.sprite.flip_h = true
	else:
		player.sprite.flip_h = player.sprite.flip_h
		sprite.flip_v = false

func attack():
	sprite.play("attack")
	attacked_things.clear()
	is_attacking = true
	await sprite.animation_finished
	is_attacking = false
	attacked_things.clear()
	
