class_name HUD
extends CanvasLayer

onready var countdown_bar := get_node("%CountdownBar") as CountdownBar
onready var phase_label := get_node("%PhaseLabel") as Label
onready var total_score_label := get_node("%TotalScoreLabel") as Label

export(String) var phase_title := "[PHASE TITLE]" setget set_phase_title
export(int) var total_score := 0 setget set_total_score

func set_phase_title(_value: String) -> void:
    phase_title = _value
    phase_label.text = phase_title

func set_total_score(_value: int) -> void:
    total_score = _value
    total_score_label.text = "Score: %d" % total_score
