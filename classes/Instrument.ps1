[int] $id = $args[0]
[string] $name = $args[1]
[int[]] $rhythm = $args[2]
[int] $y = $args[3]

class Instrument{
    [int] $id = 0
    [string] $name = ""
    [int[]] $rhythm = @()
    [int] $y = 0

    Instrument($id, $name, $rhythm, $y){
        $this.id = $id
        $this.name = $name
        $this.rhythm = $rhythm
        $this.y = $y
    }
}

$obj = [Instrument]::new($id, $x, $y, $width)
return $obj
