class_name IngameScene
extends Node2D

var cubeViewport : CubeViewport
var cubeViewport2 : CubeViewport
var cubeViewport3 : CubeViewport

@onready var CUBE_VIEWPORT = preload("uid://bsiceli07tg2x")

@onready var texture_rect_2: TextureRect = $UI/Counters/TextureRect2
@onready var texture_rect_3: TextureRect = $UI/Counters/TextureRect3
@onready var texture_rect: TextureRect = $UI/Counters/TextureRect

@onready var fade_overlay = %FadeOverlay
@onready var pause_overlay = %PauseOverlay

@onready var score_label: Label = $UI/Score
@onready var decimal_score: Label = $UI/DecimalScore

var score : int = 0

func _ready() -> void:
	cubeViewport = CUBE_VIEWPORT.instantiate()
	add_child(cubeViewport)
	texture_rect.texture = cubeViewport.get_texture()
	
	cubeViewport2 = CUBE_VIEWPORT.instantiate()
	add_child(cubeViewport2)
	texture_rect_2.texture = cubeViewport2.get_texture()
	
	cubeViewport3 = CUBE_VIEWPORT.instantiate()
	add_child(cubeViewport3)
	texture_rect_3.texture = cubeViewport3.get_texture()
	
	fade_overlay.visible = true
	
	if SaveGame.has_save():
		SaveGame.load_game(get_tree())
	
	pause_overlay.game_exited.connect(_save_game)
	cubeViewport.cube_roll_finished.connect(_on_cube_roll_finished)
	cubeViewport2.cube_roll_finished.connect(_on_cube_roll_finished2)
	cubeViewport3.cube_roll_finished.connect(_on_cube_roll_finished3)

func _input(event) -> void:
	if event.is_action_pressed("pause") and not pause_overlay.visible:
		get_viewport().set_input_as_handled()
		get_tree().paused = true
		pause_overlay.grab_button_focus()
		pause_overlay.visible = true

func _process(delta):
	if Input.is_action_just_released("Shift"):
		if is_instance_of(cubeViewport, CubeViewport):
			cubeViewport.rollCube()
		
func _save_game() -> void:
	SaveGame.save_game(get_tree())

func _increase_score() -> void:
	score += 1
	score_label.text = String.num_int64(score, 2)
	decimal_score.text = String.num_int64(score)

func _on_cube_roll_finished(shouldFlowOver: bool) -> void:
	_increase_score()
	if shouldFlowOver:
		cubeViewport2.rollCube()

func _on_cube_roll_finished2(shouldFlowOver: bool) -> void:
	if shouldFlowOver:
		cubeViewport3.rollCube()
	
func _on_cube_roll_finished3(shouldFlowOver: bool) -> void:
	pass
