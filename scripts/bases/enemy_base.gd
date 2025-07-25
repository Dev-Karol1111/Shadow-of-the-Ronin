extends CharacterBody2D

class_name EnemyBase

@export var max_health: int = 100
@export var move_speed: float = 100.0
@export var damage: int = 10
@export var attack_range := 20
@export var bullet_scene: PackedScene

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var bullet_point: Marker2D = $AnimatedSprite2D/bullet_point

var action: String = "idle" #walk,idle,attack,hurt,dead
var is_dead: bool = false

var current_health: int
var good_relation: bool = true
var player = null


func _ready():
	$Range.connect("body_entered", _on_body_entered)
	
	player = get_tree().get_current_scene().get_node("Player")
	current_health = max_health

func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		die()
	else:
		action = "hurt"
		await get_tree().create_timer(0.1).timeout
		await sprite.animation_finished
		action = "walk"

func die():
	is_dead = true
	sprite.play("death")
	await sprite.animation_finished
	queue_free()

func _on_body_entered(body):
	if body.has_method("player"):
		good_relation = false
		action = "walk"
		attack_loop()

func attack():
	action = "attack"
	await sprite.animation_finished
	var coordinates = bullet_point.global_position
	var bullet = bullet_scene.instantiate()
	bullet.global_position = coordinates
	bullet.rotation = rotation
	bullet.damage = damage
	action = "walk"
	
	get_tree().current_scene.add_child(bullet)

func attack_loop() -> void:
	while !good_relation and !is_dead:
		attack()
		await get_tree().create_timer(5.0).timeout

func _physics_process(_delta):
	if is_dead:
		return
	
	if sprite.get_animation() != action or not sprite.is_playing() :
		sprite.play(action)
