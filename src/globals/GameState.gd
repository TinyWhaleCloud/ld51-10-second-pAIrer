extends Node

const PlayerScene := preload("res://actors/player/Player.tscn")

# Player score
var round_score := 0
var total_score := 0

# Player node
var player: Player = null

# Profile cards selected by the player in phase 1
var pairing_profile_card1: ProfileCard = null
var pairing_profile_card2: ProfileCard = null

func _ready() -> void:
    reset()

# Resets the game state to start a new game
func reset() -> void:
    print_debug("Resetting game state.")

    init_player()
    round_score = 0
    total_score = 0

func init_player() -> void:
    # Remove old player if set
    if player:
        player.queue_free()

    # Create player instance and set start position
    player = PlayerScene.instance() as Player

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

func save_pairing_profiles(card1: ProfileCard, card2: ProfileCard) -> void:
    # Save to state
    pairing_profile_card1 = card1
    pairing_profile_card2 = card2
