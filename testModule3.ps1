# $obj = & "$($PSScriptRoot)\classes\CevioNote.ps1" 333 666 99 '‚ð'
# Write-Host $obj.x
# Write-Host $obj.y
# Write-Host $obj.width
# Write-Host $obj.char

[int] $barWidth = 768 # 80 / 128 ?
[int] $noteHeight = 24

$startX = 100
$endX = 1752
$startY = 1016
$noteLengthArray = @(4, 8, 8, 2)
$noteHeightArray = @(8, 9, 10, 11)
$notes = 4

function createClasses(){
    $xSum = $startX
    $classes = @()
    for($i = 0; $i -lt $notes; $i++){
        $y = $startY - ($noteHeight * $noteHeightArray[$i])
        $w = $barWidth / $noteLengthArray[$i]
        $classes += & "$($PSScriptRoot)\classes\CevioNote.ps1" $i $xSum $y $w '‚ç'
        $xSum += $w
    }
    return $classes
}

$classArray = createClasses
Write-Host "classArray:"
Write-Host $classArray