[double] $barWidth = 441 # 80 / 128 ?
[double] $noteHeight = 18
[double] $shortestNote = 16 # 1 / 16, not pixel
[double] $startX = 90
[double] $endX = 1845
[double] $startY = 600
[int] $maxBar = 4 # not for drum
[int] $tempo = 120
[int] $times = 3
[int] $notes = $shortestNote * $maxBar
[int] $interval = 1 # msec 
[int] $blankRatio = 0 # X / 100
[int] $deleteFlag = 1
[string] $mode = "chord" # melody / drum / bass / chord / rhythmAndChord
$classArray = @()

[int] $maxBarForDrum = 1
# Instrument id name y notes blankRatio pattern[]
$drumPattern = @{
    "oh" = & "$($PSScriptRoot)\classes\Instrument.ps1" 0 "oh" 14 0 0 @(1,0)
    "ch" = & "$($PSScriptRoot)\classes\Instrument.ps1" 1 "ch" 6 16 30 @(0)
    "snare" =  & "$($PSScriptRoot)\classes\Instrument.ps1" 2 "snare" 2 4 0 @(0,1,0,1)
    "kick" =  & "$($PSScriptRoot)\classes\Instrument.ps1" 3 "kick" 0 4 0 @(1,1,1,1)
}

# rhythm=@(0) and progress=@(0) are random, brankRatio is available only when rhythm is random
# isRandomOfRandom means 
$chordPattern = @{
    "width" = 1
    "rhythm" = @(0,0,0,0,0,0,0,0)
    "progress" = @(0, 0, 0, 0)
    "scale" = "major"
    "blankRatio" = 30
    "blankRatioEachY" = 0
    "isArpeggio" = $FALSE
}

[int[]] $upperLowerRatio = @(1, 1)
[int[]] $upperNoteWeightRatio = @(6, 3, 2, 1, 1, 1, 1, 1)
[int[]] $lowerNoteWeightRatio = @(6, 3, 2, 1, 1, 1, 1, 1)
[int[]] $scaleArray = @(0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17, 19, 21, 23)

