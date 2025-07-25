extends CharacterBody2D

class_name Player

signal health_changed

const SPEED = 75.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sword: Area2D = $sword
@export var inventory: Inventory
@export var max_hp: int = 100

var current_hp

func _ready() -> void:
	current_hp = max_hp

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		sword.attack()
	
	var direction_horizontal := Input.get_axis("left", "right")
	if direction_horizontal:
		sprite.flip_h = (direction_horizontal < 0)
		sprite.play("run")
		velocity.x = direction_horizontal * SPEED
	else:
		sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var direction_vertical := Input.get_axis("up", "down")
	if direction_vertical:
		velocity.y = direction_vertical * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()

func player():
	pass

func collect(item):
	inventory.insert(item)

func take_damage(damage: int) -> void:
	current_hp -= damage
	health_changed.emit()
