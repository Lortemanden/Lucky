extends Node
  
###### Generic utility functions ######
func shortNumber(n, noDecimalsOnSmallValues=false):
    var split = str(n).split(".")
    var length = split[0].length()
    var result = str(n)

    if length > 3:
        var postFixes = ["", "", "K", "M", "B", "T", "aa", "ab"]
        for i in range(2,8):
            if length <= i*3:
                var pre = split[0].substr(0,length-(i*3-3))
                var post = split[0].substr(length-(i*3-3), i*3-length)
                if post.length() > 0:
                    result = pre + "." + post + postFixes[i]
                else:
                    result = pre + postFixes[i]
                break
    if noDecimalsOnSmallValues and length < 3:
        result = split[0]
    else:
        if split[0].length() == 3:
            result = str("%1.2f" % n).substr(0,3)
        else:
            result = str("%1.2f" % n).substr(0,4)

    return result

func formatNumber(n, thousand_separator=".", _decimal_separator=","):
    var split = str(n).split(".")
    for i in range(split[0].length() - 3, 0, -3):
        split[0] = split[0].substr(0, i) + thousand_separator + split[0].substr(i, split[0].length())
    return split[0]

func unformat(n,_thousand_separator=".", _decimal_separator=","):
    var split = str(n).split(".")
    var new := ""
    for i in split.size():
        new = new+ split[i]
    return new
#give an array of weights and return randomly picked index
func weighedRandom(probabilities):
    var total = 0
    for j in range(probabilities.size()):
        total += probabilities[j]

    var chance = randf() * total
    var sum = 0
    for i in range(probabilities.size()):
        sum += probabilities[i]
        if (chance < sum):
            return i

    return probabilities.size()-1

#will take supplied array and shuffle it
func shuffleArray(array):
    var size = array.size()
    var i = 0
    for item in array:
        var temp = array[i]
        var random_index = rand_range(i, size)
        array[i] = array[random_index]
        array[random_index] = temp
        i += 1
    return array

func shuffleString(s, rngSeed=0):
    var stringArray = []
    var shuffled = ""
    for i in range(s.length()):
        stringArray.append(s.substr(i,1))
    var rng = RandomNumberGenerator.new()
    if rngSeed == 0:
        rng.randomize()
    else:
        rng.seed = rngSeed
    while stringArray.size() > 0:
        var index = rng.randi_range(0, stringArray.size()-1)
        shuffled += stringArray[index]
        stringArray.remove(index)
    return shuffled

func isStringReadable(s):
    var vowels = ["a", "e", "i", "o", "u", "y", "æ", "ø", "å"]
    var consonants = ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "v", "x", "z"]
    
    var stringArray = []
    for i in range(s.length()):
        stringArray.append(s.substr(i,1))
    
    var maxVowelCount = 0
    var count = 0
    for a in stringArray:
        if vowels.has(a):
            count += 1
            if count > maxVowelCount:
                maxVowelCount = count
        else:
            count = 0

    var maxConsonantCount = 0
    count = 0
    for a in stringArray:
        if consonants.has(a):
            count += 1
            if count > maxConsonantCount:
                maxConsonantCount = count
        else:
            count = 0

    if maxVowelCount < 2 and maxConsonantCount < 3:
        return true
    else:
        return false

func timeFormat(timeInSeconds, hideHours=false, hideSeconds=false):
    var hours = floor(timeInSeconds/(60*60))
    var hourString = "0" + str(hours) if str(hours).length() == 1 else str(hours)
    var minutes = floor((timeInSeconds-(hours*60*60))/60)
    var minuteString = "0" + str(minutes) if str(minutes).length() == 1 else str(minutes)
    var seconds = timeInSeconds - (hours*60*60) - (minutes*60)
    var secondString = "0" + str(seconds) if str(seconds).length() == 1 else str(seconds)
    if hideHours and hours == 0:
        if hideSeconds:
            return minuteString
        else:
            return minuteString + ":" + secondString
    elif hideSeconds:
        return hourString + ":" + minuteString
    else:
        return hourString + ":" + minuteString + ":" + secondString

