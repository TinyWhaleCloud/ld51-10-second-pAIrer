extends BaseGameScreen

onready var countdown_bar := $HUD/VBox/CountdownBar as CountdownBar

var player: Player = null

var dating_score := 0

func _ready() -> void:
    # Add player to scene
    player = GameState.player
    add_child(player)

    # Display selected profile cards
    display_profile_cards(GameState.pairing_profile_card1, GameState.pairing_profile_card2)

    # Start countdown (after a second delay)
    yield(get_tree().create_timer(1), "timeout")
    countdown_bar.connect("timeout", self, "_on_CountdownBar_timeout")
    # TODO: Add remaining time from phase 1
    countdown_bar.init_timer(10)
    countdown_bar.start_timer()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()
    elif event.is_action_pressed("debug_next_phase"):
        finish_phase()
    elif event.is_action_pressed("interact"):
        add_point()

func _on_CountdownBar_timeout() -> void:
    print_debug("Countdown timeout!")
    finish_phase()

func finish_phase() -> void:
    print_debug("Finishing phase 2 with %d points." % dating_score)
    GameState.add_round_score(dating_score)
    SceneManager.switch_to_phase3()

func display_profile_cards(card1: ProfileCard, card2: ProfileCard) -> void:
    var tween := get_tree().create_tween()
    tween.set_parallel(true)
    tween.set_trans(Tween.TRANS_SINE)

    # Add cards to scene tree
    add_child(card1)
    add_child(card2)

    # Move cards to the bottom of the screen with fancy, quick animations
    tween.tween_property(card1, "position", Vector2(card1.position.x, 600), 0.3)
    tween.tween_property(card2, "position", Vector2(card2.position.x, 600), 0.3)

func add_point() -> void:
    dating_score += 1
    print_debug("Adding point to score. New score: %d" % dating_score)
