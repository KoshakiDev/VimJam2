tool
class_name BulletSpawner
extends Position2D

# Scene to use as a bullet, it's script needs to extend Bullet
export var bullet_texture: Texture
# time between shots
export var shot_delay: float = .5
# speed of the emitted bullets
export var bullet_speed: float = 100
# The bullets maximum lifetime in seconds before they get deleted
export var max_lifetime: float = 5
# the emitter to be used for spawning bullets (controls behaviour)
# this is exported through _get_property_list() method at the bottom (workaround)
var emitter: BulletEmitter

# offset to the rotation, added to BulletSpawners rotation
var rotation_offset: float = 0

var can_shoot: bool = false

var bullets: Array = []

var bullets_to_destroy := []

onready var timer := Timer.new()
onready var bullet_area := $BulletArea

func setup() -> void:
	if Engine.editor_hint:
		return
	if not emitter:
		printerr("emitter in BulletSpawner is null!")
		queue_free()
		return
	
	emitter.connect("shoot_bullet", self, "spawn_bullet")
	bullet_area.set_as_toplevel(true)
	
	add_child(timer)
	timer.wait_time = shot_delay
	timer.one_shot = false
	timer.autostart = false
	timer.connect("timeout", self, "_shoot")

func spawn_bullet(position: Vector2, dir: Vector2, speed: float) -> void:
	var bullet: BulletRef = BulletRef.new()
	bullet.direction = dir
	bullet.speed = speed
	bullet.current_position = position
	
	_configure_collision_for_bullet(bullet)
	
	bullets.append(bullet)

func _configure_collision_for_bullet(bullet: BulletRef) -> void:
	var bullet_transform := Transform2D(0, bullet.current_position)
	bullet_transform.origin = bullet.current_position
	
	# Create custom collision shape for the bullet
	var bullet_shape_id := Physics2DServer.circle_shape_create()
	Physics2DServer.shape_set_data(bullet_shape_id, 6)
	Physics2DServer.area_add_shape(bullet_area.get_rid(), bullet_shape_id, bullet_transform)
	
	bullet.shape_id = bullet_shape_id

func _physics_process(delta: float) -> void:
	if Engine.editor_hint:
		return
	
	var bullet_transform := Transform2D()
	
	for i in range(bullets.size()):
		var bullet = bullets[i] as BulletRef
		
		if bullet.lifetime >= max_lifetime:
			bullets_to_destroy.append(bullet)
			continue
		
		var offset: Vector2 = bullet.direction * bullet.speed * delta
		
		bullet.current_position += offset
		bullet_transform.origin = bullet.current_position
		Physics2DServer.area_set_shape_transform(bullet_area.get_rid(), i, bullet_transform)
		
		bullet.lifetime += delta
		bullet.animation_lifetime += delta
	
	for bullet in bullets_to_destroy:
		_remove_bullet(bullet)
	bullets_to_destroy.clear()
	
	update()

func _draw() -> void:
	if Engine.editor_hint:
		return
	draw_set_transform_matrix(get_global_transform().affine_inverse())
	
	var offset = bullet_texture.get_size() / 2.0
	for i in range(bullets.size()):
		var bullet = bullets[i] as BulletRef
		draw_texture(bullet_texture, bullet.current_position - offset)

func _exit_tree() -> void:
	if Engine.editor_hint:
		return
	
	for bullet in bullets:
		Physics2DServer.free_rid(bullet.shape_id)
	bullets.clear()

func _remove_bullet(bullet: BulletRef) -> void:
	Physics2DServer.free_rid(bullet.shape_id)
	bullets.erase(bullet)

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
		return
	var shoot_dir = Vector2.RIGHT.rotated(rotation + rotation_offset).normalized()
	emitter.shoot(global_position, shoot_dir, bullet_speed)


# Workaround for resource list export
func _get_property_list() -> Array:
	var exported_resource_property: Dictionary = {
		"name":"emitter",
		"type":TYPE_OBJECT,
		"hint":PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "BulletEmitter",
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		}
	return [exported_resource_property]


func _on_BulletArea_area_shape_entered(area_id, area, area_shape, local_shape):
	bullet_collided(local_shape)

func _on_BulletArea_body_shape_entered(body_id, body, body_shape, local_shape):
	bullet_collided(local_shape)

func bullet_collided(shape_idx: int):
#	var collided_bullet: BulletRef = null
#	for bullet in bullets:
#		var rid = Physics2DServer.area_get_shape(bullet_area.get_rid(), shape_idx)
#		if bullet.shape_id == rid:
#			collided_bullet = bullet
#			break
#	if collided_bullet:
#		bullets_to_destroy.append(collided_bullet)
	pass
