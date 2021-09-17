extends Node2D


signal state_changed(new_state)


enum State {
	IDLE,
	MOVE,
	SHOOT
}


var current_state: int = State.IDLE setget set_state
var target: Node2D
var actor: KinematicBody2D
var anim_player: AnimationPlayer
var gun: Gun

onready var move_timer := $MoveTimer

onready var detection_area := $DetectionArea


func setup(actor: KinematicBody2D, anim_player: AnimationPlayer, gun: Gun) -> void:
	self.actor = actor
	self.anim_player = anim_player
	self.gun = gun

func _process(delta):
	match current_state:
		State.IDLE:
			pass
		State.MOVE:
			if not target:
				set_state(State.IDLE)
		State.SHOOT:
			if target:
				gun.look_at(target.global_position)
			else:
				set_state(State.IDLE)

func set_state(new_state: int) -> void:
	if current_state == new_state:
		return
	
	if current_state:
		exit_state(current_state)
	
	current_state = new_state
	enter_state(current_state)
	emit_signal("state_changed", current_state)

func enter_state(state: int) -> void:
	match state:
		State.IDLE:
			anim_player.play("idle")
		State.MOVE:
			anim_player.play("walk")
			move_timer.start(randi()%3)
		State.SHOOT:
			anim_player.play("shoot")
	
func exit_state(state: int) -> void:
	pass

func _on_DetectionArea_body_entered(body: PhysicsBody2D) -> void:
	if current_state == State.IDLE and body.is_in_group("target"):
		target = body
		set_state(State.MOVE)


func _on_DetectionArea_body_exited(body):
	if current_state in [State.MOVE, State.SHOOT] and body.is_in_group("target"):
		target = null
		set_state(State.IDLE)


func _on_MoveTimer_timeout():
	if current_state == State.MOVE:
		set_state(State.SHOOT)
