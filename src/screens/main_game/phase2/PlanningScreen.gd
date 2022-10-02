class_name PlanningScreen
extends BaseGamePhase

signal planning_cards_selected

var player: Player = null

var dating_score := 0

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("interact"):
        add_point()

func set_player(_player: Player) -> void:
    player = _player
    add_child(player)

func set_profile_cards(card1: ProfileCard, card2: ProfileCard) -> void:
    # Add cards to scene tree
    add_child(card1)
    add_child(card2)

    # Move cards to the bottom of the screen with fancy, quick animations
    var tween := get_tree().create_tween()
    tween.set_parallel(true)
    tween.set_trans(Tween.TRANS_SINE)

    tween.tween_property(card1, "position", Vector2(card1.position.x, 600), 0.3)
    tween.tween_property(card2, "position", Vector2(card2.position.x, 600), 0.3)

func finish_phase() -> void:
    print_debug("Finishing phase 2 with %d points." % dating_score)
    emit_signal("planning_cards_selected")

func add_point() -> void:
    dating_score += 1
    print_debug("Adding point to score. New score: %d" % dating_score)
