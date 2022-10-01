extends CanvasLayer

export var phase_name := "[PHASE]"

func _ready() -> void:
    update_labels()

func update_labels() -> void:
    $TextContainer/PhaseLabel.text = "Phase: %s" % phase_name
    $TextContainer/RoundScoreLabel.text = "Round score: %d" % GameState.round_score
    $TextContainer/TotalScoreLabel.text = "Total score: %d" % GameState.total_score
