extends Node

# Packed scenes
const MainGameScene = preload("res://screens/main_game/MainGame.tscn")
const TitleScreenScene = preload("res://screens/title_screen/TitleScreen.tscn")
const GameOverScene = preload("res://screens/game_over/GameOverScreen.tscn")

# Start the game
func start_game() -> void:
    get_tree().change_scene_to(MainGameScene)

# Switch back to the title screen (discarding the game state!)
func switch_to_title_screen() -> void:
    get_tree().change_scene_to(TitleScreenScene)

# Switch to game over screen
func switch_to_game_over_screen() -> void:
    get_tree().change_scene_to(GameOverScene)
