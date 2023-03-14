[int] $id = $args[0]
[int] $x = $args[1]
[int] $y = $args[2]
[int] $width = $args[3]

class Note{
    [int] $id = 0
    [int] $x = 960
    [int] $y = 540
    [int] $width = 96

    Note($id, $x, $y, $width){
        $this.id = $id
        $this.x = $x
        $this.y = $y
        $this.width = $width
    }
}

$cn = [Note]::new($id, $x, $y, $width)
return $cn
