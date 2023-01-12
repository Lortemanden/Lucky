tool
extends Node2D

onready var playScene = $"../../../.."
onready var pc = $Pc
onready var chair = $Chair
onready var animation_player = $AnimationPlayer
onready var shine = $Shine
onready var particle_shine = $ParticleShine
onready var rich_text_label = $Label/RichTextLabel

var pcPosition = {"down":Vector2(-16,-48),"top":Vector2(-16,16),"left":Vector2(14,-16),"right":Vector2(-48,-16)}
export(int) var number = 0
export(String) var direction = "left" setget setDirection

func _ready():
    setDirection(direction)
    playScene.chairReady(self)
    rich_text_label.bbcode_text = "[wave amp=50 freq=2][center]"+str(number)
    pass

func setGolden():
    $Chair.texture = load("res://gfx/Chairs/chair_win_"+direction+".png")
    pass

func setNormalChair():
    $Chair.texture = load("res://gfx/Chairs/chair_"+direction+".png")
    pass
    
func setDirection(value):
    direction = value
    setNormalChair()
    $Pc.texture_normal = load("res://gfx/Pc/black_"+direction+".png")
    $Pc.texture_pressed = load("res://gfx/Pc/white_"+direction+".png")
    $Pc.rect_position = pcPosition[direction]
    pass

func _on_Pc_pressed():
    if pc.pressed:
        playScene.chairNotReady(self)
    else:
        playScene.chairReady(self)
    pass

func celebrate():
    particle_shine.emitting = true
    animation_player.get_animation("celebrate").loop = true
    animation_player.play("celebrate")
    chair.z_index =1
    shine.visible = true
    rich_text_label.visible = true
    pass

func stopAnimation():
    animation_player.get_animation("celebrate").loop = false
    particle_shine.emitting = false
    shine.visible = false
    rich_text_label.visible = false
    chair.z_index = 0
    pass
