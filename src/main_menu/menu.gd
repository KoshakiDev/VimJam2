extends Node2D

export (PackedScene) var transition_scene

onready var anim_play = $AnimationPlayer
onready var intro_loop = $IntroLoop
onready var transition_play = $TransitionPlay

var switch = false

func _ready():
	intro_loop.play()
	anim_play.play("idle")
	intro_loop.volume_db = 0
	#modulate.a = 255

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			transition_play.play("transition")

func sceneMove():
	get_tree().change_scene("res://src/main/main.tscn")
