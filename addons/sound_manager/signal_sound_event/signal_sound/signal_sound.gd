@icon("res://addons/sound_manager/icon/SignalSound.png")
@tool
extends Node
class_name SignalSound
## A utility node that plays a specified [param sound_effect] when its parent
## node emits the signal defined in [param signal_name].

## The name of the signal on the parent node that will trigger the sound effect.
@export var signal_name : String
## The AudioStream resource to be played when the signal is emitted.
@export var sound_effect : AudioStream
## The name of the audio bus to override and play the sound effect on.
## [br]Defaults to "Master".
@export var override_bus : String = "Master"

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	var parent : Node = get_parent()

	# 1. Check if a parent node exists
	if not parent:
		warnings.append("This node requires a parent to function.")
		# If there's no parent, we can't perform the other checks.
		return warnings

	# 2. Check if the signal_name is set and exists on the parent
	if signal_name.is_empty():
		warnings.append("'Signal Name' property cannot be empty.")
	elif not parent.has_signal(signal_name):
		var warning_string = "Parent node '%s' does not have the specified signal '%s'."
		warnings.append(warning_string % [parent.name, signal_name])

	# 3. Check if a sound_effect has been assigned
	if not sound_effect:
		warnings.append("'Sound Effect' property must be assigned an AudioStream resource.")

	# 4. Check if the specified override_bus is a valid audio bus
	if AudioServer.get_bus_index(override_bus) == -1:
		var warning_string = "Audio bus '%s' does not exist in the current project."
		warnings.append(warning_string % override_bus)
		
	return warnings

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	var parent : Node = get_parent()
	if not parent:
		return
	
	# Wait for the parent to be ready before connecting
	parent.ready.connect(_on_parent_ready.bind(parent))

func _on_parent_ready(parent: Node) -> void:
	# Check if the signal exists before connecting to avoid runtime errors
	if parent.has_signal(signal_name):
		parent.connect(signal_name, _on_event_happened)
	else:
		push_warning("Attempted to connect to a non-existent signal '%s' on parent '%s'." % [signal_name, parent.name])

## Callback function that plays the sound effect when the signal is emitted.
## [param ...args]: Captures any arguments passed by the emitted signal.
func _on_event_happened(...args) -> void:
	SoundManager.play_sound(sound_effect, override_bus)
