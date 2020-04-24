
Start-Process  -FilePath "c:\program files\internet explorer\iexplore.exe"  -ArgumentList "https://vidyoportal.med.utah.edu/flex.html?roomdirect.html&key=YF7jIo3SkyTQEnt9RIt6dv17ugU"


#Start-Process  "https://vidyoportal.med.utah.edu/flex.html?roomdirect.html&key=YF7jIo3SkyTQEnt9RIt6dv17ugU"

# Maximize VidyoConnect Window 
# The 15 second timer is to allow VidyoConnect to launch before the script tries to maximize the window

Start-Sleep -Seconds 5

$wshell = New-Object -ComObject wscript.shell;
$wshell.AppActivate('Internet Explorer')
Sleep 1
$wshell.SendKeys('{TAB}')
$wshell.SendKeys('{TAB}')
Sleep 1
$wshell.SendKeys('~')


$proc = Get-Process | ? { $_.MainWindowTitle -eq 'VidyoConnect' }



Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class myWindow {
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    }

"@

Function Maximize-Window()
{
	Param (
		[System.Diagnostics.Process]$Process
	)
	$ShowMaximized = 3
	[void][myWindow]::ShowWindow($Process.MainWindowHandle, $ShowMaximized)
}

Maximize-Window -Process $proc

# Close Helper Browser

Start-Sleep -s 5


stop-Process -processname "iexplore"

python record_computer_screen_v2.py


#Vidyo Close Script
# Just closing down VidyoConnect

#Stop-Process -processname vidyoconnect
