tool
class_name BulletSpawner
extends Position2D

# Called whenever a shot is ready and shooting is false
signal shot_ready()

# Scene to use as a bullet, it's script needs to extend Bullet
export var bullet_scene: PackedScene
# time between shots
export var shot_delay: float = .1
# speed of the emitted bullets
export var bullet_speed: float = 400
# the emitter to be used for spawning bullets (controls behaviour)
var bullet_emitter: BulletEmitter

# offset to the rotation, added to BulletSpawners rotation
var rotation_offset: float = 0.0

var can_shoot: bool = false

onready var timer := Timer.new()

func _ready() -> void:
	if Engine.editor_hint:
		return
	add_child(timer)
	timer.wait_time = shot_delay
	timer.one_shot = false
	timer.autostart = false
	timer.connect("timeout", self, "_shoot")
	if bullet_emitter:
		bullet_emitter.setup(self, bullet_scene)
	else:
		printerr("emitter in BulletSpawner is not a BulletEmitter!")
		queue_free()

func set_shooting(val: bool) -> void:
	if val:
		can_shoot = true
		if timer.is_stopped():
			_shoot()
			timer.start()
	else:
		if !val:
			can_shoot = false

func _shoot() -> void:
	if not can_shoot:
		timer.stop()
		emit_signal("shot_ready")
		return
	var shoot_dir = Vector2.RIGHT.rotated(rotation + rotation_offset).normalized()
	bullet_emitter.shoot(global_position, shoot_dir, bullet_speed)

# Workaround for resource list
func _get_property_list() -> Array:
	var exported_resource_property: Dictionary = {
		"name":"bullet_emitter",
		"type":TYPE_OBJECT,
		"hint":PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "BulletEmitter",
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		}
	return [exported_resource_property]
