extends Node2D

export (PackedScene) var transition_scene

onready var anim_play = $AnimationPlayer
onready var timer = $Timer

var switch = false

func _ready():
	anim_play.play("idle")
	timer.start()

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			sceneMove()

func sceneMove():
	get_tree().change_scene("res://src/main/main.tscn")


func _on_Timer_timeout():
	if !switch:
		anim_play.play("switchToPress")
		switch = true
	else:
		anim_play.play("switchToTitle")
		yield(anim_play, "animation_finished")
		anim_play.play("idle")
		switch = false
	timer.start()
