extends Node2D

func _ready() -> void:
    var score: int = HighScores.last_score
    var color := ""

    if score < 0:
        color = "#ff0000"
    elif score > 0:
        color = "#00ff00"
    else:
        color = "#aaaaaa"

    $ScoreLabel.bbcode_text = "[color=%s]%d[/color]" % [color, HighScores.last_score]

    if HighScores.last_score_is_new_high:
        $NewHighscoreLabel.show()
    else:
        $NewHighscoreLabel.hide()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_quit"):
        get_tree().quit()
    elif event.is_action_pressed("ui_accept"):
        SceneManager.switch_to_title_screen()
