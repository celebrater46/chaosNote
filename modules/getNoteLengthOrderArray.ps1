# [int[]] $noteTypes = @(2, 4, 8, 16)
# [int[]] $noteTypesWeightRatio = @(2, 4, 6, 2)
[int[]] $noteLengthArray = @(2, 4, 8, 16)
[int[]] $noteLengthWeightRatio = @(2, 4, 6, 2)
[int] $notes = 7
# [int[]] $noteLengthArr = $args[0]
# [int[]] $noteLengthWeightRatio = $args[1]
# [int] $notes = $args[2] # 7

# function getSum(){
#     [int] $sum = 0
#     foreach($num in $noteLengthWeightRatio){
#         $sum += $num
#     }
#     return $sum
# }

# function getNextLength($sum){
#     $random = Get-Random -Maximum $sum -Minimum 0

# }

function getNoteLengthOrderArray(){
    [int[]] $arr = @()
    for($i = 0; $i -lt $notes; $i++){
        $nextNth = & "$($PSScriptRoot)\getNextNoteNum.ps1" $noteLengthWeightRatio
        $arr += $noteLengthArray[$nextNth]
    }
    return $arr
}

[int[]] $noteLengthOrderArray = getNoteLengthOrderArray
return $noteLengthOrderArray
