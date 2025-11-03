param(
  [Parameter(Mandatory=$true)]
  [string[]]$DesiredPins,

  [Parameter()]
  [switch]$TestOnly
)

$shell = New-Object -ComObject 'Shell.Application'
$taskbar = $shell.NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items()
$currentPins = $taskbar | ForEach-Object { $_.Name }

# --- Test Logic ---
$isCorrect = $true
if ($currentPins.Count -ne $DesiredPins.Count) { $isCorrect = $false }
if ($isCorrect) {
    foreach($pin in $DesiredPins) {
        if ($pin -notin $currentPins) {
            $isCorrect = $false
            break
        }
    }
}

if ($TestOnly) {
  return $isCorrect
}

# --- Set Logic ---
Write-Output "Setting Taskbar pins..."

# 1. Unpin ALL existing items
$taskbar | ForEach-Object {
  $_.Verbs() | Where-Object { $_.Name.Replace('&','') -eq 'Unpin from taskbar' } | ForEach-Object { $_.DoIt() }
}

Write-Output "Waiting for taskbar to clear..."
Start-Sleep -Seconds 3

# 2. Pin all desired items
# This finds the app in the Start Menu folder and pins it
$startMenu = $shell.NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}')
foreach ($pinName in $DesiredPins) {
  $app = $startMenu.Items() | Where-Object { $_.Name -eq $pinName }
  if ($app) {
    Write-Output "Pinning $pinName"
    $app.Verbs() | Where-Object { $_.Name.Replace('&','') -eq 'Pin to taskbar' } | ForEach-Object { $_.DoIt() }
  } else {
    Write-Warning "Could not find '$pinName' in Start Menu to pin it."
  }
}