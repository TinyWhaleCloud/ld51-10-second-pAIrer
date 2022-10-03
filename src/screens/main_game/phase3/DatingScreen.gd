class_name DatingScreen
extends BaseGamePhase

signal finish_round

onready var date_o_meter := $DateOMeter as DateOMeter
onready var status_text_label := $StatusTextLabel as RichTextLabel

# Profile cards and date cards selected by player in earlier phases
var profile_card1: ProfileCard = null
var profile_card2: ProfileCard = null
var location_card: LocationCard = null
var activity_card: ActivityCard = null

# Score of this round
var round_score := 0
var simulation_finished := false

func _input(event: InputEvent) -> void:
    if simulation_finished and event.is_action_pressed("ui_accept"):
        finish_phase()

func finish_phase() -> void:
    print_debug("Finishing phase 3. Next round!")
    emit_signal("finish_round")

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
    var _score_sum := 0

    if location_card:
        $AudioStreamPlayer.stream = location_card.location_music
        $AudioStreamPlayer.play()

    # Check if profiles like or dislike each other (double points if like+like / dislike+dislike)
    set_status_text("Checking romantic compatibility...")
    _score1 = check_profile_likes_profile(profile_card1, profile_card2)
    _score2 = check_profile_likes_profile(profile_card2, profile_card1)
    _score_sum = double_points_if_equal(_score1, _score2)
    yield(get_tree().create_timer(1.5), "timeout")

    add_to_score(_score_sum)
    set_status_points(_score_sum)
    yield(get_tree().create_timer(1.5), "timeout")

    # Check if profiles like or dislike the location (double points if like+like / dislike+dislike)
    set_status_text("Checking location preferences...")
    _score1 = check_profile_likes_location(profile_card1)
    _score2 = check_profile_likes_location(profile_card2)
    _score_sum = double_points_if_equal(_score1, _score2)
    yield(get_tree().create_timer(1.5), "timeout")

    add_to_score(_score_sum)
    set_status_points(_score_sum)
    yield(get_tree().create_timer(1.5), "timeout")

    # Check if profiles like or dislike the activity (double points if like+like / dislike+dislike)
    set_status_text("Checking activity preferences...")
    _score1 = check_profile_likes_activity(profile_card1)
    _score2 = check_profile_likes_activity(profile_card2)
    _score_sum = double_points_if_equal(_score1, _score2)
    yield(get_tree().create_timer(1.5), "timeout")

    add_to_score(_score_sum)
    set_status_points(_score_sum)
    yield(get_tree().create_timer(1.5), "timeout")

    # Check if activity fits to the location
    set_status_text("Combining location and activity...")
    _score_sum = check_location_fits_to_activity()
    yield(get_tree().create_timer(1.5), "timeout")

    add_to_score(_score_sum)
    set_status_points(_score_sum)
    yield(get_tree().create_timer(1.5), "timeout")

    # Show date score!
    print("Simulation finished. Score: %d" % round_score)
    set_status_text("DATE SCORE:")
    set_status_points(round_score)
    append_status_text("(Press enter to continue.)")
    simulation_finished = true

func log_score(_card1: BaseCard, _card2: BaseCard, _score: int) -> void:
    if _card1 and _card2:
        print("Does %s like %s? -> %d points -> Total: %d" % [_card1.name, _card2.name, _score, round_score + _score])
    else:
        print("Empty card slot! -> %d points -> Total: %d" % [_score, round_score + _score])

func set_status_text(_text: String) -> void:
    status_text_label.bbcode_text = "[center]%s[/center]" % _text

func append_status_text(_text: String) -> void:
    status_text_label.append_bbcode("[center]%s[/center]" % _text)

func set_status_points(_points: int) -> void:
    var _text: String
    if _points < 0:
        _text = "[color=#ff0000]%d points[/color]" % _points
    elif _points > 0:
        _text = "[color=#00ff00]+%d points[/color]" % _points
    else:
        _text = "[color=#aaaaaa]No points[/color]"

    status_text_label.append_bbcode("\n[center]%s[/center]" % _text)

func add_to_score(_points: int) -> void:
    round_score += _points
    date_o_meter.move_to_new_score(round_score)

func double_points_if_equal(_score1: int, _score2: int) -> int:
    var _sum = _score1 + _score2
    if _score1 == _score2:
        print("Double points! Add %d points -> Total: %d" % [_sum, round_score + _sum])
        return _sum * 2
    else:
        print("(No bonus.)")
        return _sum

func check_profile_likes_profile(_profile1: ProfileCard, _profile2: ProfileCard) -> int:
    # Like/neutral/dislike: +10 / 0 / -20 points
    var _points := 0
    if _profile1.likes_profiles.has(_profile2.name):
        _points = 10
    elif _profile1.dislikes_profiles.has(_profile2.name):
        _points = -20

    log_score(_profile1, _profile2, _points)
    return _points

func check_profile_likes_location(_profile: ProfileCard) -> int:
    # Like/neutral/dislike: +10 / 0 / -10 points
    var _points := 0
    if not location_card or _profile.dislikes_locations.has(location_card.name):
        _points = -10
    elif _profile.likes_locations.has(location_card.name):
        _points = 10

    log_score(_profile, location_card, _points)
    return _points

func check_profile_likes_activity(_profile: ProfileCard) -> int:
    # Like/neutral/dislike: +10 / 0 / -10 points
    var _points := 0
    if not activity_card or _profile.dislikes_activities.has(activity_card.name):
        _points = -10
    elif _profile.likes_activities.has(activity_card.name):
        _points = 10

    log_score(_profile, activity_card, _points)
    return _points

func check_location_fits_to_activity() -> int:
    # Good/neutral/bad: +20 / 0 / -20 points
    var _points := 0
    if location_card and activity_card:
        if location_card.good_activities.has(activity_card.name):
            _points = 20
        elif location_card.bad_activities.has(activity_card.name):
            _points = -20

        print("Does activity %s fit to location %s? -> %d points! -> Total: %d"
            % [activity_card.name, location_card.name, _points, round_score + _points])

    return _points
