extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var transition_play = $TransitionPlay
onready var player = $Player
onready var canvas_layer = $CanvasLayer
onready var cowboy = $Cowboy
onready var sheriff_appear_play = $SheriffAppear
# Called when the node enters the scene tree for the first time.
signal freeze_player
signal unfreeze_player

func _ready():
	cowboy.visible = false
	Health.cowboy_health = 100
	Health.player_health = 100
	modulate.a = 0
	transition_play.play("transitionIn")
	yield(transition_play, "animation_finished")
	intro()
	
func _physics_process(delta):
	if Health.cowboy_health <= 0:
		win()
		set_physics_process(false)
	if Health.player_health <= 0:
		lose()
		set_physics_process(false)

func intro():
	var new_dialog = Dialogic.start('Intro')
	add_child(new_dialog)
	freeze_player()
	yield(new_dialog, "timeline_end")
	sheriff_enter()

func sheriff_appear():
	sheriff_appear_play.play("sheriff_appear")

func sheriff_enter():
	var new_dialog = Dialogic.start('Sheriff-Enter')
	sheriff_appear()
	add_child(new_dialog)
	yield(new_dialog, "timeline_end")
	unfreeze_player()

func win():
	var new_dialog = Dialogic.start('Outro')
	add_child(new_dialog)
	yield(new_dialog, "timeline_end")
	transition_play.play("transitionOut")

func lose():
	var new_dialog = Dialogic.start('Lose')
	add_child(new_dialog)
	yield(new_dialog, "timeline_end")
	transition_play.play("transitionOut")

func back_to_menu():
	get_tree().change_scene("res://src/main_menu/menu.tscn")

func freeze_player():
	player.freeze()


func unfreeze_player():
	player.unfreeze()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
