class_name DatingScreen
extends BaseGamePhase

func finish_phase() -> void:
    print_debug("Finishing phase 3. Next round!")

func set_profile_cards(card1: ProfileCard, card2: ProfileCard) -> void:
    # Add cards to scene tree
    add_child(card1)
    add_child(card2)

    # Move cards to the bottom of the screen with fancy, quick animations
    card1.slide_to_position(Vector2(108, 550), 0.3)
    card2.slide_to_position(Vector2(300, 550), 0.3)

func set_date_cards(date_location_card: LocationCard, date_activity_card: ActivityCard) -> void:
    # Move cards to the bottom of the screen with fancy, quick animations
    if date_location_card:
        add_child(date_location_card)
        date_location_card.slide_to_position(Vector2(1024, 600), 0.3)

    if date_activity_card:
        add_child(date_activity_card)
        date_activity_card.slide_to_position(Vector2(1184, 600), 0.3)
