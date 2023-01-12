extends Node

export var playerCount = 16

var players = []
var nextPlayerIndex := 0

var currentVariationLoop = {"name":"none"}
var lastVariationLoopRestart = OS.get_system_time_msecs()
var variationLoopPlaying = false
var variationLoopWaiting = false
var variationLoopWaitingDelay = 0

var fadingPlayers = []

var onOff:String = "soundOn" #variable name in Game script to check for on off

var globalVolume = 0.6

func _ready():
    for _i in range(playerCount):
        var p = AudioStreamPlayer.new()
        
        add_child(p)
        players.append(p)
    pass

func setOnOff(name:String):
    onOff = name
    pass

func _process(_delta):
    if variationLoopWaiting:
        var time = OS.get_system_time_msecs()
        var timeSinceLastVariationLoopRestart = time - lastVariationLoopRestart
        if timeSinceLastVariationLoopRestart >= variationLoopWaitingDelay:
            variationLoopWaiting = false
            playNextLoopWithVariation()
    elif variationLoopPlaying:
        var time = OS.get_system_time_msecs()
        var timeSinceLastVariationLoopRestart = time - lastVariationLoopRestart
        if timeSinceLastVariationLoopRestart >= currentVariationLoop.loopLength * 1000:
            playNextLoopWithVariation()
    pass

func play(stringPath, delay:=0.0, volume=1.0, looping=false, pitch=1.0):
    if delay > 0.0:
        var timer = Timer.new()
        add_child(timer)
        timer.set_wait_time(delay)
        timer.start()
        yield(timer, "timeout")
        timer.queue_free()
    
    var playerIndex : int
    playerIndex = nextPlayerIndex

    
    players[playerIndex].set_stream( load(stringPath) )
    players[playerIndex].stream.loop = looping
    players[playerIndex].pitch_scale = pitch
    players[playerIndex].volume_db = log(volume * globalVolume) * 8.6858896380650365530225783783321
    players[playerIndex].play()
    nextPlayerIndex = getFinishedPlayer()
    return playerIndex

func playVariationLoop(variationLoop, delay=0):
    if currentVariationLoop.name != variationLoop.name:
        currentVariationLoop = variationLoop
        
        if delay > 0:
            variationLoopWaiting = true
            variationLoopWaitingDelay = delay * 1000
            lastVariationLoopRestart = OS.get_system_time_msecs()
        else:
            playNextLoopWithVariation()
    pass

func playNextLoopWithVariation():
    variationLoopPlaying = true
    lastVariationLoopRestart = OS.get_system_time_msecs()
    
    if currentVariationLoop.variations.size() > 0 and randi()%100 <= currentVariationLoop.variationChance:
        play(currentVariationLoop.variations[randi()%currentVariationLoop.variations.size()], 0.0, currentVariationLoop.volume)
        
    if currentVariationLoop.sets.size() > 0:
        var set = randi()%currentVariationLoop.sets.size()
        for i in range(currentVariationLoop.sets[set].size()):
            play(currentVariationLoop.loops[currentVariationLoop.sets[set][i]], rand_range(currentVariationLoop.setPieceInterval[0], currentVariationLoop.setPieceInterval[1]) * i, currentVariationLoop.volume)
    else:
        play(currentVariationLoop.loops[randi()%currentVariationLoop.loops.size()], 0.0, currentVariationLoop.volume)
    pass

func setVolumeOfPlayingPlayer(playerIndex, volume):
    
    if players[playerIndex].playing:
        players[playerIndex].volume_db = log(volume * globalVolume) * 8.6858896380650365530225783783321
    pass

func fadeOutAll(duration):
    for i in range(players.size()):
        if players[i].playing and not isFading(players[i]):
            fadeOutPlayer(i, duration)
    pass

func fadeOutPlayer(playerIndex, duration, stop=true):
    fadingPlayers.append(players[playerIndex].get_instance_id())
    var tween = Tween.new()
    add_child(tween)
    if stop:
        tween.connect("tween_completed", self, "stopFading")
    tween.interpolate_property(players[playerIndex], "volume_db", 
        players[playerIndex].volume_db,
        -80,
        duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
    tween.start()
    pass

func stopFading(player,_nodePath):
    for i in range(fadingPlayers.size()):
        if fadingPlayers[i] == player.get_instance_id():
            fadingPlayers.remove(i)
            break
    player.stop()
    pass

func isFading(player):
    var fading = false
    for j in range(fadingPlayers.size()):
        if fadingPlayers[j] == player.get_instance_id():
            fading = true
            break
    return fading

func stopAll():
    for i in range(players.size()):
        players[i].stop()
    for i in range(get_child_count()):
        var child = get_child(i)
        if child is Timer:
            child.stop()
    stopVariationLoop()
    pass

func stopPlayerIndex(playerIndex, delay := 0.0):
    if delay > 0.0:
        var timer = Timer.new()
        add_child(timer)
        timer.set_wait_time(delay)
        timer.start()
        yield(timer, "timeout")
        timer.queue_free()
    
    
    if playerIndex < players.size():
        players[playerIndex].stop()
    pass

func stopPlayer(player):
    player.stop()
    pass

func stopVariationLoop():
    currentVariationLoop = {"name":"none"}
    variationLoopPlaying = false
    variationLoopWaiting = false
    variationLoopWaitingDelay = 0
    pass

func getFinishedPlayer():
    for i in range(players.size()):
        if not players[i].playing and not isFading(players[i]):
            return i
    var p = AudioStreamPlayer.new()
    add_child(p)
    players.append(p)
    return players.size()-1
