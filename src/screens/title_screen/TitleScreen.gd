extends Node2D

func _input(event: InputEvent) -> void:
    if event.is_action("ui_accept"):
        get_tree().change_scene("res://screens/main_game/MainGame.tscn")
    elif event.is_action("ui_cancel"):
        get_tree().quit()
