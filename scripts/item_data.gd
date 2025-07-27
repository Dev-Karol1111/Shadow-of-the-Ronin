extends Resource

class_name ItemData

@export_category("Information")
@export var name: String
@export var descryption: String = ""
@export_enum("Food", "Weapon") var item_type: String
@export_category("graphic")
@export var texture: SpriteFrames
