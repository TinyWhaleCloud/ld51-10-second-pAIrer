class_name MainGame
extends Node2D

# Packed scenes (screens)
const PairingScreen := preload("res://screens/main_game/phase1/PairingScreen.tscn")
const PlanningScreen := preload("res://screens/main_game/phase2/PlanningScreen.tscn")
const DatingScreen := preload("res://screens/main_game/phase3/DatingScreen.tscn")

# Packed scenes (objects)
const ProfileCardPoolScene := preload("res://objects/cards/profile_cards/ProfileCardPool.tscn")
const LocationCardPoolScene := preload("res://objects/cards/date_cards/location_cards/LocationCardPool.tscn")
const ActivityCardPoolScene := preload("res://objects/cards/date_cards/activity_cards/ActivityCardPool.tscn")
const PlayerScene := preload("res://actors/player/Player.tscn")

# Remove profiles from the pool if the date score is above this value or below the negative value
const PROFILE_REMOVAL_THRESHOLD := 60

# Node references
onready var hud := $HUD as HUD
onready var countdown_bar := hud.countdown_bar as CountdownBar
onready var fail_text_label := $HUD/FailTextLabel as RichTextLabel

# Current phase
var current_phase := 0
var current_phase_scene: BaseGamePhase = null

# Game state
var player: Player = null
var total_score := 0
var round_score := 0
var time_left_from_phase1 := 0.0

# Card pools
var profile_card_pool: ProfileCardPool = null
var location_card_pool: LocationCardPool = null
var activity_card_pool: ActivityCardPool = null

# Profile cards selected by the player in phase 1
var pairing_profile_card1: ProfileCard = null
var pairing_profile_card2: ProfileCard = null

# Date plan cards selected by the player in phase 2
var date_location_card: LocationCard = null
var date_activity_card: ActivityCard = null

func _ready() -> void:
    # Create player instance
    player = PlayerScene.instance() as Player

    # Create card pools
    profile_card_pool = ProfileCardPoolScene.instance() as ProfileCardPool
    location_card_pool = LocationCardPoolScene.instance() as LocationCardPool
    activity_card_pool = ActivityCardPoolScene.instance() as ActivityCardPool

    # Connect events
    countdown_bar.connect("timeout", self, "_on_CountdownBar_timeout")

    # Start first round
    start_new_round()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()

func _on_CountdownBar_timeout() -> void:
    print_debug("Countdown timeout!")
    finish_current_phase()

# Scene management
func start_new_round() -> void:
    # Update score
    hud.total_score = total_score

    # Reset phase instances
    cleanup_phase()

    # Reset round state variables
    pairing_profile_card1 = null
    pairing_profile_card2 = null
    date_location_card = null
    date_activity_card = null
    time_left_from_phase1 = 0.0

    # Start first phase
    start_phase1()

func finish_round() -> void:
    # Check if there are enough profile cards left for another round
    if profile_card_pool.current_pool_size() < 2:
        print_debug("No (or only one) profile card left in the deck! -> Game over!")
        game_over()
        return

    # Start next round
    start_new_round()

func game_over() -> void:
    # Temporarily save total score in HighScores global to display on game over screen
    HighScores.last_score = total_score

    # Save highscore (if higher)
    var new_highscore: int = HighScores.set_score_if_higher(total_score)
    HighScores.last_score_is_new_high = new_highscore

    # Show game over screen
    SceneManager.switch_to_game_over_screen()

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
    hud.phase_title = "Find the best pairing!"
    pairing_screen.connect("pair_cards_selected", self, "finish_phase1")
    pairing_screen.set_player(player)

    # Shuffle cards and put up to 4 cards on the table
    profile_card_pool.shuffle()
    for _i in range(4):
        if profile_card_pool.shuffled_stack_size() > 0:
            pairing_screen.add_card(profile_card_pool.draw_card() as ProfileCard)

    # Start countdown
    countdown_bar.show()
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
        print_debug("Player hasn't selected two profiles! :(")

        # Remove 100 points and show failure text, then restart round
        total_score -= 100
        display_fail_text("Too slow!\n[color=#ff0000]-100 points[/color]\n(Please select two profile cards.)")

        # Dramatic pause!
        yield(get_tree().create_timer(1), "timeout")
        finish_round()
        return

    # Get chosen profiles
    pairing_profile_card1 = pairing_screen.get_pairing_profile_card1()
    pairing_profile_card2 = pairing_screen.get_pairing_profile_card2()

    # Remove card nodes from the scene
    pairing_profile_card1.remove_from_parent()
    pairing_profile_card2.remove_from_parent()

    # Start next phase
    start_phase2()

