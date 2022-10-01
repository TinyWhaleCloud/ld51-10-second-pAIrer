extends Node

var round_score := 0
var total_score := 0

func _ready() -> void:
    reset()

# Resets the game state to start a new game
func reset() -> void:
    print_debug("Resetting game state.")
    round_score = 0
    total_score = 0

# Ends the round, adding the round score to the total score
func finish_round() -> void:
    print_debug("Finishing round.")
    add_total_score(round_score)
    round_score = 0

func add_round_score(points: int) -> void:
    round_score += points
    print_debug("Added %d points to ROUND score. New round score: %d" % [points, round_score])

func add_total_score(points: int) -> void:
    total_score += points
    print_debug("Added %d points to TOTAL score. New total score: %d" % [points, total_score])
