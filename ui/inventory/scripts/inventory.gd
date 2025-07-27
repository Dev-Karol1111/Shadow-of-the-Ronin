extends Resource

class_name Inventory

signal update

@export var slots: Array[ InventorySlot ]

func insert(item: ItemData):
	var using_slots = slots.slice(0,12)
	var itemslots = using_slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount += 1
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
	update.emit()

func remove(item: ItemData):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		if itemslots[0].amount > 1:
			itemslots[0].amount -= 1
		else:
			itemslots[0].item = null
	update.emit()
