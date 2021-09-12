class_name BulletSpawner
extends Position2D

# Scene to use as a bullet, it's script needs to extend Bullet
export var bullet_scene: PackedScene
# time between shots
export var shot_delay: float = .1
# speed of the emitted bullets
export var bullet_speed: float = 400
# the emitter to be used for spawning bullets (controls behaviour)
export var emitter: Resource

# offset to the rotation, added to BulletSpawners rotation
var rotation_offset: float = 0
# casted version of emitter
var bullet_emitter: BulletEmitter

onready var timer := Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.wait_time = shot_delay
	timer.one_shot = false
	timer.autostart = false
	timer.connect("timeout", self, "_shoot")
	if emitter is BulletEmitter:
		bullet_emitter = emitter
		bullet_emitter.setup(self, bullet_scene)
	else:
		printerr("emitter in BulletSpawner is not a BulletEmitter!")
		queue_free()

func set_shooting(val: bool) -> void:
	if timer.is_stopped():
		if val:
			timer.start()
	else:
		if !val:
			timer.stop()

func _shoot() -> void:
	var shoot_dir = Vector2.RIGHT.rotated(rotation + rotation_offset).normalized()
	emitter.shoot(global_position, shoot_dir, bullet_speed)
