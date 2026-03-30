# OpenSpeak 一键云编译安装工具

Write-Host "🚀 1. 正在推送代码到 GitHub..." -ForegroundColor Cyan
git add .
git commit -m "Remote build trigger: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git push origin main

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Git 推送失败，请检查网络或冲突" -ForegroundColor Red
    exit
}

Write-Host "`n⏳ 2. 等待 GitHub Actions 云端编译 (这可能需要几分钟)..." -ForegroundColor Yellow
Write-Host "你可以去 https://github.com/$(git remote get-url origin | %{ $_ -replace '.*github.com[:/]', '' -replace '\.git$', '' })/actions 查看进度" -ForegroundColor Gray

# 等待最近的一个运行任务
gh run watch

Write-Host "`n✅ 3. 编译完成！正在下载 APK..." -ForegroundColor Green
# 获取最近一次运行的 ID 并下载 artifact
$runId = gh run list --workflow=main.yml --limit 1 --json databaseId --jq '.[0].databaseId'
gh run download $runId --name release-apk --dir ./build_temp --force

if (!(Test-Path "./build_temp/app-release.apk")) {
    Write-Host "❌ 下载失败，未在压缩包中找到 APK" -ForegroundColor Red
    exit
}

Write-Host "`n📲 4. 正在通过 ADB 安装到设备..." -ForegroundColor Cyan
adb install -r "./build_temp/app-release.apk"

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n🎉 搞定！App 已自动安装并在你的设备上运行。" -ForegroundColor Green
    # 尝试自动启动 App (package name 请根据你的 AndroidManifest 确认)
    adb shell am start -n com.example.openspeak/com.example.openspeak.MainActivity
} else {
    Write-Host "❌ ADB 安装失败，请检查手机是否已连接并开启 USB 调试。" -ForegroundColor Red
}

# 清理临时文件
Remove-Item -Recurse -Force ./build_temp