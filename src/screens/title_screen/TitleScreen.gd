extends Node2D

func _ready() -> void:
    $PreviousHighScoreLabel.bbcode_text = "Previous high score: [u]%d[/u]" % HighScores.highscore

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_quit"):
        get_tree().quit()
    elif event.is_action_pressed("ui_accept"):
        SceneManager.start_game()
