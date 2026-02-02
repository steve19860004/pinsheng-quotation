@echo off
chcp 65001 >nul
echo ========================================
echo Starting APK Build
echo ========================================
echo.

cd /d "%~dp0"

echo Setting environment variables...
set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
set "ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk"
set "ANDROID_SDK_ROOT=%LOCALAPPDATA%\Android\Sdk"
set "PATH=%JAVA_HOME%\bin;%ANDROID_HOME%\platform-tools;%PATH%"

echo.
echo Checking Java version...
"%JAVA_HOME%\bin\java.exe" -version
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Java not found
    pause
    exit /b 1
)

echo.
echo ========================================
echo Building APK...
echo ========================================
echo.

cordova build android --verbose

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo SUCCESS! APK built successfully
    echo ========================================
    echo.
    
    set "APK_PATH=platforms\android\app\build\outputs\apk\debug\app-debug.apk"
    
    if exist "%APK_PATH%" (
        echo APK Location: %CD%\%APK_PATH%
        echo.
        echo Opening APK folder...
        explorer "platforms\android\app\build\outputs\apk\debug"
    ) else (
        echo WARNING: APK not found at expected location
    )
) else (
    echo.
    echo ========================================
    echo BUILD FAILED
    echo ========================================
    echo.
    echo Please check the error messages above
)

echo.
pause
