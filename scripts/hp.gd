extends TextureProgressBar

@onready var player: Player = $"../../Player"

func _ready() -> void:
	player.health_changed.connect(update)
	update()

func update():
	value = player.current_hp * 100 / player.max_hp
