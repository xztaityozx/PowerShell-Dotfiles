function Get-PowerLinePath {
    <#
    .Synopsis
        Gets PowerLine Block for each in the path.
    .Description
        Returns: PoshCode.Pansies.Text[]
        returns an array of PowerLine blocks.
    #>

    [CmdletBinding(DefaultParameterSetName="Segments")]
    param(
        # Target path
        [Parameter(Position=0)]
        [string] $Path = $pwd,
        
        # Max Segment Size
        $SegmentLimit = 3,

        [PoshCode.Pansies.RgbColor]$ForegroundColor = "#AAAAAA",
        [PoshCode.Pansies.RgbColor]$BackgroundColor = "#424242",
        [PoshCode.Pansies.RgbColor]$LastForegroundColor = "#BA68C8",
        [PoshCode.Pansies.RgbColor]$LastBackgroundColor = "#212121"
    )

    if($SegmentLimit -le 2) {
        throw "SegmentLimit must be more than 3."
    }

    if($Path.ToLower().StartsWith($Home.ToLower())) {
        $Path = '~' + $Path.Substring($Home.Length)
    }

    $Items=$($Path.Split("\")|%{
        [PoshCode.Pansies.RgbColor]$ForegroundColor=$ForegroundColor
        [PoshCode.Pansies.RgbColor]$BackgroundColor=$BackgroundColor

        $item=" $_ "

        $out = @{Object = $item;ForegroundColor=$ForegroundColor;BackgroundColor=$BackgroundColor;}

        [PoshCode.Pansies.Text]$out
    })

    $Items[$Items.Length-1].ForegroundColor = $LastForegroundColor
    $Items[$Items.Length-1].BackgroundColor = $LastBackgroundColor

    if($SegmentLimit -lt $Items.Length) { 
        [System.Collections.Generic.List[PoshCode.Pansies.Text]]$x=@()
        $x.Add($Items[0])
        $x.Add([PoshCode.Pansies.Text]@{Object = [char]0x2026;ForegroundColor=$ForegroundColor;BackgroundColor=$BackgroundColor;})
        foreach($obj in $Items[($Items.Length-$SegmentLimit+1)..($Items.Length)]){ $x.Add($obj) }
        $x
    } else { $Items }
}
