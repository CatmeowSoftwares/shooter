extends Node
signal difficulty_changed
enum Difficulty {
	EASY,
	MEDIUM,
	HARD
}
var difficulty: Difficulty:
	set(value):
		difficulty = value
		difficulty_changed.emit(value)
