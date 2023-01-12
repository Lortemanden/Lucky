extends Node2D
onready var pcs := [get_node("Pc1"),get_node("Pc2"),get_node("Pc3")]
onready var chairs := [get_node("Chair1"),get_node("Chair2"),get_node("Chair3")]
export var direction : int 
onready var table = $Table



var blackPcPath := "res://gfx/Pc/black"
var chairPath := "res://gfx/Chairs/chair"
var goldPcPath := "res://gfx/Pc/gold"
func _ready():
    if direction == 0:
        for pc in pcs:
            pc.texture_normal = load(blackPcPath+"_on.png")
        for chair in chairs:
            chair.texture = load(chairPath+".png")
    elif direction == 1:
        for pc in pcs:
            pc.rect_rotation =-90
            pc.texture_normal = load(blackPcPath+"_left_on.png")
        for chair in chairs:
            chair.rotation_degrees = -90
            chair.texture = load(chairPath+"_left.png")
    elif direction == 2:
        for pc in pcs:
            pc.rect_rotation =-180
            pc.texture_normal = load(blackPcPath+"_top_on.png")
        for chair in chairs:
            table.position.y = -2
            table.rotation_degrees = 180
            chair.position.y = 14
            chair.rotation_degrees = -180
            chair.texture = load(chairPath+"_top.png")
    elif direction == 3:
        for pc in pcs:
            pc.rect_rotation = 90
            pc.texture_normal = load(blackPcPath+"_right_on.png")
        for chair in chairs:
            chair.rotation_degrees = 90
            chair.texture = load(chairPath+"_right.png")
    pass 
