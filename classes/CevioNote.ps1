[int] $id = $args[0]
[int] $x = $args[1]
[int] $y = $args[2]
[int] $width = $args[3]
[string] $char = $args[4]

class CevioNote{
    [int] $id = 0
    [int] $x = 960
    [int] $y = 540
    [int] $width = 96
    [string] $char = '‚ '

    CevioNote($id, $x, $y, $width, $char){
        $this.id = $id
        $this.x = $x
        $this.y = $y
        $this.width = $width
        $this.char = $char
    }
}

$cn = [CevioNote]::new($id, $x, $y, $width, $char)
return $cn
