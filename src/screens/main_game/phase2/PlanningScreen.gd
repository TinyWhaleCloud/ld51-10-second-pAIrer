class_name PlanningScreen
extends BaseGamePhase

signal planning_cards_selected

onready var card_slot_date_location := $CardSlotDateLocation as CardSlot
onready var card_slot_date_activity := $CardSlotDateActivity as CardSlot

var player: Player = null

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("interact"):
        var touched_card := find_card_touched_by_player()
        if touched_card:
            select_card(touched_card)

func set_player(_player: Player) -> void:
    player = _player
    add_child(player)

func set_profile_cards(card1: ProfileCard, card2: ProfileCard) -> void:
    # Add cards to scene tree
    add_child(card1)
    add_child(card2)

    # Move cards to the bottom of the screen with fancy, quick animations
    card1.slide_to_position(Vector2(card1.position.x, 600), 0.3)
    card2.slide_to_position(Vector2(card2.position.x, 600), 0.3)

func all_card_slots_filled() -> bool:
    return card_slot_date_location.is_occupied and card_slot_date_activity.is_occupied

func find_card_touched_by_player() -> DateCard:
    for _card in get_tree().get_nodes_in_group("DateCards"):
        var card := _card as DateCard
        # TODO: Handle cases where multiple cards are touched at the same time
        if card and card.overlaps_body(player) and card.selectable:
            return card
    return null

func select_card(card: DateCard) -> void:
    if card.is_date_location():
        if card_slot_date_location.is_occupied:
            print_debug("Player selected location card '%s', but a date location has already been chosen." % card.card_title)
            return

        print_debug("Player selected card '%s' as date location." % card.card_title)
        card_slot_date_location.set_card(card)
        card.selectable = false

    elif card.is_date_activity():
        if card_slot_date_activity.is_occupied:
            print_debug("Player selected activity card '%s', but a date activity has already been chosen." % card.card_title)
            return

        print_debug("Player selected card '%s' as date activity." % card.card_title)
        card_slot_date_activity.set_card(card)
        card.selectable = false

    else:
        print_debug("Unknown date card type: %d" % card.date_card_type)
        return

    if all_card_slots_filled():
        print_debug("All card slots filled! Next phase!")
        # Dramatic pause
        yield(get_tree().create_timer(0.5), "timeout")
        emit_signal("planning_cards_selected")

func get_date_location_card() -> DateCard:
    return card_slot_date_location.current_card as DateCard

func get_date_activity_card() -> DateCard:
    return card_slot_date_activity.current_card as DateCard
