extends Area2D

@export var apple_item: ItemData
var pickup = preload("res://scenes/pick_up.tscn")

func take_damage(_value: int):
	await get_tree().create_timer(0.2).timeout
	queue_free()
	var apple = pickup.instantiate()
	apple.item = apple_item
	apple.global_position = $Marker2D.global_position
	get_tree().current_scene.add_child(apple)
