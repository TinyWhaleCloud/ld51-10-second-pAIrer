extends Node

# Packed scenes
const MainGameScene = preload("res://screens/main_game/MainGame.tscn")
const TitleScreenScene = preload("res://screens/title_screen/TitleScreen.tscn")

# Start the game
func start_game() -> void:
    get_tree().change_scene_to(MainGameScene)

# Switch back to the title screen (discarding the game state!)
func switch_to_title_screen() -> void:
    get_tree().change_scene_to(TitleScreenScene)
