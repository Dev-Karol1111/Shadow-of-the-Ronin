extends Resource

class_name InventorySlot

enum SlotType { GENERIC, HELMET, WEAPON }

@export_enum("Generic", "Weapon") var slot_type: String = "Generic"
@export var item: ItemData
@export var amount: int

@export var texture: Texture2D = preload("res://ui/inventory/assets/inv_slot.png")
