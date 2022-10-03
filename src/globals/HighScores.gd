extends Node

const HIGHSCORE_FILENAME = "user://highscore.txt"

# Highscore as saved in file
var highscore := 0

# Last score (not persisted, only for game over screen)
var last_score := 0
var last_score_is_new_high := false

func _ready() -> void:
    load_highscore()

func set_score_if_higher(_score: int) -> bool:
    if _score > highscore:
        print_debug("New highscore: %d (old: %d)" % [_score, highscore])
        highscore = _score
        save_highscore()
        return true
    return false

func load_highscore() -> void:
    # Try to load the highscore file
    var highscore_file := File.new()
    if not highscore_file.file_exists(HIGHSCORE_FILENAME):
        return

    var err := highscore_file.open(HIGHSCORE_FILENAME, File.READ)
    if err != OK:
        printerr("Error opening highscore file to read: ", err)
        return

    # Parse highscore file as integer
    var highscore_from_file := highscore_file.get_line()
    if not highscore_from_file.is_valid_integer():
        printerr("Error reading highscore from file: Not a valid integer")
        return
    highscore = int(highscore_from_file)

    print_debug("Loaded highscore from file: %d" % highscore)

func save_highscore() -> void:
    # Try to save the highscore file
    var highscore_file := File.new()

    var err = highscore_file.open(HIGHSCORE_FILENAME, File.WRITE)
    if err != OK:
        printerr("Error opening highscore file to write: ", err)
        return

    # Write highscore to file
    highscore_file.store_line(str(highscore))
