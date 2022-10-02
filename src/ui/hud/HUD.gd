class_name HUD
extends CanvasLayer

onready var countdown_bar := get_node("%CountdownBar") as CountdownBar

export var phase_name := "[PHASE]" setget set_phase_name
export var round_score := 0 setget set_round_score
export var total_score := 0 setget set_total_score

func _ready() -> void:
    self.round_score = 0
    self.total_score = 0

func set_phase_name(_value: String) -> void:
    phase_name = _value
    get_node("%PhaseLabel").text = "Phase: %s" % phase_name

func set_round_score(_value: int) -> void:
    round_score = _value
    get_node("%RoundScoreLabel").text = "Round score: %d" % round_score

func set_total_score(_value: int) -> void:
    total_score = _value
    get_node("%TotalScoreLabel").text = "Total score: %d" % total_score
