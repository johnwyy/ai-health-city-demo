param([string]$token)
$repo = 'ai-health-city-demo'

try {
  $user = Invoke-RestMethod -Uri 'https://api.github.com/user' -Headers @{ Authorization = "token $token"; 'User-Agent' = 'ps-deploy' } -ErrorAction Stop
  $owner = $user.login
  Write-Host "OWNER:$owner"
} catch {
  Write-Host "ERROR:GetUser:$($_.Exception.Message)"
  exit 1
}

# create repo (public)
try {
  $body = @{ name = $repo; private = $false } | ConvertTo-Json
  $resp = Invoke-RestMethod -Uri 'https://api.github.com/user/repos' -Method Post -Headers @{ Authorization = "token $token"; 'User-Agent' = 'ps-deploy' } -Body $body -ContentType 'application/json' -ErrorAction Stop
  Write-Host "REPO_CREATED:$($resp.full_name)"
} catch {
  if ($_.Exception.Response) {
    try { $err = $_.Exception.Response.Content | ConvertFrom-Json; Write-Host "REPO_CREATE_ERROR:$($err.message)" } catch { Write-Host "REPO_CREATE_ERROR_RAW:$($_.Exception.Message)" }
  } else { Write-Host "REPO_CREATE_ERROR:$($_.Exception.Message)" }
}

# initialize and commit
if (-not (Test-Path .git)) {
  git init
  git checkout -b main
} else {
  git branch -M main
}

if (-not (git config --get user.name)) { git config user.name 'ai-demo-bot' }
if (-not (git config --get user.email)) { git config user.email 'ai-demo@example.com' }

$porcelain = git status --porcelain
if ($porcelain) {
  git add -A
  git commit -m 'Initial commit: demo prototype' 2>$null
} else { Write-Host 'GIT: no changes to commit' }

# push using token in remote URL (will be reset after)
git remote remove origin 2>$null
git remote add origin "https://$token@github.com/$owner/$repo.git"
git push -u origin main

# remove token from remote
git remote set-url origin "https://github.com/$owner/$repo.git"

# enable Pages
try {
  $pagesBody = @{ source = @{ branch = 'main'; path = '/' } } | ConvertTo-Json
  $pagesResp = Invoke-RestMethod -Uri "https://api.github.com/repos/$owner/$repo/pages" -Method Put -Headers @{ Authorization = "token $token"; 'User-Agent' = 'ps-deploy' } -Body $pagesBody -ContentType 'application/json' -ErrorAction Stop
  Write-Host "PAGES_ENABLED"
} catch { Write-Host "PAGES_ERROR:$($_.Exception.Message)" }

Write-Host "SITE_URL:https://$owner.github.io/$repo/"
