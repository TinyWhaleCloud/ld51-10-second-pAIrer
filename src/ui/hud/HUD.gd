extends CanvasLayer

export var phase_name := "[PHASE]"

func _ready() -> void:
    update_labels()

func update_labels() -> void:
    $VBox/TextContainer/PhaseLabel.text = "Phase: %s" % phase_name
    $VBox/TextContainer/RoundScoreLabel.text = "Round score: %d" % GameState.round_score
    $VBox/TextContainer/TotalScoreLabel.text = "Total score: %d" % GameState.total_score
