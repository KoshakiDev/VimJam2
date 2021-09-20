extends KinematicBody2D

export var speed: float = 200
export var bullet_scene: PackedScene
export var bullet_speed: float = 400

var vel: Vector2 = Vector2.ZERO

onready var anim_player := $AnimationPlayer
onready var body := $Body
onready var bullet_spawner: BulletSpawner = $Body/ForearmFront/FrontArm/BulletSpawner
onready var front_arm := $Body/ForearmFront/FrontArm

var freeze = false

func _ready():
	print(bullet_spawner.rotation_offset)

func _physics_process(delta):
	var move_dir := get_input_dir()
	var look_dir := get_shoot_dir()
	
	vel = vel.linear_interpolate(move_dir * speed, .1 if move_dir.length() > 0 else .2)
	
	if vel.length() > 10:
		anim_player.play("walk")
	else:
		anim_player.play("idle")
	
	front_arm.look_at(get_global_mouse_position())
	# Adjust rotation to be facing right instad of down
	front_arm.rotation -= PI/2
	
	bullet_spawner.rotation_offset = look_dir.angle()
	
	if look_dir.x < 0:
		body.scale.x = -1
	else:
		body.scale.x = 1
	
	if freeze:
		return
	vel = move_and_slide(vel)


func get_input_dir() -> Vector2:
	var dir := Vector2.ZERO
	dir.x = Input.get_action_strength("player_move_right") - Input.get_action_strength("player_move_left")
	dir.y = Input.get_action_strength("player_move_down") - Input.get_action_strength("player_move_up")
	return dir.normalized()

func get_shoot_dir() -> Vector2:
	return (get_global_mouse_position() - global_position).normalized()

func shoot(dir: Vector2) -> void:
	bullet_spawner.shoot(dir, bullet_speed)

func _unhandled_input(event):
	if freeze:
		return
	if event.is_action("player_shoot"):
		bullet_spawner.set_shooting(event.is_pressed())
		
		
func freeze():
	freeze = true

func unfreeze():
	freeze = false

func _on_Hitbox_area_entered(area):
	Health.player_health -= 1
	$Hit.play()
	Shake.shake(2.5, .5)
