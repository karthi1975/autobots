
Start-Process  -FilePath "c:\program files\internet explorer\iexplore.exe"  -ArgumentList "https://utah-health.zoom.us/j/185343237"


Start-Sleep -Seconds 5







function Set-WindowState {
    <#
    .LINK
    https://gist.github.com/Nora-Ballard/11240204
    #>

    [CmdletBinding(DefaultParameterSetName = 'InputObject')]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [Object[]] $InputObject,

        [Parameter(Position = 1)]
        [ValidateSet('FORCEMINIMIZE', 'HIDE', 'MAXIMIZE', 'MINIMIZE', 'RESTORE',
                     'SHOW', 'SHOWDEFAULT', 'SHOWMAXIMIZED', 'SHOWMINIMIZED',
                     'SHOWMINNOACTIVE', 'SHOWNA', 'SHOWNOACTIVATE', 'SHOWNORMAL')]
        [string] $State = 'SHOW'
    )

    Begin {
        $WindowStates = @{
            'FORCEMINIMIZE'     = 11
            'HIDE'              = 0
            'MAXIMIZE'          = 3
            'MINIMIZE'          = 6
            'RESTORE'           = 9
            'SHOW'              = 5
            'SHOWDEFAULT'       = 10
            'SHOWMAXIMIZED'     = 3
            'SHOWMINIMIZED'     = 2
            'SHOWMINNOACTIVE'   = 7
            'SHOWNA'            = 8
            'SHOWNOACTIVATE'    = 4
            'SHOWNORMAL'        = 1
        }

        $Win32ShowWindowAsync = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
'@ -Name "Win32ShowWindowAsync" -Namespace Win32Functions -PassThru

        if (!$global:MainWindowHandles) {
            $global:MainWindowHandles = @{ }
        }
    }

    Process {
        foreach ($process in $InputObject) {
            if ($process.MainWindowHandle -eq 0) {
                if ($global:MainWindowHandles.ContainsKey($process.Id)) {
                    $handle = $global:MainWindowHandles[$process.Id]
                } else {
                    Write-Error "Main Window handle is '0'"
                    continue
                }
            } else {
                $handle = $process.MainWindowHandle
                $global:MainWindowHandles[$process.Id] = $handle
            }

            $Win32ShowWindowAsync::ShowWindowAsync($handle, $WindowStates[$State]) | Out-Null
            Write-Verbose ("Set Window State '{1} on '{0}'" -f $MainWindowHandle, $State)
        }
    }
}





Start-Sleep -s 25

[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}") 
Start-Sleep -s 5
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[System.Windows.Forms.SendKeys]::SendWait("%{v}") 


Start-Sleep -s 5

$zoomWindow = Get-Process | ? { $_.MainWindowTitle -eq 'Zoom' } # Get Zoom window handle.
Set-WindowState  $zoomWindow MAXIMIZE # Maximize it.


# Close Helper Browser

Start-Sleep -s 15

stop-Process -processname "iexplore"
stop-Process $zoomWindow 
Stop-process -Name Zoom


#Start-Sleep -s 15
#Stop-process -Name Zoom

#Vidyo Close Script
# Just closing down VidyoConnect

#Stop-Process -processname vidyoconnect
