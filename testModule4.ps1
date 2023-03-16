[double] $barWidth = 441 # 80 / 128 ?
[double] $noteHeight = 18
[double] $shortestNote = 16 # 1 / 16, not pixel
[double] $startX = 97
[double] $endX = 1845
[double] $startY = 600
[int] $maxBar = 4
[int] $tempo = 120
[int] $times = 3
[int] $notes = $shortestNote * $maxBar
[int] $interval = 1 # msec 
[int] $blankRatio = 30 # X / 100
[string] $mode = "melody" # melody / drum / bass / chord / rhythmAndChord

$drumPattern = @{
    "bars" = 1
    "oh" = @{
        pattern = @(1, 0)
        y = 14
        isRandom = $FALSE
    }
    "ch" = @{
        pattern = @(1,1,1,1,1,1,1,1)
        y = 6
        isRandom = $FALSE
    }
    "snare" = @{
        pattern = @(0, 1, 0, 1)
        y = 2
        isRandom = $FALSE
    }
    "kick" = @{
        pattern = @(1, 1, 1, 1)
        y = 0
        isRandom = $FALSE
    }
}

[int[]] $upperLowerRatio = @(1, 1)
[int[]] $upperNoteWeightRatio = @(6, 3, 2, 1, 1, 1, 1, 1)
[int[]] $lowerNoteWeightRatio = @(6, 3, 2, 1, 1, 1, 1, 1)
[int[]] $scaleArray = @(0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17, 19, 21, 23)

function getNoteNumsY(){
    [int[]] $arr = @()
    if($mode -eq "drum"){
        foreach($note in $notes){
            $arr += 0
        }
    } else {
        $arr += & "$($PSScriptRoot)\modules\getNoteNumsY.ps1" $upperLowerRatio $upperNoteWeightRatio $lowerNoteWeightRatio $notes
    }
    return $arr
}

[int[]] $noteNumsY = getNoteNumsY

# disable mouse temporary
$Win32 = &{
$cscode = @"
[DllImport("User32.dll")]
public static extern bool BlockInput(
bool fBlockIt
);
"@
return (add-type -memberDefinition $cscode -name "Win32ApiFunctions" -passthru)
}
$Win32::BlockInput($TRUE)

# declare .NET Framework
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# declare Windows API
$signature=@'
[DllImport("user32.dll",CharSet=CharSet.Auto,CallingConvention=CallingConvention.StdCall)]
public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
$SendMouseEvent = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
$MouseMove = 0x00000001
$MouseLeftDown = 0x0002
$MouseLeftUp = 0x0004

function createClassesForDrum(){
    $xSum = $startX
    $classes = @{}
    foreach($key in $drumPattern.Keys[0]){
        # $val = $drumPattern[$key];
        $classes += @{
            "instrument" = $key
            "pattern" = $drumPattern[$key]
        }
    }
    return $classes
}

function createClasses(){
    $xSum = $startX
    $classes = @()
    for($i = 0; $i -lt $notes; $i++){
        $y = $startY - ($noteHeight * $scaleArray[$noteNumsY[$i] + 1])
        $w = [math]::Floor($barWidth / $shortestNote)
        if($i % $shortestNote -eq 0){
            # add the correction number once per 1 bar
            $correctionNum = $shortestNote % $maxBar
            $w += $correctionNum
        }
        $classes += & "$($PSScriptRoot)\classes\Note.ps1" $i $xSum $y $w
        $xSum += $w
    }
    return $classes
}

function writeNote($class){
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($class.x, $class.y)
    Start-Sleep -m $interval
    $SendMouseEvent::mouse_event($MouseLeftDown, 0, 0, 0, 0);
    $SendMouseEvent::mouse_event($MouseLeftUp, 0, 0, 0, 0);
    Start-Sleep -m $interval
}

function writeNotes(){
    for($i = 0; $i -lt $classArray.length; $i++){
        $random = Get-Random -Maximum 100 -Minimum 1
        if($random -gt $blankRatio){
            writeNote $classArray[$i]
        }
    }
}

$classArray = createClasses

# change window
# add-type -assembly microsoft.visualbasic
# [microsoft.visualbasic.interaction]::AppActivate("FL Studio")

# back to the previous window
# ALT + TAB (move to the previous window)
[System.Windows.Forms.SendKeys]::SendWait("%{TAB}")
Start-Sleep -m 3000



for ($j=0; $j -lt $times; $j++){
    # Wipe the old notes out
    [System.Windows.Forms.SendKeys]::SendWait("^{a}")
    Start-Sleep -m $interval
    [System.Windows.Forms.SendKeys]::SendWait("{DELETE}")
    Start-Sleep -m $interval

    writeNotes

    # the interval for playing once
    [System.Windows.Forms.SendKeys]::SendWait(" ")
    Start-Sleep -m ((($tempo / 60) * $maxBar * 1000) + 50) 
    [System.Windows.Forms.SendKeys]::SendWait(" ")
    Start-Sleep -m $interval
}

[System.Windows.Forms.SendKeys]::SendWait(" ")

# Write-Host "classArray:"
# Write-Host $classArray
# foreach($class in $classArray){
#     Write-Host $class.x
# }