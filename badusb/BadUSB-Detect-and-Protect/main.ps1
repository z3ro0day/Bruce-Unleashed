<# ================ BAD USB DETECTION AND PROTECTION ===================

SYNOPSIS
This script runs passively in the background waiting for any new usb devices.
When a new USB device is connected to the machine this script monitors keypresses for 60 seconds.
If there are 13 or more keypresses detected within 200 milliseconds it will pause all inputs for 20 seconds.

USAGE
1. Edit Options below (optional) and Run the script
2. A pop up will appear when monitoring is active and if a 'BadUSB' device is detected
3. logs are found in 'usblogs' folder in the temp directory.
5. Close the monitor in the system tray

REQUIREMENTS
Admin privlages are required for pausing keyboard and mouse inputs

https://is.gd/badusbprotect
#>

# Hide the console after monitor starts
$hidden = 'y'

$Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host
[Console]::SetWindowSize(50, 20)
[Console]::Title = "BadUSB Detection Setup"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

Write-Host "Checking User Permissions.." -ForegroundColor DarkGray
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Write-Host "Admin privileges needed for this script..." -ForegroundColor Red
    Write-Host "This script will self elevate to run as an Administrator and continue." -ForegroundColor DarkGray
    Start-Process PowerShell.exe -ArgumentList ("-NoP -Ep Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    exit
}
else{
    sleep 1
    Write-Host "This script is running as Admin!"  -ForegroundColor Green
    New-Item -ItemType Directory -Path "$env:TEMP\usblogs\"
    cls
}

Function HideConsole{
    If ($hidden -eq 'y'){
        Write-Host "Minimizing the Window.."  -ForegroundColor Red
        sleep 1
        $Async = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
        $Type = Add-Type -MemberDefinition $Async -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
        $hwnd = (Get-Process -PID $pid).MainWindowHandle
        if($hwnd -ne [System.IntPtr]::Zero){
            $Type::ShowWindowAsync($hwnd, 0)
        }
        else{
            $Host.UI.RawUI.WindowTitle = 'hideme'
            $Proc = (Get-Process | Where-Object { $_.MainWindowTitle -eq 'hideme' })
            $hwnd = $Proc.MainWindowHandle
            $Type::ShowWindowAsync($hwnd, 0)
        }
    }
}

