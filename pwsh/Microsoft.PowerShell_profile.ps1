# Terminal-Icons (adds icons/colors to ls)
if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module Terminal-Icons
} 

# posh-git for Git info
if (Get-Module -ListAvailable -Name posh-git) {
    Import-Module posh-git
    $GitPromptSettings.EnablePromptStatus = $false
}

# PSReadLine for history and autosuggestions
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -Colors @{
        "InlinePrediction" = "#E7F9A9"
    }
    # Better history search
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}

# =============================
# Git Status Function
# =============================
function Get-GitStatus {
    if (git rev-parse --is-inside-work-tree 2>$null) {
        $branch = git symbolic-ref --quiet --short HEAD 2>$null
        if (-not $branch) {
            $branch = git rev-parse --short HEAD 2>$null
        }
        if (-not $branch) {
            $branch = "(unknown)"
        }

        # Check for changes
        $status = git status --porcelain 2>$null
        $indicators = ""
        
        if ($status -match '^M') { $indicators += '+' }  # staged changes
        if ($status -match '^ M') { $indicators += '!' } # unstaged changes
        if ($status -match '^\?\?') { $indicators += '?' } # untracked files
        if (git rev-parse --verify refs/stash 2>$null) { $indicators += '$' } # stashed changes

        $statusText = if ($indicators) { " [$indicators]" } else { "" }
        
        return " on $([char]0xE0A0) ", $branch, $statusText
    }
    return $null
}

# =============================
# Virtual Environment Function
# =============================
function Get-VenvPrompt {
    if ($env:VIRTUAL_ENV) {
        $venvName = Split-Path $env:VIRTUAL_ENV -Leaf
        return $venvName
    }
    return $null
}

# =============================
# Custom Prompt
# =============================
function prompt {
    $lastSuccess = $?
    
    $venv = Get-VenvPrompt
    if ($venv) {
        Write-Host ""
        Write-Host "($venv)" -ForegroundColor DarkCyan
    }
    
    # User and host
    $userColor = if ($env:USERNAME -eq "Administrator") { "Red" } else { "Yellow" }
    Write-Host "$env:USERNAME" -ForegroundColor $userColor -NoNewline
    Write-Host "@" -ForegroundColor DarkGray -NoNewline
    Write-Host "$env:COMPUTERNAME" -ForegroundColor Gray -NoNewline
    Write-Host " in " -ForegroundColor White -NoNewline
    
    # Current directory
    $path = (Get-Location).Path.Replace($HOME, "~")
    Write-Host $path -ForegroundColor Green -NoNewline
    
    # Git status
    $gitInfo = Get-GitStatus
    if ($gitInfo) {
        Write-Host $gitInfo[0] -ForegroundColor White -NoNewline
        Write-Host $gitInfo[1] -ForegroundColor Blue -NoNewline
        Write-Host $gitInfo[2] -ForegroundColor White
    }
    else {
        Write-Host ""
    }
    
    # Time stamp on the second line before prompt character
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Host "[$timestamp] " -ForegroundColor DarkGray -NoNewline
    
    # Prompt character (changes color on error)
    $promptChar = if ($lastSuccess) { "Green" } else { "Red" }
    Write-Host "❯" -ForegroundColor $promptChar -NoNewline
    
    return " "
}

# =============================
# Optional: oh-my-posh
# (Comment out the custom prompt above if using this)
# =============================
# if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
#     oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\paradox.omp.json" | Invoke-Expression
# }

# =============================
# Disable Python venv default prompt
# =============================
$env:VIRTUAL_ENV_DISABLE_PROMPT = 1