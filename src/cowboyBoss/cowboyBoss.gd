extends Node2D


onready var anim_player := $AnimationPlayer
onready var gun = $Gun
onready var vision_area = $VisionArea


var rotation_speed

func _ready():
	anim_player.play("idle")

func rotateToTarget(target, delta):
	var direction = (target.global_position - global_position)
	var angle_to = gun.transform.x.angle_to(direction)
	gun.rotate(sign(angle_to) * min(delta * rotation_speed, abs(angle_to)))

func _on_VisionArea_body_entered(body, delta):
	rotateToTarget(body, delta)

func _on_Hitbox_area_entered(area):
	Health.cowboy_health -= 1
	$Hit.play()
