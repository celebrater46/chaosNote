function upperOrLower($ratio){
    $sum = $ratio[0] + $ratio[1]
    $random = Get-Random -Maximum $sum -Minimum 0
    if($ratio[0] -gt $random){
        write-host "UPPER: "
        return $TRUE
    } else {
        write-host "LOWER: "
        return $FALSE
    }
}

[bool] $isUp = upperOrLower $args[0]
return $isUp