class_name BulletEmitter
extends Resource

signal shoot_bullet(position, dir, speed)

# needs to be overwritten by children!
func shoot(position: Vector2, dir: Vector2, speed: float):
	pass

func shoot_single(position: Vector2, dir: Vector2, speed: float):
	emit_signal("shoot_bullet", position, dir, speed)
