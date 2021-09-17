extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var transition_play = $TransitionPlay
onready var player = $Player
# Called when the node enters the scene tree for the first time.
signal freeze_player
signal unfreeze_player

func _ready():
	modulate.a = 0
	transition_play.play("transition")

func freeze_player():
	player.freeze()


func unfreeze_player():
	player.unfreeze()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
