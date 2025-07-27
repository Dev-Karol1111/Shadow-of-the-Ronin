extends CharacterBody2D

class_name Player

signal health_changed

@export var speed = 75.0
@export var inventory: Inventory
@export var max_hp: int = 100

@onready var weapon_slot: Node2D = $weapon_slot
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var current_hp
var equiped_weapon
var weapon

func _ready() -> void:
	current_hp = max_hp
	equip_weapon()
	
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		weapon.attack()
	
	var direction_horizontal := Input.get_axis("left", "right")
	if direction_horizontal:
		sprite.flip_h = (direction_horizontal < 0)
		sprite.play("run")
		velocity.x = direction_horizontal * speed
	else:
		sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, speed)
	
	var direction_vertical := Input.get_axis("up", "down")
	if direction_vertical:
		velocity.y = direction_vertical * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	
	move_and_slide()

func _process(_delta: float) -> void:
	equip_weapon()

func equip_weapon():
	var test_weapon = inventory.slots[12].item
	if !test_weapon == equiped_weapon:
		equiped_weapon = test_weapon
		for wep in weapon_slot.get_children():
			wep.queue_free()
		if !equiped_weapon:
			return
		if equiped_weapon.weapon_type == "sword":
			weapon = preload("res://resources/items/Weapons/sword/sword.tscn").instantiate()
			weapon.item = equiped_weapon
			weapon_slot.add_child(weapon)
		elif equiped_weapon.weapon_type == "bow":
			weapon = preload("res://resources/items/Weapons/bow/bow.tscn").instantiate()
			weapon.data = equiped_weapon
			weapon_slot.add_child(weapon)

func player():
	pass

func collect(item):
	inventory.insert(item)

func take_damage(damage: int) -> void:
	current_hp -= damage
	health_changed.emit()
