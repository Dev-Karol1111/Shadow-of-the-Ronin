extends Panel

@onready var background: Sprite2D = $Sprite2D
@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var amount_text: Label = $CenterContainer/Panel/Label
@onready var action: ColorRect = $action
@onready var player: Player = $"/root/Level/Player"
@onready var grid_container: GridContainer = $"/root/Level/CanvasLayer/Inventory_ui/NinePatchRect/GridContainer"
@onready var inventory_ui_slot: Panel = $"."

const pick_up_scene = preload("res://scenes/pick_up.tscn")
var inv = preload("res://resources/player/player_inventory.tres")

var is_action_opened
var can_close_action_bar
var item 
var slot_data

func _ready() -> void:
	is_action_opened = false
	action.visible = false
	can_close_action_bar = false

func update(slot: InventorySlot):
	item = slot.item
	slot_data = slot
	if !background == slot.texture:
		background.texture = slot.texture
	if slot.slot_type == "Weapon" and $action/Drop:
		$action/Drop.queue_free()
		$action/Line2D.queue_free()
		$action/Use.text = "Unuse"
		action.size.y = 12
		amount_text.modulate.a = 0
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture.get_frame_texture("idle", 0)
		if slot.amount > 1:
			amount_text.visible = true
		amount_text.text = str(slot.amount)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("mouse_right_click") and is_action_opened and can_close_action_bar:
		inventory_ui_slot.custom_minimum_size = Vector2(20,20)
		is_action_opened = false
		action.visible = false
		can_close_action_bar = false
		for slot in grid_container.get_children():
			slot.mouse_filter = MOUSE_FILTER_STOP

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT and !can_close_action_bar and item:# and item.amount > 0:
		inventory_ui_slot.custom_minimum_size = Vector2(48,50)
		for slot in grid_container.get_children():
			slot.mouse_filter = MOUSE_FILTER_IGNORE
		is_action_opened = !is_action_opened
		action.visible = !action.visible
		run_timer()

func run_timer():
	await get_tree().create_timer(0.1).timeout
	can_close_action_bar = true


func _on_use_pressed() -> void:
	inventory_ui_slot.custom_minimum_size = Vector2(20,20)
	action.visible = false
	if slot_data.slot_type == "Generic":
		if item.item_type == "Weapon":
			if inv.slots[12].item:
				var new_item = inv.slots[12].item
				inv.slots[12].item = item
				inv.remove(item)
				inv.insert(new_item)
			else:
				inv.slots[12].item = item
				inv.remove(item)
	elif slot_data.slot_type == "Weapon":
		inv.slots[12].item = null
		inv.insert(item)
func _on_drop_pressed() -> void:
	inventory_ui_slot.custom_minimum_size = Vector2(20,20)
	action.visible = false
	var pick_up = pick_up_scene.instantiate()
	pick_up.item = item
	pick_up.position = player.position
	get_tree().current_scene.add_child(pick_up) 
	inv.remove(item)
