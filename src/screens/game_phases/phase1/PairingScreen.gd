extends BaseGameScreen

onready var player := $Player as Player
onready var pair_card_slot_left := $PairCardSlotLeft as CardSlot
onready var pair_card_slot_right := $PairCardSlotRight as CardSlot

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()
    elif event.is_action_pressed("debug_next_phase"):
        finish_phase()
    elif event.is_action_pressed("interact"):
        var touched_card = find_card_touched_by_player()
        if touched_card:
            select_card(touched_card)

func finish_phase() -> void:
    print_debug("Finishing phase 1...")

    if all_card_slots_filled():
        yield(get_tree().create_timer(1.0), "timeout")
        print_debug("All card slots filled! Next phase!")
        SceneManager.switch_to_phase2()
    else:
        print_debug("Player hasn't finished! :(")
        # TODO: remove one life

func all_card_slots_filled() -> bool:
    return pair_card_slot_left.is_occupied and pair_card_slot_right.is_occupied

func find_card_touched_by_player() -> ProfileCard:
    for _card in get_tree().get_nodes_in_group("ProfileCards"):
        var card := _card as ProfileCard
        # TODO: Handle cases where multiple cards are touched at the same time
        if card and card.overlaps_body(player) and card.selectable:
            return card
    return null

func select_card(card: ProfileCard) -> void:
    # TODO: save selected cards in GameState
    if not pair_card_slot_left.is_occupied:
        print_debug("Player selected card '%s' for left pair slot." % card.card_title)
        pair_card_slot_left.set_card(card)
        card.selectable = false
    elif not pair_card_slot_right.is_occupied:
        print_debug("Player selected card '%s' for right pair slot." % card.card_title)
        pair_card_slot_right.set_card(card)
        card.selectable = false
    else:
        print_debug("Player selected card '%s' ... but there is no pair slot left!" % card.card_title)

    if all_card_slots_filled():
        finish_phase()
