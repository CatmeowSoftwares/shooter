extends Control

const KONAMI_CODE = [
	KEY_UP,
	KEY_UP,
	KEY_DOWN,
	KEY_DOWN,
	KEY_LEFT,
	KEY_RIGHT,
	KEY_LEFT,
	KEY_RIGHT,
	KEY_B,
	KEY_A,
]
var index = 0
var is_cheating = false
func _ready() -> void:
	hide()
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if not event.echo and event.pressed:
			if event.keycode == KONAMI_CODE[index]:
				index += 1
				if index >= KONAMI_CODE.size():
					open_cheat_sheet()
					index = 0
			else:
				index = 0
func open_cheat_sheet():
	show()
	is_cheating = true
