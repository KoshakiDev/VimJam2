extends Node2D

export (PackedScene) var transition_scene

onready var anim_play = $AnimationPlayer
onready var art_credit = $ArtCredit
onready var prog_credit = $ProgCredit
onready var sound_credit = $SoundCredit

func _ready():
	$Intro.play()
	art_credit.modulate.a = 0
	prog_credit.modulate.a = 0
	sound_credit.modulate.a = 0
	anim_play.play("xanthosIntro")
	yield(anim_play, "animation_finished")
	anim_play.play("progIntro")
	yield(anim_play, "animation_finished")
	anim_play.play("soundIntro")

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			sceneMove()

func sceneMove():
	get_tree().change_scene("res://src/main_menu/menu.tscn")


func _on_Intro_finished():
	sceneMove()
