extends Control

@onready var play_button_timer: Timer = $Control/StartMenu/PlayButton/Timer
@onready var start_menu: VBoxContainer = $Control/StartMenu
@onready var difficulty_selector: VBoxContainer = $Control/DifficultySelector
@onready var game_mode_selector: VBoxContainer = $Control/GameModeSelector

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_play_button_pressed() -> void:
	print("test");


func _on_play_button_button_down() -> void:
	play_button_timer.start()


func _on_play_button_button_up() -> void:
	if play_button_timer.is_stopped():
		print("stuff")
	else:
		start_menu.hide()
		difficulty_selector.show()
	play_button_timer.stop()


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_easy_button_pressed() -> void:
	Global.difficulty = Global.Difficulty.EASY
	difficulty_selector.hide()
	game_mode_selector.show()


func _on_medium_button_pressed() -> void:
	Global.difficulty = Global.Difficulty.MEDIUM
	difficulty_selector.hide()
	game_mode_selector.show()


func _on_hard_button_pressed() -> void:
	Global.difficulty = Global.Difficulty.HARD
	difficulty_selector.hide()
	game_mode_selector.show()
	


func _on_story_mode_button_pressed() -> void:
	pass


func _on_endless_mode_button_pressed() -> void:
	get_tree().change_scene_to_packed(preload("uid://ceyglay5glk57"))


func _on_sandbox_mode_button_pressed() -> void:
	pass # Replace with function body.
