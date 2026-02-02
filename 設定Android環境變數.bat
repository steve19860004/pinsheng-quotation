@echo off
chcp 65001 >nul
cls
echo ╔════════════════════════════════════════════════════════════╗
echo ║        Android 環境變數自動設定腳本                        ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

:: 檢測常見的 Android SDK 路徑
set "SDK_PATH_1=%LOCALAPPDATA%\Android\Sdk"
set "SDK_PATH_2=%USERPROFILE%\AppData\Local\Android\Sdk"
set "SDK_PATH_3=C:\Android\Sdk"

set "FOUND_SDK="

if exist "%SDK_PATH_1%" (
    set "FOUND_SDK=%SDK_PATH_1%"
) else if exist "%SDK_PATH_2%" (
    set "FOUND_SDK=%SDK_PATH_2%"
) else if exist "%SDK_PATH_3%" (
    set "FOUND_SDK=%SDK_PATH_3%"
)

if defined FOUND_SDK (
    echo ✅ 找到 Android SDK 路徑：
    echo    %FOUND_SDK%
    echo.
    echo 正在設定環境變數...
    
    :: 設定使用者環境變數 ANDROID_HOME
    setx ANDROID_HOME "%FOUND_SDK%"
    
    :: 更新 Path
    setx PATH "%PATH%;%FOUND_SDK%\platform-tools;%FOUND_SDK%\tools"
    
    echo.
    echo ╔════════════════════════════════════════════════════════════╗
    echo ║  ✅ 環境變數設定完成！                                     ║
    echo ╚════════════════════════════════════════════════════════════╝
    echo.
    echo 已設定：
    echo   ANDROID_HOME = %FOUND_SDK%
    echo   PATH 已更新（加入 platform-tools 和 tools）
    echo.
    echo ⚠️  重要：請關閉所有命令提示字元視窗，重新開啟後才會生效
    echo.
) else (
    echo ❌ 未找到 Android SDK
    echo.
    echo 請手動確認 SDK 路徑：
    echo   1. 開啟 Android Studio
    echo   2. 點擊左下角齒輪圖示 → Settings
    echo   3. 前往：Appearance ^& Behavior → System Settings → Android SDK
    echo   4. 複製「Android SDK Location」路徑
    echo.
    echo 然後手動設定環境變數：
    echo   ANDROID_HOME = [您的SDK路徑]
    echo.
)

echo.
pause
