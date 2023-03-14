# [int[]] $upperLowerRatio = @(1, 1)
# [int[]] $upperNoteWeight = @(6, 3, 2, 1, 1, 1, 1, 1)
# [int[]] $lowerNoteWeight = @(8, 3, 2, 1, 1, 1, 1, 1)
[int[]] $upperLowerRatio = $Args[0]
[int[]] $upperNoteWeightRatio = $Args[1]
[int[]] $lowerNoteWeightRatio = $Args[2]

function upperOrLower($ratio){
    $sum = $ratio[0] + $ratio[1]
    $random = Get-Random -Maximum $sum -Minimum 0
    # if($random -eq 0) {
    #     $random = 1
    # }
    write-host "UPPERORLOWER-RANDOM: "
    write-host $random
    if($ratio[0] -gt $random){
        write-host "UPPER: "
        return $upperNoteWeightRatio
    } else {
        write-host "LOWER: "
        return $lowerNoteWeightRatio
    }
}

function calcSum($arr){
    [int] $sum = 0
    foreach($num in $arr){
        $sum += $num
    }
    return $sum
}

function getSumInArray($arr, $nth){
    $sum = 0;
    for($j = 0; $j -lt $nth; $j++){
        $sum += $arr[$j]
    }
    return $sum
}

function getTempArr($arr){
    $tempArr = @()
    for($i = 1; $i -le $arr.length; $i++){
        $num = getSumInArray $arr $i
        $tempArr += $num
    }
    return $tempArr
}

function getNextNotesNum($arr, $tempArr){
    $sum = calcSum $arr
    $random = Get-Random -Maximum $sum -Minimum 0
    # if($random -eq 0) {
    #     $random = 1
    # }
    for($k = 0; $k -lt $tempArr.length; $k++){
        if($random -le $tempArr[$k]){
            return $k
        }
        # return $tempArr.length
    }
}

function selectNextNote($arr){
    $weightArray = upperOrLower $upperLowerRatio
    $tempArr = getTempArr $arr
    write-host "TEMP-ARR: "
    write-host $tempArr
    $nth = getNextNotesNum $weightArray $tempArr
    write-host "NEXT-NOTE: "
    write-host $nth
    write-host "weightArray: "
    write-host $weightArray
    return $nth
}

[int] $nextNotesNum = selectNextNote $upperNoteWeightRatio
return $nextNotesNum

# $sumnum

# if(toUpper){
#     $sumNum = calcSum $upperNoteWeightRatio
# } else {
#     $sumNum = calcSum $lowerNoteWeightRatio
# }
# write-host $sumNum
