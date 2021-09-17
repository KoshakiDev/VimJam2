class_name Gun
extends Node2D


onready var anim_player := $AnimationPlayer
onready var bullet_spawner := $BulletSpawner

func shoot():
	anim_player.play("shoot")
	bullet_spawner.set_shooting(true)