$DeviceMonitor = {

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    
    $usbDevices = Get-WmiObject -Query "SELECT * FROM Win32_PnPEntity WHERE PNPDeviceID LIKE 'USB%'"
    $currentUSBDevices = @()
    $newUSBDevices = @()
    foreach ($device in $usbDevices) {
        $deviceID = $device.DeviceID
        $newUSBDevices += $deviceID
    }
    $currentUSBDevices = $newUSBDevices
    
    $monitor = {
    
        Add-Type -AssemblyName System.Drawing
        Add-Type -AssemblyName System.Windows.Forms
    
$API = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
public static extern short GetAsyncKeyState(int virtualKeyCode); 
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int GetKeyboardState(byte[] keystate);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int MapVirtualKey(uint uCode, int uMapType);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);
'@
        $API = Add-Type -MemberDefinition $API -Name 'Win32' -Namespace API -PassThru
    
        $balloon = {
            Add-Type -AssemblyName System.Drawing
            Add-Type -AssemblyName System.Windows.Forms
            $notify = New-Object System.Windows.Forms.NotifyIcon
            $notify.Icon = [System.Drawing.SystemIcons]::Warning
            $notify.Visible = $true
            $balloonTipTitle = "WARNING"
            $balloonTipText = "Bad USB Device Intercepted!"
            $notify.ShowBalloonTip(30000, $balloonTipTitle, $balloonTipText, [System.Windows.Forms.ToolTipIcon]::WARNING)
        }
        
        $pausejob = {
            $s='[DllImport("user32.dll")][return: MarshalAs(UnmanagedType.Bool)]public static extern bool BlockInput(bool fBlockIt);'
            Add-Type -MemberDefinition $s -Name U -Namespace W
            [W.U]::BlockInput($true)
            sleep 20
            [W.U]::BlockInput($false)
        }
        
        function MonitorKeys {
            $startTime = $null
            $keypressCount = 0
            $initTime = Get-Date
            while ($MonitorTime -lt $initTime.AddSeconds(60)) {
                "Monitor Active for 60 seconds." | Out-File -FilePath "$env:TEMP\usblogs\log.log" -Append 
                $stopjob = Get-Content "$env:TEMP\usblogs\monon.log"
                if ($stopjob -eq 'true'){"Restarting Monitor (New Device Detected)" | Out-File -FilePath "$env:TEMP\usblogs\log.log" -Append ;exit}
                $MonitorTime = Get-Date
                Start-Sleep -Milliseconds 10
                for ($i = 8; $i -lt 256; $i++) {
                    $keyState = $API::GetAsyncKeyState($i)
                    if ($keyState -eq -32767) {
                        if (-not $startTime) {
                            $startTime = Get-Date
                        }
                        $keypressCount++
                    }
                }   
                if ($startTime -and (New-TimeSpan -Start $startTime).TotalMilliseconds -ge 200) {
                    if ($keypressCount -gt 12) {
                        $script:newUSBDeviceIDs = Get-Content "$env:TEMP\usblogs\ids.log"
                        Start-Job -ScriptBlock $pausejob -Name PauseInput
                        Start-Job -ScriptBlock $balloon -Name BallonIcon
                    }
                    $startTime = $null
                    $keypressCount = 0     
                }
            }
            "Monitor set to idle." | Out-File -FilePath "$env:TEMP\usblogs\log.log" -Append 
        }
    MonitorKeys
    }
    
    function CheckNew {
        $usbDevices = Get-WmiObject -Query "SELECT * FROM Win32_PnPEntity WHERE PNPDeviceID LIKE 'USB%'"
        $newUSBDevices = @()
        $newUSBDeviceIDs = @()
        foreach ($device in $usbDevices) {
            $deviceID = $device.DeviceID
            $newUSBDevices += $deviceID
            if ($currentUSBDevices -notcontains $deviceID) {
                Write-Host "New USB device added: $($device.Name) ID: $($deviceID)"
                $script:match = $true
                $newUSBDeviceIDs += $deviceID -split "," | Out-File -FilePath "$env:TEMP\usblogs\ids.log" -Append
            }
        }
        $global:currentUSBDevices = $newUSBDevices
        $global:newUSBDeviceIDs = $newUSBDeviceIDs
    }
    
    $notify = New-Object System.Windows.Forms.NotifyIcon
    $notify.Icon = [System.Drawing.SystemIcons]::Shield
    $notify.Visible = $true
    $balloonTipTitle = "USB Monitoring"
    $balloonTipText = "BadUSB Monitoring Active.."
    $notify.ShowBalloonTip(3000, $balloonTipTitle, $balloonTipText, [System.Windows.Forms.ToolTipIcon]::Info)
    
    while ($true) {
        $notify.Visible = $false
        CheckNew
        $global:CurrentStatus = 'Waiting For Devices'
        if ($match){
            Write-Host "Monitoring Keys"
            $global:CurrentStatus = 'Monitoring Inputs..'
            $jobon = Get-Job -Name Monitor
            if ($jobon){
                "true" | Out-File -FilePath "$env:TEMP\usblogs\monon.log"
                sleep -Milliseconds 500
            }
            $script:match = $false
            "false" | Out-File -FilePath "$env:TEMP\usblogs\monon.log"
            Start-Job -ScriptBlock $monitor -Name Monitor
        } 
        sleep -Milliseconds 500 
    }

}

cls
Write-Host "
===================================================
**YOU CAN CLOSE THE MONITOR FROM THE SYSTEM TRAY**
===================================================" -ForegroundColor Blue 
sleep 2 
HideConsole
Start-Job -ScriptBlock $DeviceMonitor -Name DeviceMonitor

$Systray_Tool_Icon = New-Object System.Windows.Forms.NotifyIcon
$Systray_Tool_Icon.Text = "BadUSB Monitor"
$Systray_Tool_Icon.Icon = [System.Drawing.SystemIcons]::Shield
$Systray_Tool_Icon.Visible = $true

$contextmenu = New-Object System.Windows.Forms.ContextMenuStrip
$traytitle = $contextmenu.Items.Add("BadUSB Detection");

$Menu_Exit = $contextmenu.Items.Add("Close Monitor");
$Menu_Exit_Picture =[System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\DFDWiz.exe")
$Menu_Exit.Image = $Menu_Exit_Picture

$Systray_Tool_Icon.ContextMenuStrip = $contextmenu
$appContext = New-Object System.Windows.Forms.ApplicationContext

$traytitle.add_Click({

    Start-Process msedge.exe 'https://github.com/beigeworm'

})

$Menu_Exit.add_Click({

    $notify = New-Object System.Windows.Forms.NotifyIcon
    $notify.Icon = [System.Drawing.SystemIcons]::Shield
    $notify.Visible = $true
    $balloonTipTitle = "USB Monitoring"
    $balloonTipText = "BadUSB Monitor Stopped"
    $notify.ShowBalloonTip(3000, $balloonTipTitle, $balloonTipText, [System.Windows.Forms.ToolTipIcon]::Error)

    Stop-Job -Name DeviceMonitor
    $Systray_Tool_Icon.Visible = $false
    $appContext.ExitThread()
    sleep 2
    exit
    
})

[void][System.Windows.Forms.Application]::Run($appContext)

