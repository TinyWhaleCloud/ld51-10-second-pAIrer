extends Node

var total_score := 0

func _ready() -> void:
    reset()

# Resets the game state to start a new game
func reset() -> void:
    total_score = 0

func add_score(points: int) -> void:
    total_score += points
    print_debug("Added %d points to total score. New total score: %d" % [points, total_score])