function getNoteNumsY(){
    [int[]] $arr = @()
    if($mode -eq "melody"){
        $arr += & "$($PSScriptRoot)\modules\getNoteNumsY.ps1" $upperLowerRatio $upperNoteWeightRatio $lowerNoteWeightRatio $notes
    } else {
        foreach($note in $notes){
            $arr += 0
        }
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

function getRhythmArray(){
    # $rhythm = 
    if(($chordPattern.rhythm[0] -eq 0) -and (($chordPattern.rhythm | Measure-Object -Sum).Sum -lt 1)){
        $tempArray = @()
        foreach($zero in $chordPattern.rhythm){
            $random = Get-Random -Maximum 100 -Minimum 1
            if($random -gt $chordPattern.blankRatio){
                $tempArray += 1
            } else {
                $tempArray += 0
            }
        }
        return $tempArray
    } else {
        return $chordPattern.rhythm
    }
}

function createChordClasses(){
    $xSum = $startX
    $tempClassArray = @()
    $i = 0
    $rhythm = getRhythmArray
    foreach($num in $chordPattern.progress){
        # Chord id nth name scale x width(1/x) $rhythm isArpeggio
        $tempNum = $num
        if($num -eq 0){
            $tempNum = Get-Random -Maximum 7 -Minimum 1
        }
        $chord = & "$($PSScriptRoot)\classes\Chord.ps1" 0 $tempNum "diatonic" $chordPattern.scale $xSum 1 $rhythm $chordPattern.isArpeggio
        $tempClassArray += $chord
        $chordWidthDot = [math]::Floor($barWidth / $chordPattern.width)
        # $xSum += [math]::Floor($chordWidthDot / $rhythm.Length)
        $xSum += $chordWidthDot
        # if($i % $rhythm.Length -eq 0){
        #     # add the correction number once per 1 bar
        #     $correctionNum = $rhythm.Length % $chordWidthDot
        #     $xSum += $correctionNum
        # }
        $i++
        # Write-Host "chordClass in CCC"
        # Write-Host $chord.x
    }
    return $tempClassArray
}

# For drum
function createNoteArrayForOneInstrument($obj){
    $xSum = $startX
    $tempClassArray = @()
    $pattern = $obj.pattern
    for($i = 0; $i -lt $pattern.Length; $i++){
        $y = $startY - ($noteHeight * $obj.y)
        $w = [math]::Floor($barWidth / $pattern.Length)
        if($i % $pattern.Length -eq 0){
            # add the correction number once per 1 bar
            $correctionNum = $pattern.Length % $maxBar
            $w += $correctionNum
        }
        $class = & "$($PSScriptRoot)\classes\Note.ps1" $i $xSum $y $w
        $tempClassArray += $class
        $xSum += $w
    }
    return $tempClassArray # @()
}

function createNoteClassesForChord(){
    # $xSum = $startX
    $chordClasses = createChordClasses
    $noteClasses = @()
    $i = 0
    foreach($chordClass in $chordClasses){
        foreach($y in $chordClass.ys){
            $tempY = $startY - ($y * $noteHeight)
            for($n = 0; $n -lt $chordClass.rhythm.Length; $n++){
                $tempW = ($barWidth * $chordPattern.width) / $chordClass.rhythm.Length
                $tempX = $chordClass.x + ($tempW * ($n))
                $noteClass = & "$($PSScriptRoot)\classes\Note.ps1" $i $tempX $tempY $tempW
                $random = Get-Random -Maximum 100 -Minimum 1
                if(($chordClasses.rhythm[$n] -eq 1) -and ($random -gt $chordPattern.blankRatioEachY)){
                    $noteClasses += $noteClass
                }
                $i++
                # Write-Host "tempY in CCFC"
                # Write-Host $tempY
                # Write-Host "chordClass.x in CCFC"
                # Write-Host $chordClass.x
                # Write-Host "noteClass.x in CCFC"
                # Write-Host $noteClass.x
                # Write-Host "tempX in CCFC"
                # Write-Host $tempX
                # Write-Host "tempW in CCFC"
                # Write-Host $tempW
            }
        }
        # $instrument = createNoteArrayForOneInstrument $drumPattern[$key]
        # $tempClassArray += $instrument
        # $xSum += $barWidth / $chordPattern.width
    }
    return $noteClasses
}

function createNoteClassesForDrum(){
    $xSum = $startX
    foreach($key in $drumPattern.Keys){
        $instrument = createNoteArrayForOneInstrument $drumPattern[$key]
        $tempClassArray += $instrument
    }
    return $tempClassArray
}

function createNoteClasses(){
    $xSum = $startX
    $tempClassArray = @()
    for($i = 0; $i -lt $notes; $i++){
        $y = $startY - ($noteHeight * $scaleArray[$noteNumsY[$i] + 1])
        $w = [math]::Floor($barWidth / $shortestNote)
        if($i % $shortestNote -eq 0){
            # add the correction number once per 1 bar
            $correctionNum = $shortestNote % $maxBar
            $w += $correctionNum
        }
        $class = & "$($PSScriptRoot)\classes\Note.ps1" $i $xSum $y $w
        $tempClassArray += $class
        $xSum += $w
    }
    return $tempClassArray
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

function createNoteMain(){
    if($mode -eq "chord"){
        $tempArray = createNoteClassesForChord
    } elseif($mode -eq "drum") {
        $tempArray = createNoteClassesForDrum
    } else {
        $tempArray = createNoteClasses
    }
    return $tempArray
}
$classArray = createNoteMain

# change window
# add-type -assembly microsoft.visualbasic
# [microsoft.visualbasic.interaction]::AppActivate("FL Studio")

# back to the previous window
# ALT + TAB (move to the previous window)
[System.Windows.Forms.SendKeys]::SendWait("%{TAB}")
Start-Sleep -m 3000

for ($j=0; $j -lt $times; $j++){
    # Wipe the old notes out
    if($deleteFlag -eq 1){
        [System.Windows.Forms.SendKeys]::SendWait("^{a}")
        Start-Sleep -m $interval
        [System.Windows.Forms.SendKeys]::SendWait("{DELETE}")
        Start-Sleep -m $interval
    }

    $classArray = createNoteMain
    writeNotes

    # the interval for playing once
    [System.Windows.Forms.SendKeys]::SendWait(" ")
    if($mode -eq "drum"){
        Start-Sleep -m ((($tempo / 60) * $maxBarForDrum * 1000) + 50) 
    } else {
        Start-Sleep -m ((($tempo / 60) * $maxBar * 1000) + 50) 
    }
    [System.Windows.Forms.SendKeys]::SendWait(" ")
    Start-Sleep -m $interval
}

[System.Windows.Forms.SendKeys]::SendWait(" ")

# Write-Host "classArray:"
# Write-Host $classArray
# foreach($class in $classArray){
#     Write-Host $class.x
# }