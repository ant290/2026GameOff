class_name IngameScene
extends Node2D

@onready var CUBE_VIEWPORT = preload("res://scenes/cube_viewport.tscn")
@onready var counters: HBoxContainer = $UI/Counters

var cube_viewports: Dictionary[int, CubeViewport] = {}

@onready var fade_overlay = %FadeOverlay
@onready var pause_overlay = %PauseOverlay

@onready var score_label: Label = $UI/Score
@onready var decimal_score: Label = $UI/DecimalScore

func _ready() -> void:
	fade_overlay.visible = true
	
	if SaveGame.has_save():
		SaveGame.load_game()
	
	pause_overlay.game_exited.connect(_save_game)

	for index in range(3):
		add_cube_view(index, false)	
	
	_update_score_display()

func add_cube_view(index: int, isTrue: bool) -> void:
	var viewPort := CUBE_VIEWPORT.instantiate()
	viewPort.cube_id = index
	viewPort.add_to_group(SaveGame.SAVE_GROUP_NAME)
	cube_viewports[index] = viewPort
	add_child(viewPort)

	var textureRect := TextureRect.new()
	textureRect.texture = viewPort.get_texture()
	textureRect.custom_maximum_size = Vector2(50,50)
	counters.add_child(textureRect)
	
	if isTrue:
		viewPort.rollCube()
	viewPort.cube_roll_finished.connect(_on_cube_roll_finished)

func _input(event) -> void:
	if event.is_action_pressed("pause") and not pause_overlay.visible:
		get_viewport().set_input_as_handled()
		get_tree().paused = true
		pause_overlay.grab_button_focus()
		pause_overlay.visible = true

func _process(delta):
	if Input.is_action_just_released("Shift"):
		if is_instance_of(cube_viewports[0], CubeViewport):
			cube_viewports[0].rollCube()
		
func _save_game() -> void:
	SaveGame.save_game()

func _increase_score() -> void:
	GameState.score += 1
	_update_score_display()

func _update_score_display() -> void:
	score_label.text = String.num_int64(GameState.score, 2)
	decimal_score.text = String.num_int64(GameState.score)

func _on_cube_roll_finished(shouldFlowOver: bool, cube_id: int) -> void:
	if cube_id == 0:
		_increase_score()
	if shouldFlowOver:
		if cube_viewports.has(cube_id + 1):
			cube_viewports[cube_id + 1].rollCube()
		else:
			add_cube_view(cube_viewports.size(), true)
