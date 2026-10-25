extends CanvasLayer

signal dismissed

@export var message_id: String = "" # Type a unique ID here in the Inspector for each banner!

@onready var banner_container: Control = $BannerContainer
@onready var label: Label = $BannerContainer/Panel/Label
@onready var pop_audio: AudioStreamPlayer2D = $pop

func _ready() -> void:
	banner_container.hide()

func show_message(text: String) -> void:
	# If this message ID was already shown anywhere in the game (even after scene reloads), skip it!
	if message_id != "" and Global.is_message_shown(message_id):
		return

	# Mark it as shown globally so it never triggers again during this playthrough
	if message_id != "":
		Global.mark_message_shown(message_id)

	label.text = text
	banner_container.show()
	get_tree().paused = true
	
	# Play your pop sound effect
	if pop_audio and pop_audio.stream:
		pop_audio.play()

func _input(event: InputEvent) -> void:
	if banner_container.visible:
		var pressed_enter = Input.is_action_just_pressed("ui_accept")
		var clicked_left_mouse = event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT
		
		if pressed_enter or clicked_left_mouse:
			banner_container.hide()
			get_tree().paused = false
			get_viewport().set_input_as_handled()
			
			emit_signal("dismissed")
