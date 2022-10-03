class_name DatingScreen
extends BaseGamePhase

signal simulation_finished(round_score)

onready var date_o_meter := $DateOMeter as DateOMeter

# Profile cards and date cards selected by player in earlier phases
var profile_card1: ProfileCard = null
var profile_card2: ProfileCard = null
var location_card: LocationCard = null
var activity_card: ActivityCard = null

# Score of this round
var round_score := 0

func finish_phase() -> void:
    print_debug("Finishing phase 3. Next round!")

func set_profile_cards(_card1: ProfileCard, _card2: ProfileCard) -> void:
    profile_card1 = _card1
    profile_card2 = _card2

    # Add cards to scene tree
    add_child(profile_card1)
    add_child(profile_card2)

    # Move cards to the bottom of the screen with fancy, quick animations
    profile_card1.slide_to_position(Vector2(108, 550), 0.3)
    profile_card2.slide_to_position(Vector2(300, 550), 0.3)

func set_date_cards(_location_card: LocationCard, _activity_card: ActivityCard) -> void:
    location_card = _location_card
    activity_card = _activity_card

    # Move cards to the bottom of the screen with fancy, quick animations
    if location_card:
        add_child(location_card)
        location_card.slide_to_position(Vector2(1024, 600), 0.3)

    if activity_card:
        add_child(activity_card)
        activity_card.slide_to_position(Vector2(1184, 600), 0.3)

func start_simulation() -> void:
    round_score = 0

    var _score1 := 0
    var _score2 := 0

    # Check if profiles like or dislike each other (double points if like+like / dislike+dislike)
    _score1 = check_profile_likes_profile(profile_card1, profile_card2)
    yield(get_tree().create_timer(1), "timeout")
    _score2 = check_profile_likes_profile(profile_card2, profile_card1)
    yield(get_tree().create_timer(1), "timeout")
    double_points_if_equal(_score1, _score2)
    yield(get_tree().create_timer(1), "timeout")

    # Check if profiles like or dislike the location (double points if like+like / dislike+dislike)
    _score1 = check_profile_likes_location(profile_card1)
    yield(get_tree().create_timer(1), "timeout")
    _score2 = check_profile_likes_location(profile_card2)
    yield(get_tree().create_timer(1), "timeout")
    double_points_if_equal(_score1, _score2)
    yield(get_tree().create_timer(1), "timeout")

    # Check if profiles like or dislike the activity (double points if like+like / dislike+dislike)
    _score1 = check_profile_likes_activity(profile_card1)
    yield(get_tree().create_timer(1), "timeout")
    _score2 = check_profile_likes_activity(profile_card2)
    yield(get_tree().create_timer(1), "timeout")
    double_points_if_equal(_score1, _score2)
    yield(get_tree().create_timer(1), "timeout")

    # Check if activity fits to the location
    check_location_fits_to_activity()
    yield(get_tree().create_timer(1), "timeout")

    print("Simulation finished. Score: %d" % round_score)
    # emit_signal("simulation_finished", round_score)

func log_score(_card1: BaseCard, _card2: BaseCard, _score: int) -> void:
    print("Does %s like %s? -> %d points! -> Total: %d" % [_card1.name, _card2.name, _score, round_score + _score])

func add_to_score(_points: int) -> void:
    round_score += _points
    date_o_meter.move_to_new_score(round_score)

func double_points_if_equal(_score1: int, _score2: int) -> void:
    var _bonus = 0
    if _score1 == _score2:
        _bonus = _score1 + _score2
        print("Double points! Add %d points -> Total: %d" % [_bonus, round_score + _bonus])
    else:
        print("(No bonus.)")
    add_to_score(_bonus)

func check_profile_likes_profile(_profile1: ProfileCard, _profile2: ProfileCard) -> int:
    # Like/neutral/dislike: +10 / 0 / -20 points
    var _points := 0
    if _profile1.likes_profiles.has(_profile2.name):
        _points = 10
    elif _profile1.dislikes_profiles.has(_profile2.name):
        _points = -20

    log_score(_profile1, _profile2, _points)
    add_to_score(_points)
    return _points

func check_profile_likes_location(_profile: ProfileCard) -> int:
    # Like/neutral/dislike: +10 / 0 / -10 points
    var _points := 0
    if not location_card or _profile.dislikes_locations.has(location_card.name):
        _points = -10
    elif _profile.likes_locations.has(location_card.name):
        _points = 10

    log_score(_profile, location_card, _points)
    add_to_score(_points)
    return _points

func check_profile_likes_activity(_profile: ProfileCard) -> int:
    # Like/neutral/dislike: +10 / 0 / -10 points
    var _points := 0
    if not activity_card or _profile.dislikes_activities.has(activity_card.name):
        _points = -10
    elif _profile.likes_activities.has(activity_card.name):
        _points = 10

    log_score(_profile, activity_card, _points)
    add_to_score(_points)
    return _points

func check_location_fits_to_activity() -> int:
    # Good/neutral/bad: +10 / 0 / -10 points
    var _points := 0
    if location_card and activity_card:
        if location_card.good_activities.has(activity_card.name):
            _points = 10
        elif location_card.bad_activities.has(activity_card.name):
            _points = -10

    print("Does activity %s fit to location %s? -> %d points! -> Total: %d"
          % [activity_card.name, location_card.name, _points, round_score + _points])
    add_to_score(_points)
    return _points
