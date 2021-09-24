extends Node2D

#THIS NPC SERVES NO OTHER PURPOSE BUT TO APPEAR IN THE INTRO

onready var anim_play = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_play.play("idle")
