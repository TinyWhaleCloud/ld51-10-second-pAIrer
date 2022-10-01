extends BaseGameScreen

func _ready() -> void:
    GameState.finish_round()
    $HUD.update_labels()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()
    elif event.is_action_pressed("debug_next_phase"):
        finish_phase()

func finish_phase() -> void:
    print_debug("Finishing phase 3. Next round!")
    SceneManager.switch_to_phase1()
