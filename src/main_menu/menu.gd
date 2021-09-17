extends Node2D

export (PackedScene) var transition_scene

onready var anim_play = $AnimationPlayer
onready var audio_play = $AudioPlay
onready var transition_play = $TransitionPlay

var switch = false

func _ready():
	anim_play.play("idle")
	audio_play.volume_db = 0
	audio_play.play()
	#modulate.a = 255

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			transition_play.play("transition")

func sceneMove():
	get_tree().change_scene("res://src/main/main.tscn")
