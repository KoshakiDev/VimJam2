extends KinematicBody2D

export var speed: float = 200
export var bullet_scene: PackedScene
export var bullet_speed: float = 400


onready var anim_player := $AnimationPlayer
onready var gun = $Body/Gun
onready var vision_area = $Body/VisionArea
onready var body = $Body
onready var bullet_spawner = $Body/Gun/BulletSpawner
onready var wait_timer = $WaitTimer
onready var shoot_ray = $Body/Gun/RayCast2D

var rotation_speed = 60

var vel: Vector2 = Vector2.ZERO

var target

var is_waiting = false

var freeze = false

func _ready():
	anim_player.play("idle")

func search():
	wait_timer.start(1)
	is_waiting = true

func _physics_process(delta):
	if freeze:
		anim_player.play("idle")
		bullet_spawner.set_shooting(false)
		return
	if target != null:
		move(target, delta)
		rotateToTarget(target, delta)
		if shoot_ray.is_colliding():
			bullet_spawner.set_shooting(true)
		else:
			bullet_spawner.set_shooting(false)
		wait_timer.stop()
		is_waiting = false
	elif !is_waiting:
		anim_player.play("idle")
		search()

func move(target, delta):
	anim_player.play("walk")
	var direction = (target.global_position - global_position).normalized()
	if direction.x < 0:
		body.scale.x = -1
	else:
		body.scale.x = 1
		
	vel = vel.linear_interpolate(direction * speed, .1 if direction.length() > 0 else .2)
	vel = move_and_slide(vel)
	
func shoot(dir: Vector2) -> void:
	bullet_spawner.shoot(dir, bullet_speed)

func rotateToTarget(target, delta):
	var direction = (target.global_position - global_position).normalized()
	bullet_spawner.rotation_offset = direction.angle()
	var angle_to = gun.transform.x.angle_to(direction)
	gun.rotate(sign(angle_to) * min(delta * rotation_speed, abs(angle_to)))

func _on_Hitbox_area_entered(area):
	Health.cowboy_health -= 1
	$Hit.play()
	Shake.shake(2.5, .5)


func _on_VisionArea_body_entered(body):
	target = body


func _on_VisionArea_body_exited(body):
	target = null


func _on_WaitTimer_timeout():
	is_waiting = false
	if body.scale.x == 1:
		body.scale.x = -1
		gun.scale.x = -1
		gun.scale.y = -1
	else:
		body.scale.x = 1
		gun.scale.x = 1
		gun.scale.y = 1

func freeze():
	freeze = true

func unfreeze():
	freeze = false
