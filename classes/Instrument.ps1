# Instrument id name y notes blankRatio pattern[]
[int] $id = $args[0]
[string] $name = $args[1]
[int] $y = $args[2]
[int] $notes = $args[3]
[bool] $blankRatio = $args[4]
[int[]] $pattern = $args[5]

class Instrument{
    [int] $id = 0
    [string] $name = ""
    [int] $y = 0
    [int] $notes = 16
    [bool] $blankRatio = 0
    [int[]] $pattern = @()

    Instrument($id, $name, $y, $notes, $blankRatio, $pattern){
        $this.id = $id
        $this.name = $name
        $this.y = $y
        $this.notes = $notes
        $this.blankRatio = $blankRatio
        if($notes -gt 2){
            for($i = 0; $i -lt $notes; $i++){
                $random = Get-Random -Maximum 100 -Minimum 1
                if($random -gt $blankRatio){
                    $this.pattern += 1
                } else {
                    $this.pattern += 0
                }
            }
        } else {
            $this.pattern = $pattern
        }
    }
}

# $drumPattern = @{
#     "oh" = @{
#         "pattern" = @(1, 0)
#         "y" = 14
#         "isRandom" = $FALSE
#     }
#     "ch" = @{
#         "pattern" = @(1,1,1,1,1,1,1,1)
#         "y" = 6
#         "isRandom" = $FALSE
#     }
#     "snare" = @{
#         "pattern" = @(1,1,1,1,1,1,1,1)
#         "y" = 2
#         "isRandom" = $FALSE
#     }
#     "kick" = @{
#         "pattern" = @(1,1,1,1,1,1,1,1)
#         "y" = 0
#         "isRandom" = $FALSE
#     }
# }

$obj = [Instrument]::new($id, $name, $y, $notes, $blankRatio, $pattern)
return $obj
