extends ItemData

class_name BowData

@export var damage: int
@export var arrow: PackedScene = preload("res://resources/items/Weapons/bow/arrow.tscn")
@export var distance_from_player := 13
@export var smooth_follow := 10.0
