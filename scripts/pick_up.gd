extends Area2D

@export var item: ItemData

@onready var label: Label = $Label
@onready var sprite: Sprite2D = $Sprite2D

var player = null
var pickupable = false

func _ready() -> void:
	label.visible = false
	sprite.texture = item.texture.get_frame_texture("idle", 0)
	label.text = "Pick up %s [f]" % item.name

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pick_up") and pickupable:
		player.collect(item)
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		label.visible = true
		pickupable = true
		player = body

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		label.visible = false
		pickupable = false
