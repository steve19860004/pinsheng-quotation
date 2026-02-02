@echo off
chcp 65001 >nul
cls
echo ╔════════════════════════════════════════════════════════════╗
echo ║        品盛冷氣行 - APK 建置（使用 Android Studio）       ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

cd /d "%~dp0"

echo 由於命令列建置需要完整的環境配置，
echo 最簡單且最可靠的方式是使用 Android Studio 來建置 APK。
echo.
echo ════════════════════════════════════════════════════════════
echo.
echo 📱 請按照以下步驟在 Android Studio 中建置：
echo.
echo 1️⃣  開啟 Android Studio
echo.
echo 2️⃣  點擊 "Open"
echo    選擇資料夾：
echo    %CD%\platforms\android
echo.
echo 3️⃣  等待 Gradle 同步完成（5-10 分鐘）
echo    • 查看底部狀態欄
echo    • 顯示 "Gradle: Sync" 進度
echo    • 等待直到顯示 "Gradle build finished"
echo.
echo 4️⃣  建置 APK
echo    • 點擊：Build → Build Bundle(s) / APK(s) → Build APK(s)
echo    • 或按快捷鍵：Ctrl + Shift + A，輸入 "build apk"
echo.
echo 5️⃣  取得 APK
echo    • 右下角會彈出 "APK(s) generated successfully"
echo    • 點擊通知中的 "locate" 開啟檔案位置
echo    • 或前往：platforms\android\app\build\outputs\apk\debug\
echo.
echo ════════════════════════════════════════════════════════════
echo.

echo 環境資訊：
echo ✅ JDK：C:\Program Files\Android\Android Studio\jbr
echo ✅ Android SDK：C:\Users\user\AppData\Local\Android\Sdk
echo ✅ Cordova：已安裝
echo.

choice /C YN /M "要現在開啟 Android Studio 嗎？"
if errorlevel 2 goto MANUAL
if errorlevel 1 goto OPEN

:OPEN
echo.
echo 正在開啟 Android Studio...
echo.
start "" "C:\Program Files\Android\Android Studio\bin\studio64.exe" "%CD%\platforms\android"
echo.
echo ✅ Android Studio 已啟動！
echo.
echo 請在 Android Studio 中按照上述步驟操作。
echo.
goto END

:MANUAL
echo.
echo 請手動開啟 Android Studio 並依照上述步驟操作。
echo.

:END
pause
