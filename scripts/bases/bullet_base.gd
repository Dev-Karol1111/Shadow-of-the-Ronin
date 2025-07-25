extends Area2D

class_name bullet_base

@onready var sprite: Sprite2D = $Sprite2D
@export var speed: int

var attacked: Array
var damage

func _ready() -> void: # set rotation when scene is inicializing 
	attacked.clear()

func _process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: CharacterBody2D) -> void:
	attack(body)

func _on_area_entered(area: Area2D) -> void:
	attack(area)

func attack(_body): #overwrite this with attack func
	pass
