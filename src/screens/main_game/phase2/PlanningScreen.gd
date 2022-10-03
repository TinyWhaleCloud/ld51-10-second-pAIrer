class_name PlanningScreen
extends BaseGamePhase

signal planning_cards_selected

onready var card_slot_date_location := $CardSlotDateLocation as BaseCardSlot
onready var card_slot_date_activity := $CardSlotDateActivity as BaseCardSlot

var player: Player = null
var date_cards := []
var location_card_count := 0
var activity_card_count := 0

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
    card1.slide_to_position(Vector2(card1.position.x, 550), 0.3)
    card2.slide_to_position(Vector2(card2.position.x, 550), 0.3)

func get_location_card_position(i: int) -> Position2D:
    match i:
        0: return $LocationCardPosition1 as Position2D
        1: return $LocationCardPosition2 as Position2D
        2: return $LocationCardPosition3 as Position2D
    return null

func get_activity_card_position(i: int) -> Position2D:
    match i:
        0: return $ActivityCardPosition1 as Position2D
        1: return $ActivityCardPosition2 as Position2D
        2: return $ActivityCardPosition3 as Position2D
    return null

func add_location_card(card: LocationCard) -> void:
    var new_card_position := get_location_card_position(location_card_count)
    assert(new_card_position, "All location card positions are occupied!")

    date_cards.append(card)
    location_card_count += 1
    card.position = new_card_position.position
    add_child(card)

func add_activity_card(card: ActivityCard) -> void:
    var new_card_position := get_activity_card_position(activity_card_count)
    assert(new_card_position, "All activity card positions are occupied!")

    date_cards.append(card)
    activity_card_count += 1
    card.position = new_card_position.position
    add_child(card)

func all_card_slots_filled() -> bool:
    return card_slot_date_location.is_occupied and card_slot_date_activity.is_occupied

func find_card_touched_by_player() -> BaseDateCard:
    for _card in date_cards:
        var card := _card as BaseDateCard
        if card and card.overlaps_body(player) and card.selectable:
            return card
    return null

func select_card(card: BaseDateCard) -> void:
    if card is LocationCard:
        if card_slot_date_location.is_occupied:
            print_debug("Player selected location card '%s', but a date location has already been chosen." % card.card_title)
            return

        print_debug("Player selected card '%s' as date location." % card.card_title)
        card_slot_date_location.set_card(card)
        card.selectable = false

    elif card is ActivityCard:
        if card_slot_date_activity.is_occupied:
            print_debug("Player selected activity card '%s', but a date activity has already been chosen." % card.card_title)
            return

        print_debug("Player selected card '%s' as date activity." % card.card_title)
        card_slot_date_activity.set_card(card)
        card.selectable = false

    else:
        print_debug("Unknown date card type", card)
        return

    if all_card_slots_filled():
        print_debug("All card slots filled! Next phase!")
        # Dramatic pause
        yield(get_tree().create_timer(0.5), "timeout")
        emit_signal("planning_cards_selected")

func get_date_location_card() -> LocationCard:
    return card_slot_date_location.current_card as LocationCard

func get_date_activity_card() -> ActivityCard:
    return card_slot_date_activity.current_card as ActivityCard
