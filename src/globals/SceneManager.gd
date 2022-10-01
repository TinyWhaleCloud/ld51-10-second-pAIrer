extends Node

# Phase 1: Pairing
const PairingScreen = preload("res://screens/game_phases/phase1/PairingScreen.tscn")
# Phase 2: Date planning
const PlanningScreen = preload("res://screens/game_phases/phase2/PlanningScreen.tscn")
# Phase 3: Date simulation and results
const DatingScreen = preload("res://screens/game_phases/phase3/DatingScreen.tscn")

# Start the game
func start_game() -> void:
    GameState.reset()
    switch_to_phase1()

# Switch to scenes
func switch_to_phase1() -> void:
    get_tree().change_scene_to(PairingScreen)

func switch_to_phase2() -> void:
    get_tree().change_scene_to(PlanningScreen)

func switch_to_phase3() -> void:
    get_tree().change_scene_to(DatingScreen)
