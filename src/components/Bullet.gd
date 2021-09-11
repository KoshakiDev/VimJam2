class_name Bullet
extends Node2D

# Internal state
var dir: Vector2 = Vector2.RIGHT
var speed: float = 1.0
var shooting: bool = false

func _ready() -> void:
	shooting = true

func setup(dir, speed) -> void:
	self.dir = dir
	self.speed = speed

func _physics_process(delta: float) -> void:
	if shooting:
		position += dir * speed * delta
