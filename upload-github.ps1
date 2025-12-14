# 一键上传到 GitHub
# 用户名: wanyview

$ErrorActionPreference = "Stop"

Write-Host "=== 开始上传到 GitHub ===" -ForegroundColor Green

# 检查是否已经是 git 仓库
if (-Not (Test-Path ".git")) {
    Write-Host "初始化 Git 仓库..." -ForegroundColor Yellow
    git init
    git config user.name "wanyview"
    git config user.email "wanyview@users.noreply.github.com"
}

# 添加所有文件
Write-Host "添加文件..." -ForegroundColor Yellow
git add .

# 提交更改
Write-Host "输入提交信息 (直接回车使用默认信息): " -NoNewline -ForegroundColor Cyan
$commitMessage = Read-Host
if ([string]::IsNullOrWhiteSpace($commitMessage)) {
    $commitMessage = "Update: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
}

Write-Host "提交更改..." -ForegroundColor Yellow
git commit -m "$commitMessage"

# 检查是否已添加远程仓库
$remoteUrl = git remote get-url origin 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "请输入 GitHub 仓库地址 (例如: https://github.com/wanyview/linkaura.git)" -ForegroundColor Cyan
    Write-Host "仓库地址: " -NoNewline -ForegroundColor Cyan
    $repoUrl = Read-Host
    git remote add origin $repoUrl
}

# 推送到 GitHub
Write-Host "推送到 GitHub..." -ForegroundColor Yellow
$branch = git branch --show-current
if ([string]::IsNullOrWhiteSpace($branch)) {
    git branch -M main
    $branch = "main"
}

git push -u origin $branch

Write-Host "`n=== 上传成功！ ===" -ForegroundColor Green