func display_fail_text(_text: String) -> void:
    fail_text_label.bbcode_text = "[center]%s[/center]" % _text

    # Remove text after 3 seconds
    yield(get_tree().create_timer(3), "timeout")
    fail_text_label.bbcode_text = ""

# Phase 2: Date planning
func start_phase2() -> void:
    print_debug("Starting phase 2...")
    assert(current_phase == 1)

    # Instance scene and add it to the tree
    var planning_screen := PlanningScreen.instance() as PlanningScreen
    switch_to_phase(2, planning_screen)
    hud.phase_title = "Plan the perfect date!"
    planning_screen.connect("planning_cards_selected", self, "finish_phase2")

    # Add player and chosen profile cards
    planning_screen.set_player(player)
    planning_screen.set_profile_cards(pairing_profile_card1, pairing_profile_card2)

    # Shuffle cards and put up to 3 cards per type on the table
    location_card_pool.shuffle()
    activity_card_pool.shuffle()
    for _i in range(3):
        planning_screen.add_location_card(location_card_pool.draw_card() as LocationCard)
        planning_screen.add_activity_card(activity_card_pool.draw_card() as ActivityCard)

    # Set countdown
    countdown_bar.init_timer(10)

    # Start countdown (after a second delay)
    yield(get_tree().create_timer(0.5), "timeout")
    countdown_bar.start_timer()

func finish_phase2() -> void:
    print_debug("Finishing phase 2...")
    assert(current_phase == 2)

    # Stop countdown
    countdown_bar.stop_timer()

    # Get chosen cards (slots can be empty, too)
    var planning_screen := current_phase_scene as PlanningScreen
    date_location_card = planning_screen.get_date_location_card()
    date_activity_card = planning_screen.get_date_activity_card()

    # Remove card nodes from the scene
    pairing_profile_card1.remove_from_parent()
    pairing_profile_card2.remove_from_parent()
    if date_location_card:
        date_location_card.remove_from_parent()
    if date_activity_card:
        date_activity_card.remove_from_parent()

    # Start next phase
    start_phase3()

# Phase 3: Date simulation & results
func start_phase3() -> void:
    print_debug("Starting phase 3...")
    assert(current_phase == 2)

    # Instance scene and add it to the tree
    var dating_screen := DatingScreen.instance() as DatingScreen
    switch_to_phase(3, dating_screen)
    hud.phase_title = "Will they or won't they?"
    dating_screen.connect("finish_round", self, "finish_phase3")

    # Add player and chosen profile cards
    dating_screen.set_profile_cards(pairing_profile_card1, pairing_profile_card2)
    dating_screen.set_date_cards(date_location_card, date_activity_card)

    # Hide countdown and start simulation!
    countdown_bar.hide()
    dating_screen.start_simulation()

func finish_phase3() -> void:
    print_debug("Finishing phase 3...")
    assert(current_phase == 3)

    # Add round score to total score
    var dating_screen := current_phase_scene as DatingScreen
    var _round_score = dating_screen.round_score
    total_score += _round_score

    # Remove cards from pool if the date was especially nice - or terrible.
    if _round_score <= -PROFILE_REMOVAL_THRESHOLD or _round_score >= PROFILE_REMOVAL_THRESHOLD:
        print_debug("Removing profiles %s and %s from pool." % [pairing_profile_card1.name, pairing_profile_card2.name])
        profile_card_pool.remove_from_pool(pairing_profile_card1.name)
        profile_card_pool.remove_from_pool(pairing_profile_card2.name)

    # Next round (if cards left)
    finish_round()
