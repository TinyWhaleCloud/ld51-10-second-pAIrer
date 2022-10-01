extends Node

# Phase 1: Pairing
const PairingScreen := preload("res://screens/game_phases/phase1/PairingScreen.tscn")
# Phase 2: Date planning
const PlanningScreen := preload("res://screens/game_phases/phase2/PlanningScreen.tscn")
# Phase 3: Date simulation and results
const DatingScreen := preload("res://screens/game_phases/phase3/DatingScreen.tscn")

# Start the game
func start_game() -> void:
    GameState.reset()
    switch_to_phase1()

# Switch to scenes
func switch_to_scene(scene: Resource) -> void:
    # Remove player from scene tree before switching scenes
    var player: Player = GameState.player
    if player and player.get_parent():
        player.get_parent().remove_child(player)

    get_tree().change_scene_to(scene)

func switch_to_phase1() -> void:
    switch_to_scene(PairingScreen)

func switch_to_phase2() -> void:
    switch_to_scene(PlanningScreen)

func switch_to_phase3() -> void:
    switch_to_scene(DatingScreen)
