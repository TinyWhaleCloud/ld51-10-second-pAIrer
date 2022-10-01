extends Node2D

var dating_score := 0

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()
    elif event.is_action_pressed("continue"):
        finish_phase()
    elif event.is_action_pressed("do_stuff"):
        add_point()

func finish_phase() -> void:
    print_debug("Finishing phase 1 with %d points." % dating_score)
    GameState.add_score(dating_score)
    SceneManager.switch_to_phase2()

func add_point() -> void:
    dating_score += 1
    print_debug("Adding point to score. New score: %d" % dating_score)
