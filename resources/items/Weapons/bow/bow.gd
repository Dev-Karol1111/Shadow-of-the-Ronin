extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var firing_point: Marker2D = $firing_point
@onready var player = get_parent().get_parent()

@export var data: BowData

var damage
var bow_name
var arrow
var distance_from_player
var smooth_follow 

var is_attacking: bool


func _ready() -> void:
	sprite.sprite_frames = data.texture
	bow_name = data.name
	damage = data.damage
	arrow = data.arrow
	distance_from_player = data.distance_from_player
	smooth_follow = data.smooth_follow
	
	sprite.flip_h = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		attack()
	
	var player_pos = player.global_position
	var mouse_pos = get_global_mouse_position()

	var direction = (mouse_pos - player_pos).normalized()
	var target_pos = player_pos + direction * distance_from_player

	global_position = global_position.lerp(target_pos, smooth_follow * delta)
	
	
	if mouse_pos.x < player_pos.x:
		sprite.flip_v = true
		player.sprite.flip_h = true
		rotation = direction.angle() - 45
		firing_point.position.y = 10
	else:
		player.sprite.flip_h = player.sprite.flip_h
		sprite.flip_v = false
		rotation = direction.angle() + 45
		firing_point.position.y = -10

func attack():
	sprite.play("attack")
	await sprite.animation_finished
	var coordinates = firing_point.global_position
	var arrow_scene = arrow.instantiate()
	arrow_scene.global_position = coordinates
	arrow_scene.rotation = rotation
	arrow_scene.damage = damage
	arrow_scene.test(sprite.flip_v)
	
	get_tree().current_scene.add_child(arrow_scene)
