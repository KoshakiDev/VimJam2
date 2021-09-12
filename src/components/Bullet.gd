class_name Bullet
extends Node2D

signal on_disable()

export var life_time := 5

# Internal state
var dir: Vector2 = Vector2.RIGHT
var speed: float = 1.0
var shooting: bool = false

onready var collider := $CollisionShape2D

func _ready() -> void:
	shooting = true
	$Timer.connect("timeout", self, "disable")
	set_process(false)
	set_process_input(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
	collider.disabled = true

func enable(pos, dir, speed) -> void:
	self.global_position = pos
	self.dir = dir
	self.speed = speed
	visible = true
	set_physics_process(true)
	collider.disabled = false
#	$Timer.start(life_time)

func disable():
	visible = false
	set_physics_process(false)
	if collider:
		collider.disabled = true
	emit_signal("on_disable")

func _physics_process(delta: float) -> void:
	if shooting:
		position += dir * speed * delta
