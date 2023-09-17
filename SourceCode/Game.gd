extends Node

var saveFileName = "userData.json"
var userData = {"settings":{}}
var chairs  = {}

func _ready():
    getUserData()
    loadSettingsData()
    pass

func postUserData():
    var saveFile = File.new()
    saveFile.open(saveFileName, File.WRITE)
    saveFile.store_line(to_json(userData))
    saveFile.close()
    pass


func getUserData():
    var saveFile = File.new()
    if not saveFile.file_exists(saveFileName):
        return
    saveFile.open(saveFileName, File.READ)
    userData = parse_json(saveFile.get_line())
    pass

func saveSettingsData():
    var settingsSaveDict = {
        chairs = chairs
    }
    userData.settings = settingsSaveDict
    pass

func loadSettingsData():
    if userData.has("settings"):
        if userData.settings.has("chairs"):
            chairs = userData.settings.chairs
    pass 

