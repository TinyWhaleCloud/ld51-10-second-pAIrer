class_name DatingScreen
extends BaseGamePhase

func finish_phase() -> void:
    print_debug("Finishing phase 3. Next round!")

func set_profile_cards(card1: ProfileCard, card2: ProfileCard) -> void:
    # Add cards to scene tree
    add_child(card1)
    add_child(card2)

    # Move cards to the bottom of the screen with fancy, quick animations
    card1.slide_to_position(Vector2(120, 600), 0.3)
    card2.slide_to_position(Vector2(280, 600), 0.3)

func set_date_cards(date_location_card: DateCard, date_activity_card: DateCard) -> void:
    # Add cards to scene tree
    add_child(date_location_card)
    add_child(date_activity_card)

    # Move cards to the bottom of the screen with fancy, quick animations
    date_location_card.slide_to_position(Vector2(1000, 600), 0.3)
    date_activity_card.slide_to_position(Vector2(1160, 600), 0.3)
