@icon("res://addons/sound_manager/icon/SignalSound.png")
@tool
extends Node
class_name MultiSignalSound
## A utility node that plays a specified [param sound_effect] when its parent
## node emits one of the signals listed in [param signal_names].

## The list of signal names on the parent node that, when emitted,
## will trigger the sound effect.
@export var signal_names : Array[String]
## The AudioStream resource to be played when a connected signal is emitted.
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
		return warnings

	# 2. Check the signal_names array and validate each signal
	if signal_names.is_empty():
		warnings.append("'Signal Names' array cannot be empty.")
	else:
		for s_name in signal_names:
			if s_name.is_empty():
				warnings.append("An entry in 'Signal Names' is empty and invalid.")
			elif not parent.has_signal(s_name):
				var warning_string = "Parent node '%s' does not have the signal '%s'."
				warnings.append(warning_string % [parent.name, s_name])

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
	
	parent.ready.connect(_on_parent_ready.bind(parent))

func _on_parent_ready(parent: Node) -> void:
	# Loop through all signal names and connect them
	for s_name in signal_names:
		if parent.has_signal(s_name):
			parent.connect(s_name, _on_event_happened)
		else:
			push_warning("Attempted to connect to a non-existent signal '%s' on parent '%s'." % [s_name, parent.name])

func _on_event_happened(...args) -> void:
	SoundManager.play_sound(sound_effect, override_bus)
