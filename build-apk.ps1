# 設定環境變數並建置 APK
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
$env:ANDROID_SDK_ROOT = "$env:LOCALAPPDATA\Android\Sdk"
$env:PATH = "$env:JAVA_HOME\bin;$env:ANDROID_HOME\platform-tools;$env:ANDROID_HOME\tools;$env:PATH"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "環境變數設定完成" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "JAVA_HOME: $env:JAVA_HOME"
Write-Host "ANDROID_HOME: $env:ANDROID_HOME"
Write-Host ""

Write-Host "檢查 Java 版本..." -ForegroundColor Yellow
& "$env:JAVA_HOME\bin\java.exe" -version

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "開始建置 APK..." -ForegroundColor Yellow
Write-Host "這可能需要 5-10 分鐘，請耐心等候" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 執行 Cordova 建置
cordova build android --verbose

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "✅ APK 建置成功！" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    $apkPath = "platforms\android\app\build\outputs\apk\debug\app-debug.apk"
    if (Test-Path $apkPath) {
        $apkSize = (Get-Item $apkPath).Length / 1MB
        Write-Host "📱 APK 檔案資訊：" -ForegroundColor Green
        Write-Host "   檔案名稱：app-debug.apk"
        Write-Host "   完整路徑：$PWD\$apkPath"
        Write-Host "   檔案大小：$([math]::Round($apkSize, 2)) MB"
        Write-Host ""
        Write-Host "正在開啟 APK 所在資料夾..." -ForegroundColor Yellow
        Start-Process "platforms\android\app\build\outputs\apk\debug"
    } else {
        Write-Host "⚠️ APK 檔案未在預期位置找到" -ForegroundColor Yellow
    }
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "❌ 建置失敗" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "請檢查上方的錯誤訊息" -ForegroundColor Yellow
}
