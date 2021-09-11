tool
extends Node2D

export var dir: Vector2 = Vector2.RIGHT
export var speed: float = 1.0
export var shooting: bool = false

#func _ready() -> void:
#	shooting = true

func setup(_dir, _speed) -> void:
	dir = _dir
	speed = _speed

func _physics_process(delta: float) -> void:
	if shooting:
		position += dir * speed * delta
