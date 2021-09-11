class_name BulletSpawner
extends Position2D

# Scene to use as a bullet, it's script needs to extend Bullet
export var bullet_scene: PackedScene
# random offset to the angle of the bullets in degree (dir +- this angle)
export var random_angle: float = 10
# time between shots
export var shot_delay: float = .2
# speed of the emitted bullets
export var bullet_speed: float = 400

# offset to the rotation, added to BulletSpawners rotation
var rotation_offset: float = 0
var shooting: bool = false

onready var timer := Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.wait_time = shot_delay
	timer.one_shot = false
	timer.autostart = false
	timer.connect("timeout", self, "_shoot")

func set_shooting(val: bool) -> void:
	if timer.is_stopped():
		if val:
			timer.start()
	else:
		if !val:
			timer.stop()

func _shoot() -> void:
	var bullet: Bullet = bullet_scene.instance()
	var shoot_dir = Vector2.RIGHT.rotated(
		rotation + rotation_offset +
		deg2rad(rand_range(-random_angle, random_angle))
	).normalized()
	bullet.setup(shoot_dir, bullet_speed)
	bullet.set_as_toplevel(true)
	bullet.global_position = global_position
	add_child(bullet)
