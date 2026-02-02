@echo off
chcp 65001 >nul
cls
echo ╔════════════════════════════════════════════════════════════╗
echo ║        品盛冷氣行報價單系統 - APK 自動建置                ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

cd /d "%~dp0"

echo [1/3] 檢查 Cordova...
where cordova >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ 找不到 Cordova
    echo 請確認 Cordova 已安裝
    pause
    exit /b 1
)
echo ✅ Cordova 已安裝

echo.
echo [2/3] 開始建置 APK...
echo 這個過程可能需要 5-10 分鐘，請耐心等待...
echo.

cordova build android --verbose

echo.
if %ERRORLEVEL% EQU 0 (
    echo ╔════════════════════════════════════════════════════════════╗
    echo ║  ✅ APK 建置成功！                                         ║
    echo ╚════════════════════════════════════════════════════════════╝
    echo.
    echo 📱 APK 檔案位置：
    echo %CD%\platforms\android\app\build\outputs\apk\debug\app-debug.apk
    echo.
    echo 💡 下一步：
    echo   1. 將 APK 傳送到 Android 手機
    echo   2. 在手機上點擊安裝
    echo   3. 允許安裝未知來源的應用
    echo   4. 完成！
    echo.
    
    :: 嘗試開啟檔案位置
    if exist "platforms\android\app\build\outputs\apk\debug\app-debug.apk" (
        echo 正在開啟 APK 所在資料夾...
        explorer "platforms\android\app\build\outputs\apk\debug"
    )
) else (
    echo.
    echo ╔════════════════════════════════════════════════════════════╗
    echo ║  ❌ 建置失敗                                               ║
    echo ╚════════════════════════════════════════════════════════════╝
    echo.
    echo 可能原因：
    echo   1. 未設定 ANDROID_HOME 環境變數
    echo   2. 未安裝 Android SDK
    echo   3. 未安裝 JDK
    echo.
    echo 建議解決方案：
    echo   1. 執行「設定Android環境變數.bat」
    echo   2. 使用 Android Studio 開啟專案建置
    echo   3. 查看上方錯誤訊息並截圖給我
    echo.
)

pause
