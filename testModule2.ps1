[int[]] $noteTypes = @(2, 4, 8, 16)
[int[]] $noteTypeWeightRatio = @(2, 4, 6, 2)

[int[]] $noteLengthArray = & "$($PSScriptRoot)\modules\getNoteLengthOrderArray.ps1" $noteTypes $noteTypeWeightRatio 7
Write-Host "noteLengthArray"
Write-Host $noteLengthArray