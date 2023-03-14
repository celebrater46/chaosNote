# $obj = & "$($PSScriptRoot)\classes\CevioNote.ps1" 333 666 99 '‚ð'
# Write-Host $obj.x
# Write-Host $obj.y
# Write-Host $obj.width
# Write-Host $obj.char

[int] $barWidth = 768 # 80 / 128 ?
[int] $noteHeight = 24
[int] $startX = 100
[int] $endX = 1752
[int] $startY = 1008
[int] $notes = 6
[int] $interval = 50 # msec 

[int[]] $noteTypes = @(2, 4, 8, 16)
[int[]] $noteTypeWeightRatio = @(2, 4, 6, 2)
[int[]] $noteLengthArray = & "$($PSScriptRoot)\modules\getNoteLengthOrderArray.ps1" $noteTypes $noteTypeWeightRatio $notes

[int[]] $upperLowerRatio = @(1, 1)
[int[]] $upperNoteWeightRatio = @(6, 3, 2, 1, 1, 1, 1, 1)
[int[]] $lowerNoteWeightRatio = @(6, 3, 2, 1, 1, 1, 1, 1)
# [int[]] $scaleArray = @(0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17, 19, 21, 23)
[int[]] $scaleArray = @(0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17, 19, 21, 23)
[int[]] $noteNumsY = & "$($PSScriptRoot)\modules\getNoteNumsY.ps1" $upperLowerRatio $upperNoteWeightRatio $lowerNoteWeightRatio $notes

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
    for($i = 0; $i -lt $notes; $i++){
        $y = $startY - ($noteHeight * $scaleArray[$noteNumsY[$i] + 1])
        $w = $barWidth / $noteLengthArray[$i]
        $classes += & "$($PSScriptRoot)\classes\CevioNote.ps1" $i $xSum $y $w '‚ç'
        $xSum += $w
    }
    return $classes
}

function writeNote($class){
    # [int] $distance = 35 # 95-96/43 (SynthV.note.length)
    [int] $distance = $class.width * 3 / 8
    if($class.id -eq 0){
        $distance *= 1.3
    }
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($class.x, $class.y)
    Start-Sleep -m $interval
    $SendMouseEvent::mouse_event($MouseLeftDown, 0, 0, 0, 0);
    Start-Sleep -m $interval
    $SendMouseEvent::mouse_event($MouseMove, $distance, 0, 0, 0)
    Start-Sleep -m $interval
    $SendMouseEvent::mouse_event($MouseLeftUp, 0, 0, 0, 0);
    Start-Sleep -m $interval
    $SendMouseEvent::mouse_event($MouseMove, -15, 0, 0, 0)
    Start-Sleep -m $interval
    $SendMouseEvent::mouse_event($MouseLeftDown, 0, 0, 0, 0);
    $SendMouseEvent::mouse_event($MouseLeftUp, 0, 0, 0, 0);
    $SendMouseEvent::mouse_event($MouseLeftDown, 0, 0, 0, 0);
    $SendMouseEvent::mouse_event($MouseLeftUp, 0, 0, 0, 0);
    [System.Windows.Forms.SendKeys]::SendWait($class.char)
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
    Start-Sleep -m $interval
}

$classArray = createClasses

# change window
add-type -assembly microsoft.visualbasic
[microsoft.visualbasic.interaction]::AppActivate("CeVIO AI")
Start-Sleep -m 3000

for($i = 0; $i -lt $classArray.length; $i++){
    writeNote $classArray[$i]
}

[System.Windows.Forms.SendKeys]::SendWait(" ")

Write-Host "classArray:"
Write-Host $classArray