func timeFormatHMS(timeInSeconds, hideSeconds=false):
    var hours = floor(timeInSeconds/(60*60))
    var hourString = str(hours)
    var minutes = floor((timeInSeconds-(hours*60*60))/60)
    var minuteString = str(minutes)
    var seconds = timeInSeconds - (hours*60*60) - (minutes*60)
    var secondString = str(seconds)
    if hideSeconds:
        return hourString + "H " + minuteString + "M"
    else:
        return hourString + "H " + minuteString + "M " + secondString + "S"

func trimmedTimeFormatHMS(timeInSeconds, hideSecondsOnHours=false):
    var hours = floor(timeInSeconds/(60*60))
    var hourString = str(hours)
    var minutes = floor((timeInSeconds-(hours*60*60))/60)
    var minuteString = str(minutes)
    var seconds = timeInSeconds - (hours*60*60) - (minutes*60)
    var secondString = str(seconds)

    if hours == 0 and minutes == 0:
        return secondString + "S"
    elif hours == 0:
        if seconds == 0:
            return minuteString + "M"
        return minuteString + "M " + secondString + "S"
    elif hideSecondsOnHours:
        return hourString + "H " + minuteString + "M "
    else:
        return hourString + "H " + minuteString + "M " + secondString + "S"

func timeFormatDHM(timeInSeconds):
    var days = floor(timeInSeconds/(60*60*24))
    var dayString = str(days)
    var hours = floor(timeInSeconds/(60*60))-(days*24)
    var hourString = str(hours)
    var minutes = floor((timeInSeconds-(hours*60*60)-(days*24*60*60))/60)
    var minuteString = str(minutes)
    return dayString + "D " + hourString + "H " + minuteString + "M "

func timeFormatDHMS(timeInSeconds):
    var days = floor(timeInSeconds/(60*60*24))
    var dayString = str(days)
    var hours = floor(timeInSeconds/(60*60))-(days*24)
    var hourString = str(hours)
    var minutes = floor((timeInSeconds-(hours*60*60)-(days*24*60*60))/60)
    var minuteString = str(minutes)
    var seconds = timeInSeconds-(minutes*60)-(hours*60*60)-(days*24*60*60)
    var secondString = str(seconds)
    return dayString + "D " + hourString + "H " + minuteString + "M " + secondString + "S"

func DHMSinSeconds(DHMSstring):
    var string = DHMSstring.to_upper()
    var timeDict = {}
    timeDict["X"] = ""
    var currentKey = "X"

    for i in range(string.length()-1, -1, -1):
        if not string[i].is_valid_integer():
            currentKey = string[i]
            timeDict[currentKey] = ""
        else:
            timeDict[currentKey] = string[i] + timeDict[currentKey]

    var totalSeconds:int = 0
    if timeDict.has("D"):
        totalSeconds += int(timeDict["D"]) * 86400
    if timeDict.has("H"):
        totalSeconds += int(timeDict["H"]) * 3600
    if timeDict.has("M"):
        totalSeconds += int(timeDict["M"]) * 60
    if timeDict.has("S"):
        totalSeconds += int(timeDict["S"])
    return totalSeconds

func localTimeOffset():
    return OS.get_unix_time_from_datetime(OS.get_datetime()) - OS.get_unix_time()

#center resize a label to fit text - label must have grow direction set to BOTH
#use like this after changing text: Utility.call_deferred("fitLabel", heading, 200)
func fitLabel(label,size,scale = 1):
    if is_instance_valid(label):
        var pivot = 0
        if label.align == Label.ALIGN_CENTER:
            pivot = label.rect_size.x / 2
        elif label.valign == Label.ALIGN_RIGHT:
            pivot = label.rect_size.x
        var mirrored = sign(label.rect_scale.x)
        var minimumSizeX = label.get_minimum_size().x
        if minimumSizeX > size:
            label.rect_pivot_offset.x = pivot * mirrored* scale
            label.rect_scale.x = (size / minimumSizeX) * mirrored  * scale
        else:
            label.rect_scale.x = 1.0 * mirrored  * scale
    pass

