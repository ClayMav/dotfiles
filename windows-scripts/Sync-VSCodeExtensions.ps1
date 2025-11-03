param(
  [Parameter()] [switch]$TestOnly
)

$Shared = @(
    'redhat.vscode-yaml'
    'charliermarsh.ruff'
    'davidanson.vscode-markdownlint'
    'ms-python.python'
    'ms-python.debugpy'
    'ms-python.mypy-type-checker'
    'mikestead.dotenv'
    'tamasfe.even-better-toml'
    'github.vscode-pull-request-github'
    'ms-vscode.makefile-tools'
    'vscodevim.vim'
    'dbaeumer.vscode-eslint'
    'enkia.tokyo-night'
    'ryanluker.vscode-coverage-gutters'
    'ms-azuretools.vscode-docker'
    'google.gemini-cli-vscode-ide-companion'
    'bradlc.vscode-tailwindcss'
    'hashicorp.terraform'
    'hashicorp.hcl'
    'github.vscode-github-actions'
    'golang.go'
    'jnoortheen.nix-ide'
    'unifiedjs.vscode-mdx'
    'yoavbls.pretty-ts-errors'
    'ms-azuretools.vscode-containers'
    'ms-toolsai.jupyter'
    'ms-toolsai.vscode-jupyter-cell-tags'
    'ms-toolsai.jupyter-keymap'
    'ms-toolsai.jupyter-renderers'
    'ms-toolsai.vscode-jupyter-slideshow'
    'ms-kubernetes-tools.vscode-kubernetes-tools'
)
$StableOnly = @(
    'github.copilot-chat'
    'github.copilot'
    'ms-python.vscode-pylance'
)
$InsidersOnly = @(
    'github.copilot'
    'ms-python.vscode-pylance'
)

$ErrorActionPreference = 'Stop'

# Helper function to check state
function Test-Extensions {
  param($CodeCommand, $Desired)
  if (-not (Get-Command $CodeCommand -ErrorAction SilentlyContinue)) { return $true } # If code isn't installed, state is "good"
  $installed = (& $CodeCommand --list-extensions) -split '\r?\n'
  $missing = Compare-Object -ReferenceObject $Desired -DifferenceObject $installed -PassThru | Where-Object { $_.SideIndicator -eq '<=' }
  $extra = Compare-Object -ReferenceObject $Desired -DifferenceObject $installed -PassThru | Where-Object { $_.SideIndicator -eq '=>' }
  return -not ($missing -or $extra)
}

# Helper function to apply state
function Sync-Extensions {
  param($CodeCommand, $Desired)
  if (-not (Get-Command $CodeCommand -ErrorAction SilentlyContinue)) {
    Write-Output "$CodeCommand not found, skipping extension sync."
    return
  }
  Write-Output "Syncing extensions for $CodeCommand..."
  $installed = (& $CodeCommand --list-extensions) -split '\r?\n'
  
  Compare-Object -ReferenceObject $Desired -DifferenceObject $installed -PassThru |
    Where-Object { $_.SideIndicator -eq '<=' } |
    ForEach-Object { Write-Output "Installing $_"; & $CodeCommand --install-extension $_ }
    
  Compare-Object -ReferenceObject $Desired -DifferenceObject $installed -PassThru |
    Where-Object { $_.SideIndicator -eq '=>' } |
    ForEach-Object { Write-Output "Zapping (Uninstalling) $_"; & $CodeCommand --uninstall-extension $_ }
}

# --- Main Logic ---

$stableList = $Shared + $StableOnly
$insidersList = $Shared + $InsidersOnly

$stableOK = Test-Extensions 'code' $stableList
$insidersOK = Test-Extensions 'code-insiders' $insidersList

if ($TestOnly) {
  return $stableOK -and $insidersOK
}

# "Set" Mode
$ErrorActionPreference = 'SilentlyContinue'
Sync-Extensions 'code' $stableList
Sync-Extensions 'code-insiders' $insidersList