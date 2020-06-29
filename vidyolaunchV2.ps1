
Start-Process  -FilePath "c:\program files\internet explorer\iexplore.exe"  -ArgumentList "https://vidyoportal.med.utah.edu/flex.html?roomdirect.html&key=YF7jIo3SkyTQEnt9RIt6dv17ugU"


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





Start-Sleep -s 5



$wshell = New-Object -ComObject wscript.shell;
$wshell.AppActivate('Internet Explorer')
Sleep 1
$wshell.SendKeys('{TAB}')
$wshell.SendKeys('{TAB}')
Sleep 1
$wshell.SendKeys('~')



Start-Sleep -s 20

$vidyoConnectWindow = Get-Process | ? { $_.MainWindowTitle -eq 'VidyoConnect' } # Get VidyoConnect window handle.
Set-WindowState  $vidyoConnectWindow MAXIMIZE # Maximize it.

python record_computer_screen_v2.py


# Close Helper Browser

Start-Sleep -s 60

stop-Process -processname "iexplore"
stop-Process $vidyoConnectWindow 
#Stop-process -Name VidyoConnect

python motion_detectorV2.py --video output5.avi






