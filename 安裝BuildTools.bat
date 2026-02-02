@echo off
chcp 65001 >nul
cls
echo ╔════════════════════════════════════════════════════════════╗
echo ║     自動安裝 Android SDK Build Tools                      ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

:: 設定 Android SDK 路徑
set "SDK_PATH=%LOCALAPPDATA%\Android\Sdk"
if not exist "%SDK_PATH%" (
    set "SDK_PATH=%USERPROFILE%\AppData\Local\Android\Sdk"
)

if not exist "%SDK_PATH%" (
    echo ❌ 找不到 Android SDK
    echo 請確認 Android Studio 已正確安裝
    pause
    exit /b 1
)

echo ✅ 找到 Android SDK：%SDK_PATH%
echo.

:: 尋找 sdkmanager
set "SDKMANAGER=%SDK_PATH%\cmdline-tools\latest\bin\sdkmanager.bat"
if not exist "%SDKMANAGER%" (
    set "SDKMANAGER=%SDK_PATH%\tools\bin\sdkmanager.bat"
)
if not exist "%SDKMANAGER%" (
    echo ⚠️  找不到 sdkmanager 工具
    echo.
    echo 這代表需要先在 Android Studio 中安裝 Command Line Tools：
    echo.
    echo 步驟：
    echo 1. 開啟 Android Studio
    echo 2. Tools → SDK Manager
    echo 3. SDK Tools 標籤
    echo 4. 勾選「Android SDK Command-line Tools (latest)」
    echo 5. 點擊 Apply 安裝
    echo.
    echo 或者直接在 Android Studio 的 SDK Manager 中安裝 Build Tools：
    echo 1. Tools → SDK Manager
    echo 2. SDK Tools 標籤
    echo 3. 勾選「Android SDK Build-Tools」
    echo 4. 點擊 Apply
    echo.
    pause
    exit /b 1
)

echo ✅ 找到 sdkmanager：%SDKMANAGER%
echo.
echo ════════════════════════════════════════════════════════════
echo 開始安裝 Android SDK Build Tools...
echo ════════════════════════════════════════════════════════════
echo.
echo 這可能需要幾分鐘時間...
echo.

:: 安裝最新的 Build Tools
echo y | "%SDKMANAGER%" "build-tools;34.0.0"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ╔════════════════════════════════════════════════════════════╗
    echo ║  ✅ Build Tools 安裝成功！                                 ║
    echo ╚════════════════════════════════════════════════════════════╝
    echo.
    echo 下一步：
    echo 1. 回到 Android Studio
    echo 2. 點擊 File → Sync Project with Gradle Files
    echo 3. 或點擊錯誤訊息中的「Try Again」
    echo 4. 等待同步完成
    echo 5. 建置 APK：Build → Build APK(s)
    echo.
) else (
    echo.
    echo ╔════════════════════════════════════════════════════════════╗
    echo ║  ❌ 安裝失敗                                               ║
    echo ╚════════════════════════════════════════════════════════════╝
    echo.
    echo 請嘗試在 Android Studio 中手動安裝：
    echo Tools → SDK Manager → SDK Tools → Android SDK Build-Tools
    echo.
)

pause
