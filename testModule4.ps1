# $obj = & "$($PSScriptRoot)\classes\CevioNote.ps1" 333 666 99 '��'
# Write-Host $obj.x
# Write-Host $obj.y
# Write-Host $obj.width
# Write-Host $obj.char
[double] $barWidth = 441 # 80 / 128 ?
[double] $noteHeight = 18
[double] $shortestNote = 16 # 1 / 16, not pixel
[double] $startX = 97
[double] $endX = 1845
[double] $startY = 600
[int] $maxBar = 4
[int] $notes = $shortestNote * $maxBar
[int] $interval = 3 # msec 
[int] $blankRatio = 0 # X / 100
[string] $mode = "melody" # melody / drum / bass / chord / rhythmAndChord

# -1 = random, (pattern, Y)
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

# [int[]] $noteTypes = @(2, 4, 8, 16)
# [int[]] $noteTypeWeightRatio = @(2, 4, 6, 2)
# [int[]] $noteLengthArray = & "$($PSScriptRoot)\modules\getNoteLengthOrderArray.ps1" $noteTypes $noteTypeWeightRatio $notes

[int[]] $upperLowerRatio = @(1, 1)
[int[]] $upperNoteWeightRatio = @(6, 3, 2, 1, 1, 1, 1, 1)
[int[]] $lowerNoteWeightRatio = @(6, 3, 2, 1, 1, 1, 1, 1)
[int[]] $scaleArray = @(0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17, 19, 21, 23)
# [int[]] $noteNumsY = & "$($PSScriptRoot)\modules\getNoteNumsY.ps1" $upperLowerRatio $upperNoteWeightRatio $lowerNoteWeightRatio $notes

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

function createClasses(){
    $xSum = $startX
    $classes = @()
    if($mode -eq "drum"){
        # foreach($key in $drumPattern.Keys[0]){
        #     $val = $drumPattern[$key];
        # }
    } else {
        for($i = 0; $i -lt $notes; $i++){
            $y = $startY - ($noteHeight * $scaleArray[$noteNumsY[$i] + 1])
            # $w = $barWidth / $noteLengthArray[$i]
            $w = [math]::Floor($barWidth / $shortestNote)
            if($i % $shortestNote -eq 0){
                # add the correction number once per 1 bar
                $correctionNum = $shortestNote % $maxBar
                $w += $correctionNum
            }
            $classes += & "$($PSScriptRoot)\classes\Note.ps1" $i $xSum $y $w
            $xSum += $w
        }
    }
    return $classes
}

function writeNote($class){
    # [int] $distance = 35 # 95-96/43 (SynthV.note.length)
    # [int] $distance = $class.width * 3 / 8
    # if($class.id -eq 0){
    #     $distance *= 1.3
    # }
    # [double] $note = $barWidth / $shortestNote;
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($class.x, $class.y)
    Start-Sleep -m $interval
    $SendMouseEvent::mouse_event($MouseLeftDown, 0, 0, 0, 0);
    Start-Sleep -m 1
    $SendMouseEvent::mouse_event($MouseLeftUp, 0, 0, 0, 0);
    Start-Sleep -m $interval
}

$classArray = createClasses

# change window
# add-type -assembly microsoft.visualbasic
# [microsoft.visualbasic.interaction]::AppActivate("FL Studio")

# back to the previous window
# ALT + TAB (move to the previous window)
[System.Windows.Forms.SendKeys]::SendWait("%{TAB}")
Start-Sleep -m 3000

for($i = 0; $i -lt $classArray.length; $i++){
    $random = Get-Random -Maximum 100 -Minimum 1
    if($random -gt $blankRatio){
        writeNote $classArray[$i]
    }
    # writeNote $classArray[$i]
}

[System.Windows.Forms.SendKeys]::SendWait(" ")

Write-Host "classArray:"
# Write-Host $classArray
foreach($class in $classArray){
    Write-Host $class.x
}