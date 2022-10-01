extends Node2D

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()
    elif event.is_action_pressed("ui_accept"):
        SceneManager.start_game()
