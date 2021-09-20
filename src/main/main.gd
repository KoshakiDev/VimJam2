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

onready var player_ui = $CanvasLayer/Control
onready var cowboy_ui = $CanvasLayer/Control2


func _ready():
	player_ui.visible = false
	cowboy_ui.visible = false
	freeze_player()
	freeze_sheriff()
	Health.cowboy_health = 300
	Health.player_health = 100
	modulate.a = 0
	transition_play.play("transitionIn")
	yield(transition_play, "animation_finished")
	
	intro()
#	debug()

func debug():
	var new_dialog = Dialogic.start('Test Dialog')
	add_child(new_dialog)
	yield(new_dialog, "timeline_end")
	unfreeze_player()
	unfreeze_sheriff()
	$CombatIntro.play()
	player_ui.visible = true
	cowboy_ui.visible = true
	

func _physics_process(delta):
	if Health.cowboy_health <= 0:
		win()
		set_physics_process(false)
	if Health.player_health <= 0:
		lose()
		set_physics_process(false)

func intro():
	cowboy.visible = false
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
	unfreeze_sheriff()
	$CombatIntro.play()
	player_ui.visible = true
	cowboy_ui.visible = true

func win():
	player_ui.visible = false
	cowboy_ui.visible = false
	$CombatLoop.stop()
	freeze_sheriff()
	var new_dialog = Dialogic.start('Outro')
	add_child(new_dialog)
	yield(new_dialog, "timeline_end")
	transition_play.play("transitionOut")

func lose():
	player_ui.visible = false
	cowboy_ui.visible = false
	$CombatLoop.stop()
	freeze_sheriff()
	var new_dialog = Dialogic.start('Lose')
	add_child(new_dialog)
	freeze_player()
	yield(new_dialog, "timeline_end")
	unfreeze_player()
	transition_play.play("transitionOut")

func back_to_menu():
	get_tree().change_scene("res://src/main_menu/menu.tscn")

func freeze_player():
	player.freeze()


func unfreeze_player():
	player.unfreeze()

func freeze_sheriff():
	cowboy.freeze()

func unfreeze_sheriff():
	cowboy.unfreeze()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CombatIntro_finished():
	$CombatLoop.play()
