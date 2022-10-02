class_name CountdownBar
extends ProgressBar

signal timeout

onready var countdown_label := $CountdownLabel as Label
onready var timer := $Timer as Timer

func _ready() -> void:
    init_timer(10)

func _process(delta: float) -> void:
    if not timer.is_stopped():
        update_value(timer.time_left)

# Display progress
func update_value(new_value: float) -> void:
    self.value = new_value
    countdown_label.text = str(int(self.value))
    update_colors()

func update_colors() -> void:
    # Set progress bar color to a hue between red (hue=0) and green (hue=1/3)
    var color_hue = min(self.value, 10) / 10 / 3
    (get("custom_styles/fg") as StyleBoxFlat).bg_color = Color.from_hsv(color_hue, 1, 1)

    # Change color of text to black or white for good contrast
    countdown_label.set("custom_colors/font_color", Color.white if value < max_value / 2 else Color.black)

# Timer control
func init_timer(_start_time: float) -> void:
    self.max_value = _start_time
    update_value(self.max_value)

func start_timer() -> void:
    timer.start(self.max_value)

func stop_timer() -> void:
    timer.stop()

func get_seconds_left() -> int:
    return int(timer.time_left)

func _on_Timer_timeout() -> void:
    emit_signal("timeout")
