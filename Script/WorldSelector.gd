extends VBoxContainer

const WORLDS_DIR := "res://Worlds/"

var _game := preload("res://Scene/Game.tscn") as PackedScene

@onready var CandyWrapperButton: Button = %CandyWrapperButton
@onready var ExtraWorldsButton: Button = %ExtraWorldsButton
@onready var ExtraWorldsBox: VBoxContainer = %ExtraWorldsBox
@onready var BackButton: Button = %BackButton


func _find_worlds(path) -> Array[String]:
	var worlds_dir = DirAccess.open(path)
	var worlds: Array[String]
	if worlds_dir:
		worlds_dir.list_dir_begin()
		var child := worlds_dir.get_next()
		while child:
			if worlds_dir.current_is_dir():
				worlds.append(child)
			child = worlds_dir.get_next()
	return worlds


func _ready() -> void:
	var worlds := _find_worlds(WORLDS_DIR)

	for world in worlds:
		var button = Button.new()
		button.text = world
		button.pressed.connect(_on_world_button_pressed.bind(WORLDS_DIR.path_join(world)))
		ExtraWorldsBox.add_child(button)

	CandyWrapperButton.pressed.connect(_on_world_button_pressed.bind(global.DEFAULT_WORLD))
	CandyWrapperButton.grab_focus()


func _on_world_button_pressed(world: String) -> void:
	global.load_levels(world)
	global.level = global.firstLevel
	get_tree().change_scene_to_packed(_game)
	global.start_music()


func _on_extra_worlds_button_pressed() -> void:
	ExtraWorldsBox.show()
	BackButton.grab_focus()


func _on_back_button_pressed() -> void:
	ExtraWorldsBox.hide()
	CandyWrapperButton.grab_focus.call_deferred()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if ExtraWorldsBox.visible:
			_on_back_button_pressed()