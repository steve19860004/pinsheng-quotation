@echo off
chcp 65001 >nul
cls
echo ╔════════════════════════════════════════════════════════════╗
echo ║        品盛冷氣行 - APK 完整自動建置腳本                  ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

cd /d "%~dp0"

echo [1/5] 偵測 Android Studio 的 JDK...

:: 嘗試找到 Android Studio 的 JDK
set "STUDIO_JDK="
if exist "%LOCALAPPDATA%\Programs\Android\Android Studio\jbr" (
    set "STUDIO_JDK=%LOCALAPPDATA%\Programs\Android\Android Studio\jbr"
)
if exist "C:\Program Files\Android\Android Studio\jbr" (
    set "STUDIO_JDK=C:\Program Files\Android\Android Studio\jbr"
)

if defined STUDIO_JDK (
    echo ✅ 找到 JDK：%STUDIO_JDK%
    set "JAVA_HOME=%STUDIO_JDK%"
    set "PATH=%STUDIO_JDK%\bin;%PATH%"
) else (
    echo ❌ 找不到 Android Studio 的 JDK
    echo 請確認 Android Studio 已正確安裝
    pause
    exit /b 1
)

echo.
echo [2/5] 偵測 Android SDK...

set "FOUND_SDK="
if exist "%LOCALAPPDATA%\Android\Sdk" (
    set "FOUND_SDK=%LOCALAPPDATA%\Android\Sdk"
)
if exist "%USERPROFILE%\AppData\Local\Android\Sdk" (
    set "FOUND_SDK=%USERPROFILE%\AppData\Local\Android\Sdk"
)

if defined FOUND_SDK (
    echo ✅ 找到 SDK：%FOUND_SDK%
    set "ANDROID_HOME=%FOUND_SDK%"
    set "ANDROID_SDK_ROOT=%FOUND_SDK%"
    set "PATH=%FOUND_SDK%\platform-tools;%FOUND_SDK%\tools;%PATH%"
) else (
    echo ❌ 找不到 Android SDK
    echo.
    echo 請先在 Android Studio 中完成首次設定
    pause
    exit /b 1
)

echo.
echo [3/5] 驗證環境...
echo.

echo 檢查 Java:
"%JAVA_HOME%\bin\java.exe" -version
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Java 無法執行
    pause
    exit /b 1
)

echo.
echo 檢查 Cordova:
where cordova >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ 找不到 Cordova
    echo 請執行：npm install -g cordova
    pause
    exit /b 1
)
echo ✅ Cordova 已安裝

echo.
echo [4/5] 開始建置 APK...
echo.
echo ⏱️  這個過程可能需要 5-10 分鐘
echo 💡 首次建置會下載 Gradle 和相依套件
echo.

cordova build android --verbose

echo.
if %ERRORLEVEL% EQU 0 (
    echo ╔════════════════════════════════════════════════════════════╗
    echo ║  ✅ APK 建置成功！                                         ║
    echo ╚════════════════════════════════════════════════════════════╝
    echo.
    echo [5/5] APK 檔案資訊：
    echo.
    
    set "APK_PATH=platforms\android\app\build\outputs\apk\debug\app-debug.apk"
    
    if exist "%APK_PATH%" (
        echo 📱 檔案名稱：app-debug.apk
        echo 📍 完整路徑：%CD%\%APK_PATH%
        
        for %%A in ("%APK_PATH%") do (
            set "APK_SIZE=%%~zA"
            set /a "APK_SIZE_MB=%%~zA / 1048576"
        )
        echo 💾 檔案大小：約 !APK_SIZE_MB! MB
        echo.
        echo ════════════════════════════════════════════════════════════
        echo.
        echo 📱 下一步：安裝到 Android 手機
        echo.
        echo 1. 將 APK 傳送到手機
        echo    • USB 傳輸
        echo    • 雲端硬碟（Google Drive/ OneDrive）
        echo    • Email 寄給自己
        echo    • 即時通訊（LINE、Telegram）
        echo.
        echo 2. 在手機上點擊 APK 檔案
        echo.
        echo 3. 允許安裝未知來源
        echo    • 設定 → 安全性 → 允許此來源
        echo.
        echo 4. 點擊安裝，完成！
        echo.
        echo ════════════════════════════════════════════════════════════
        echo.
        echo 正在開啟 APK 所在資料夾...
        timeout /t 2 >nul
        explorer "platforms\android\app\build\outputs\apk\debug"
    ) else (
        echo ⚠️  APK 檔案未在預期位置找到
        echo 請檢查建置日誌
    )
) else (
    echo.
    echo ╔════════════════════════════════════════════════════════════╗
    echo ║  ❌ 建置失敗                                               ║
    echo ╚════════════════════════════════════════════════════════════╝
    echo.
    echo 請檢查上方的錯誤訊息
    echo.
    echo 常見問題：
    echo   • Gradle 下載超時：重新執行此腳本
    echo   • SDK 版本問題：在 Android Studio 中更新 SDK
    echo   • 網路問題：確認網路連線正常
    echo.
    echo 如需協助，請將錯誤訊息截圖給我
)

echo.
pause
