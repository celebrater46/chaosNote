# Chord id nth name scale x width(1/x) rhythm isArpeggio
$chord = & "$($PSScriptRoot)\classes\Chord.ps1" 0 4 "diatonic" "major" 90 1 @(1,1,1,1) $FALSE
Write-Host $chord.ys
Write-Host $chord.x
Write-Host $chord.name
Write-Host $chord.width
Write-Host $chord.rhythm