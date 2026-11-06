extends Node2D

@export var cube : RotatorCube

@onready var fade_overlay = %FadeOverlay
@onready var pause_overlay = %PauseOverlay

@onready var score_label: Label = $UI/Score
@onready var decimal_score: Label = $UI/DecimalScore

var score : int = 0

func _ready() -> void:
	fade_overlay.visible = true
	
	if SaveGame.has_save():
		SaveGame.load_game(get_tree())
	
	pause_overlay.game_exited.connect(_save_game)

func _input(event) -> void:
	if event.is_action_pressed("pause") and not pause_overlay.visible:
		get_viewport().set_input_as_handled()
		get_tree().paused = true
		pause_overlay.grab_button_focus()
		pause_overlay.visible = true

func _process(delta):
	if Input.is_action_just_released("Shift"):
		score += 1
		score_label.text = String.num_int64(score, 2)
		decimal_score.text = String.num_int64(score)
		if is_instance_of(cube, RotatorCube):
			cube.rollCube()
		
func _save_game() -> void:
	SaveGame.save_game(get_tree())
