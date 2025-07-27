extends Control

@onready var inventory: Inventory = preload("res://resources/player/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var weapon_slot: Panel = $NinePatchRect/inventory_ui_slot_weapon


var is_open = false

func _ready() -> void:
	inventory.update.connect(update_slots)
	update_slots()
	close()

func update_slots():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])
	
	weapon_slot.update(inventory.slots[12])

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		if is_open:
			close()
		else:
			open()

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false
