
# PowerLine 設定
Import-Module PowerLine
Import-Module $HOME\App\powershell-script\Get-PowerLinedPath.ps1

Set-PowerLinePrompt -Colors "#424242" -PowerLineFont -RestoreVirtualTerminal
[System.Collections.Generic.List[ScriptBlock]]$Prompt = @(
    { New-PromptText { " " + $MyInvocation.HistoryId + " " } -Fg "#D84315" -Bg "#212121" }
    { New-PromptText { if($pushd=(Get-Location -Stack).Count) {" &raquo;$pushd "} } -BackgroundColor "#311B92" }
    { Get-PowerLinePath } 
    { "`n" }
    { New-PromptText {" xztaityozx "}  -Bg "#4527A0" -EBg Red -Fg White } 
    { New-PromptText { " % " } -Bg "#212121" -Fg White }
    { " " }
)

# キーバインドをemacsに
Import-Module PSReadLine
Set-PSReadLineOption -EditMode Emacs -BellStyle None
Set-PSReadLineKeyHandler -Chord Ctrl+D -ScriptBlock { [System.Environment]::Exit(0) }

# sudo
function Pause {
    if ($psISE) {
        $null = Read-Host 'Press Enter Key...'
    }
    else {
        Write-Host "Press Any Key..."
        (Get-Host).UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    }
}

function Invoke-CommandRunAs {
    $cd=(Get-Location).Path
    $commands="Set-Location $cd; Write-Host `"[Administrator] $cd> $args`"; $args; Pause; exit"
    $bytes=[System.Text.Encoding]::Unicode.GetBytes($commands)
    $encodedCommand=[System.Convert]::ToBase64String($bytes)
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoExit","-encodedCommand",$encodedCommand
}

Set-Alias sudo Invoke-CommandRunAs

function Start-RunAs {
    $cd=(Get-Location).Path
    $commands="Set-Location $cd; (Get-Host).UI.RawUI.WindowTitle+=`" [Administrator] `""
    $bytes=[System.Text.Encoding]::Unicode.GetBytes($commands)
    $encodedCommand=[System.Convert]::ToBase64String($bytes)
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoExit","-encodedCommand",$encodedCommand
}

Set-Alias su Start-RunAs
