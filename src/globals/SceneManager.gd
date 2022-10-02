extends Node

# Packed scenes
const MainGameScene = preload("res://screens/main_game/MainGame.tscn")

# Start the game
func start_game() -> void:
    get_tree().change_scene_to(MainGameScene)
