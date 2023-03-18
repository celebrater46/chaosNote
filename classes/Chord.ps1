# Chord id name x
[int] $id = $args[0]
[string] $name = $args[1]
[int] $x = $args[2]
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
$majorDiatonicChord = @("major", "minor", "minor", "major", "major", "minor", "minor7-5")
$minorDiatonicChord = @("minor", "minor7-5", "major", "minor", "minor", "major", "major")

class Chord{
    [int] $id = 0
    [string] $name = ""
    [int] $x = 0
    $notes = @()

    Chord($id, $name, $x){
        $this.id = $id
        $this.name = $name
        $this.x = $x
        $ys = 
    }
}

$cn = [Chord]::new($id, $name, $x)
return $cn
