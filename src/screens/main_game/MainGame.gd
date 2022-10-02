class_name MainGame
extends Node2D

# Packed scenes (screens)
const PairingScreen := preload("res://screens/main_game/phase1/PairingScreen.tscn")
const PlanningScreen := preload("res://screens/main_game/phase2/PlanningScreen.tscn")
const DatingScreen := preload("res://screens/main_game/phase3/DatingScreen.tscn")

# Packed scenes (objects)
const PlayerScene := preload("res://actors/player/Player.tscn")

# Node references
onready var hud := $HUD as HUD
onready var countdown_bar := hud.countdown_bar as CountdownBar

# Current phase
var current_phase := 0
var current_phase_scene: BaseGamePhase = null

# Game state
var player: Player = null
var round_score := 0
var total_score := 0
var time_left_from_phase1 := 0.0

# Profile cards selected by the player in phase 1
var pairing_profile_card1: ProfileCard = null
var pairing_profile_card2: ProfileCard = null

func _ready() -> void:
    # Create player instance
    player = PlayerScene.instance() as Player

    # Connect events
    countdown_bar.connect("timeout", self, "_on_CountdownBar_timeout")

    # Start first round
    start_new_round()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()
    elif event.is_action_pressed("debug_next_phase"):
        finish_current_phase()

func _on_CountdownBar_timeout() -> void:
    print_debug("Countdown timeout!")
    finish_current_phase()

# Scene management
func start_new_round() -> void:
    # Reset round state
    cleanup_phase()
    pairing_profile_card1 = null
    pairing_profile_card2 = null
    time_left_from_phase1 = 0.0
    round_score = 0

    # Start first phase
    start_phase1()

func finish_round() -> void:
    # TODO: Add scores and stuff
    total_score += round_score
    hud.total_score = total_score

    # Start next round
    start_new_round()

func cleanup_phase() -> void:
    # Clean up previous phase
    if player.get_parent():
        player.get_parent().remove_child(player)
    if current_phase_scene:
        current_phase_scene.queue_free()

    current_phase = 0
    current_phase_scene = null

func switch_to_phase(phase_number: int, phase_scene: BaseGamePhase) -> void:
    # Clean up previous phase
    cleanup_phase()

    # Create and set current phase
    current_phase = phase_number
    current_phase_scene = phase_scene
    add_child(current_phase_scene)

func finish_current_phase() -> void:
    print_debug("Finishing current phase...")
    if current_phase == 1:
        finish_phase1()
    elif current_phase == 2:
        finish_phase2()
    elif current_phase == 3:
        finish_phase3()
    else:
        print_debug("Cannot finish current phase (%d)" % current_phase)

# Phase 1: Pairing
func start_phase1() -> void:
    print_debug("Starting phase 1...")
    assert(current_phase == 0)

    # Instance scene and add it to the tree
    var pairing_screen := PairingScreen.instance() as PairingScreen
    switch_to_phase(1, pairing_screen)
    hud.phase_name = "Pairing"
    pairing_screen.connect("pair_cards_selected", self, "finish_phase1")
    pairing_screen.set_player(player)

    # Start countdown
    countdown_bar.init_timer(10)
    countdown_bar.start_timer()

func finish_phase1() -> void:
    print_debug("Finishing phase 1...")
    assert(current_phase == 1)

    # Stop countdown
    time_left_from_phase1 = max(0.0, countdown_bar.get_time_left())
    countdown_bar.stop_timer()

    # Check if cards were chosen
    var pairing_screen := current_phase_scene as PairingScreen
    if not pairing_screen.all_card_slots_filled():
        print_debug("Player hasn't finished! :(")
        # TODO: remove one life and restart phase
        # TODO: disable movement while paused
        yield(get_tree().create_timer(1), "timeout")
        finish_round()
        return

    # Get chosen profiles
    pairing_profile_card1 = pairing_screen.get_pairing_profile_card1()
    pairing_profile_card2 = pairing_screen.get_pairing_profile_card2()

    # Remove card nodes from the pairing scene
    pairing_profile_card1.remove_from_parent()
    pairing_profile_card2.remove_from_parent()

    # Start next phase
    start_phase2()

# Phase 2: Date planning
func start_phase2() -> void:
    print_debug("Starting phase 2...")
    assert(current_phase == 1)

    # Instance scene and add it to the tree
    var planning_screen := PlanningScreen.instance() as PlanningScreen
    switch_to_phase(2, planning_screen)
    hud.phase_name = "Date planning"
    planning_screen.connect("planning_cards_selected", self, "finish_phase2")

    # Add player and chosen profile cards
    planning_screen.set_player(player)
    planning_screen.set_profile_cards(pairing_profile_card1, pairing_profile_card2)

    # Start countdown (after a second delay)
    # TODO: don't allow interactions in this delay
    yield(get_tree().create_timer(1), "timeout")

    # Start countdown (add remaining time from phase 1)
    countdown_bar.init_timer(10 + time_left_from_phase1)
    countdown_bar.start_timer()

func finish_phase2() -> void:
    print_debug("Finishing phase 2...")
    assert(current_phase == 2)

    # Stop countdown
    countdown_bar.stop_timer()

    # TODO ...
    var planning_screen := current_phase_scene as PlanningScreen
    round_score = planning_screen.dating_score
    hud.round_score = round_score

    # Start next phase
    start_phase3()

# Phase 3: Date simulation & results
func start_phase3() -> void:
    print_debug("Starting phase 3...")
    assert(current_phase == 2)

    # Instance scene and add it to the tree
    var dating_screen := DatingScreen.instance() as DatingScreen
    switch_to_phase(3, dating_screen)
    hud.phase_name = "Date simulation"
    # dating_screen.connect("simulation_finished", self, "finish_phase3")

    # TODO (implement date simulation)

func finish_phase3() -> void:
    print_debug("Finishing phase 3...")
    assert(current_phase == 3)

    finish_round()