#get an interpolated point at time t between p1 and p2
func catmullRomPoint(t, p0, p1, p2, p3):
    var t2 = t * t
    var t3 = t2 * t
    var x = 0.5 * ( ( 2.0 * p1[0] ) + ( -p0[0] + p2[0] ) * t + ( 2.0 * p0[0] - 5.0 * p1[0] + 4 * p2[0] - p3[0] ) * t2 + ( -p0[0] + 3.0 * p1[0] - 3.0 * p2[0] + p3[0] ) * t3 )
    var y = 0.5 * ( ( 2.0 * p1[1] ) + ( -p0[1] + p2[1] ) * t + ( 2.0 * p0[1] - 5.0 * p1[1] + 4 * p2[1] - p3[1] ) * t2 + ( -p0[1] + 3.0 * p1[1] - 3.0 * p2[1] + p3[1] ) * t3 )
    return Vector2(x,y)

#get an interpolated point at time t between p1 and p2
func bSplinePoint(t, p0, p1, p2, p3):
    var t2 = t * t
    var t3 = t2 * t
    var x = ( t3* ( -p0[0] + (3 * p1[0]) - (3 * p2[0]) + p3[0] ) + t2 * ( (3 * p0[0]) - (6 * p1[0]) + (3 * p2[0]) ) + t * ( (-3 * p0[0]) + (3 * p2[0]) ) + p0[0] + (4 * p1[0]) + p2[0] ) / 6
    var y = ( t3* ( -p0[1] + (3 * p1[1]) - (3 * p2[1]) + p3[1] ) + t2 * ( (3 * p0[1]) - (6 * p1[1]) + (3 * p2[1]) ) + t * ( (-3 * p0[1]) + (3 * p2[1]) ) + p0[1] + (4 * p1[1]) + p2[1] ) / 6
    return Vector2(x,y)

#returns all posible permutations of an array
func permutations(arr):
    var ac = [[]]
    for x in arr:
        var ac_new = []
        for ts in ac:
            for n in range(0,ts.size()+1):
                var new_ts = ts.duplicate()
                new_ts.insert(n,x)
                ac_new.append(new_ts)
        ac = ac_new
    return ac

#returns all combinations of length k from array
func combinations(arr, k):
    var ret = []
    var sub
    var next
    for i in range(arr.size()):
        if (k == 1):
            ret.push_back([arr[i]])
        else:
            sub = combinations(arr.slice(i+1, arr.size()), k-1)
            for subI in range(sub.size()):
                next = sub[subI]
                next.push_front(arr[i])
                ret.push_back(next)
    return ret

func scientific_notation(number:float) -> String:
    var sign_ = sign(number)
    number = abs(number)
    if number < 1:
        var exp_ = decimals(number)
        var coeff = sign_ * number * pow(10, exp_)
        return String(coeff) + "e" + String(-exp_)
    elif number >= 10:
        var exp_ = String(int(number)).length() - 1
        var coeff = sign_ * number / pow(10, exp_)
        return String (coeff) + "e" + String(exp_)
    else:
        return String(number) + "e0"

func webSafeToNormalBase64(websafeBase64):
    var base64 = websafeBase64
    var regex = RegEx.new()
    regex.compile("\\-")
    base64 = regex.sub(base64, "+")

    regex = RegEx.new()
    regex.compile("_")
    base64 = regex.sub(base64, "/")

    return base64 + "==".substr(0, (3 * websafeBase64.length()) % 4)

func deepCastRealToInt(input):
    if typeof(input) == TYPE_REAL:
        input = int(input)
    elif typeof(input) == TYPE_DICTIONARY:
        for key in input:
            input[key] = deepCastRealToInt(input[key])
    elif typeof(input) == TYPE_ARRAY:
        for i in range(input.size()):
            input[i] = deepCastRealToInt(input[i])
    return input
