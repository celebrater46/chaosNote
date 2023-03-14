class CevioNote{
    [int] $x = 960
    [int] $y = 540
    [int] $width = 96
    [string] $char = '‚ '

    init($x, $y, $w, $ch){
        $this.startX = $x
        $this.startY = $y
        $this.width = $w
        $this.char = $ch
        Write-Host $this.startX, $this.startY, $this.width, $this.char
    }
}