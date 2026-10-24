extends CanvasLayer

signal dismissed # <--- Add this signal

@onready var banner_container: Control = $BannerContainer
@onready var label: Label = $BannerContainer/Panel/Label

func _ready() -> void:
	banner_container.hide()

func show_message(text: String) -> void:
	label.text = text
	banner_container.show()
	get_tree().paused = true

func _input(event: InputEvent) -> void:
	if banner_container.visible:
		var pressed_enter = Input.is_action_just_pressed("ui_accept")
		var clicked_left_mouse = event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT
		
		if pressed_enter or clicked_left_mouse:
			banner_container.hide()
			get_tree().paused = false
			get_viewport().set_input_as_handled()
			
			emit_signal("dismissed") # <--- Emit the signal when closed
