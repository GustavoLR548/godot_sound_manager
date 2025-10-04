# SignalSound

The `SignalSound` node plays a single sound effect when its parent node emits a specific signal.

## How to Use

1.  **Add the Node:** In the Godot editor, add a new node and attach the `SignalSound.gd` script to it. Make this node a child of the node that will be emitting the signal (e.g., a `Button`, an `Area2D`, or a custom node).
2.  **Configure in Inspector:** Select the `SignalSound` node. In the Inspector panel, set the following properties:
    * **Signal Name:** Type the exact name of the signal from the parent node you want to listen to (e.g., `pressed` for a Button, `body_entered` for an `Area2D`).
    * **Sound Effect:** Drag and drop an `AudioStream` resource (like a `.wav` or `.ogg` file) into this slot.
    * **Override Bus (Optional):** If you want the sound to play on a specific audio bus, change this from its default "Master" value.

### Properties

| Property       | Type          | Description                                                          |
| :------------- | :------------ | :------------------------------------------------------------------- |
| `signal_name`  | `String`      | The name of the signal on the parent node that will trigger the sound. |
| `sound_effect` | `AudioStream` | The sound resource to be played when the signal is emitted.          |
| `override_bus` | `String`      | The audio bus to play the sound on. Defaults to "Master".            |

---

# MultiSignalSound

The `MultiSignalSound` is an enhanced version that plays a single sound effect in response to any one of several signals from its parent.

## How to Use

1.  **Add the Node:** Attach the `MultiSignalSound.gd` script to a new node and place it as a child of the signal-emitting node.
2.  **Configure in Inspector:**
    * **Signal Names:** This is an array. Set its size and then type the exact name of each signal you want to connect. For example, you could connect to a character's `jumped`, `landed`, and `dashed` signals to play the same "whoosh" sound for all of them.
    * **Sound Effect:** Assign an `AudioStream` resource.
    * **Override Bus (Optional):** Change the audio bus if needed.

### Properties

| Property       | Type            | Description                                                                    |
| :------------- | :-------------- | :----------------------------------------------------------------------------- |
| `signal_names` | `Array[String]` | A list of signal names on the parent. Emitting any of them triggers the sound. |
| `sound_effect` | `AudioStream`   | The sound resource to be played.                                               |
| `override_bus` | `String`        | The audio bus to play the sound on. Defaults to "Master".                      |

---

# Editor Warnings

Because these are `@tool` scripts, they will show a yellow warning icon in the Scene dock if they are not configured correctly. This helps you catch errors before you even run the game.

A warning will appear if:

* The node does not have a parent.
* A specified signal name is empty.
* A specified signal name does not exist on the parent node.
* The `Sound Effect` property is not assigned.
* The `Override Bus` name is invalid and doesn't exist in your project's audio bus layout.

**Note:** If you make a change to the parent node's signals, you may need to reload the scene for the warning to update.

---

# Test Scene

To see a practical example, open `signal_sound_example.tscn`. This scene contains a `Button` node with a `SignalSound` and a `OptionButton` with a `MultiSignalSound`.  This provides a clear example of how to structure your scenes and configure the nodes.
