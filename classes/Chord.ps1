# Chord id nth name scale x width(1/x) notes isArpeggio
[int] $id = $args[0]
[int] $nth = $args[1] # I=1,II=2,III=3,IV=4... 
[string] $name = $args[2]
[string] $scale = $args[3]
[int] $x = $args[4]
[int] $width = $args[5]
[int] $notes = $args[6]
[bool] $isArpeggio = $FALSE
# [int] $noteHeight = $args[5]
$chords = @{
    "major" = @(0, 4, 7)
    "minor" = @(0, 3, 7)
    "7" = @(0, 4, 7, 10)
    "7+5" = @(0, 4, 8, 10)
    "7-5" = @(0, 4, 6, 10)
    "major7" = @(0, 4, 7, 11)
    "minor7" = @(0, 3, 7, 10)
    "minorMajor7" = @(0, 3, 7, 11)
    "minor7-5" = @(0, 3, 6, 10)
    "sus4" = @(0, 5, 7)
    "7sus4" = @(0, 5, 7, 10)
    "aug" = @(0, 4, 8)
    "dim7" = @(0, 3, 6, 9)
    "6" = @(0, 4, 7, 9)
    "minor6" = @(0, 3, 7, 9)
    "9" = @(0, 4, 7, 10, 14)
    "major9" = @(0, 4, 7, 11, 14)
    "minor9" = @(0, 3, 7, 10, 14)
    "9sus4" = @(0, 5, 7, 10, 14)
    "add9" = @(0, 4, 7, 14)
    "11" = @(0, 4, 7, 10, 14, 17)
    "13" = @(0, 4, 7, 10, 14, 17, 21)
    "-5" = @(0, 4, 6)
    "-9" = @(0, 4, 7, 13)
    "+9" = @(0, 4, 7, 15)
    "69" = @(0, 4, 7, 9, 14)
    "minor69" = @(0, 3, 7, 9, 14)
    "7-9" = @(0, 4, 7, 10, 14)
    "-9_13" = @(0, 4, 7, 13, 21)
}
$diatonicChords = @{
    "major" = @("major", "minor", "minor", "major", "major", "minor", "minor7-5")
    "minor" = @("minor", "minor7-5", "major", "minor", "minor", "major", "major")
}
$scales = @{
    "major" = @(0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17, 19, 21, 23)
    "minor" = @(0, 2, 3, 5, 7, 8, 10, 12, 14, 15, 17, 19, 20, 22)
}

# [string[]] $majorDiatonicChord = @("major", "minor", "minor", "major", "major", "minor", "minor7-5")
# [string[]] $minorDiatonicChord = @("minor", "minor7-5", "major", "minor", "minor", "major", "major")
# [int[]] $majorScale = @(0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17, 19, 21, 23)
# [int[]] $minorScale = @(0, 2, 3, 5, 7, 8, 10, 12, 14, 15, 17, 19, 20, 22)

class Chord{
    [int] $id = 0
    [int] $nth = 0
    [string] $name = ""
    [int[]] $scale = @()
    [int] $x = 0
    [int] $width = 0
    [int] $notes = 0
    [bool] $isArpeggio = $FALSE
    [int[]] $ys = @()

        Chord($id, $nth, $name, $scale, $x, $width, $notes, $isArpeggio, $chords, $scales){
        $this.id = $id
        $this.nth = $nth
        $this.name = $name
        $this.scale = $scales[$scale]        
        # $this.scale = @(0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17, 19, 21, 23)        
        $this.x = $x
        $this.width = $width
        $this.notes = $notes
        $this.isArpeggio = $isArpeggio
        $tempArray = $chords[$this.name]
        for($i = 0; $i -lt $tempArray.Length; $i++){
            # $y = 0
            # $y = $tempArray[$i]
            $y = $tempArray[$i] + $this.scale[$nth-1]
            # $y = $this.scale[$nth-1]
            $this.ys += $y
            Write-Host "tempArray[i], this.scale[nth]"
            # Write-Host $tempArray[$i]
            Write-Host $this.scale[$nth-1]
            # Write-Host "tempArray, this.scale"
            # Write-Host $tempArray
            # Write-Host $this.scale
            # Write-Host "y"
            # Write-Host $y
            # Write-Host "nth"
            # Write-Host $nth
            # $this.notes +=  & "$($PSScriptRoot)\Note.ps1" $i $this.x $y $w
        }
    }
}

$c = [Chord]::new($id, $nth, $name, $scale, $x, $width, $notes, $isArpeggio, $chords, $scales)
return $c
