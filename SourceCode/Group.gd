extends Node2D
onready var playScene = $"../.."
export(int) var offset = 0

func _ready():
    var count = 1 + offset
    for table in get_children():
        for chair in table.get_children():
            chair.number = count
            playScene.chairReady(chair)
            count += 1
    pass

func readyChairs(ready:bool):
    for table in get_children():
        for chair in table.get_children():
            chair.pc.pressed = ready
            chair._on_Pc_pressed(false)
    Game.saveSettingsData()
    Game.postUserData()
    pass
