extends Control

var chairs := {}
onready var timer = $Timer
onready var play = $Play

signal spinFinished(chair)

func _ready():
    pass # Replace with function body.

func chairReady(chair):
    chairs[chair.number] = chair
    pass

func chairNotReady(chair):
    chairs.erase(chair.number)
    pass

func _on_Play_pressed():
    for key in chairs:
        chairs[key].stopAnimation()
        chairs[key].setNormalChair()
    
    play.visible = false
    timer.wait_time = 0.2
    AudioPlayer.play("res://sfx/wheelSpin.ogg")
    spinForTime(20,false)
    yield(self,"spinFinished")
    timer.wait_time = 0.4
    spinForTime(10,false)
    yield(self,"spinFinished")
    timer.wait_time = 0.6
    spinForTime(5,false)
    yield(self,"spinFinished")
    timer.wait_time = 0.8 
    spinForTime(3,false)
    yield(self,"spinFinished")
    timer.wait_time = 1.18 
    connect("spinFinished",self,"winningCelebration")
    spinForTime(2,true)
    pass

func spinForTime(time, winner:bool):
    var previous = chairs.size()
    var keys = chairs.keys()
    var now = keys[randi()%keys.size()]
    for i in time:
        while now == previous:
            now = keys[randi()%keys.size()]
        chairs[now].setGolden()
        chairs[previous].setNormalChair()
        previous = now
        if winner and i == time-1:
            timer.wait_time = 0.5
            timer.start()
            yield(timer,"timeout")
            emit_signal("spinFinished",chairs[now])
            return
        timer.start()
        yield(timer,"timeout")
        if i == time-1 and not winner:
            chairs[previous].setNormalChair()
        
    emit_signal("spinFinished",chairs[now])
    pass
    
func winningCelebration(chair):
    disconnect("spinFinished",self,"winningCelebration")
    AudioPlayer.play("res://sfx/celebration"+str(randi()%4)+".ogg")
    chair.celebrate()
    play.visible = true
    pass

func chooseWinner():
    var keys = chairs.keys()
    return keys[randi()%keys.size()]
