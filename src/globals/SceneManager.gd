extends Node

# Phase 1
const MatchingScreen = preload("res://screens/phase1/MatchingScreen.tscn")
# Phase 2
const PlanningScreen = preload("res://screens/phase2/PlanningScreen.tscn")
# Phase 3
const DatingScreen = preload("res://screens/phase3/DatingScreen.tscn")

# Switch to scenes
func switch_to_phase1() -> void:
    get_tree().change_scene_to(MatchingScreen)

func switch_to_phase2() -> void:
    get_tree().change_scene_to(PlanningScreen)

func switch_to_phase3() -> void:
    get_tree().change_scene_to(DatingScreen)
