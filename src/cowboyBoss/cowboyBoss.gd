extends Node2D


onready var anim_player := $AnimationPlayer
onready var ai := $AI
onready var gun := $Gun

func _ready():
	anim_player.play("idle")
	ai.setup(self, anim_player, gun)
