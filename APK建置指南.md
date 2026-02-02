# 品盛冷氣行報價單 APK 建置指南

## 🎯 建置 APK 的方法

本專案提供**三種方法**建置 Android APK：

---

## 方法一：使用「完整自動建置.bat」（✅ 推薦）

### 適用情況
- 首次建置 APK
- 系統環境變數未設定
- 需要自動偵測 Android Studio 和 SDK

### 使用步驟

1. **確認已安裝必要工具**
   - ✅ Node.js
   - ✅ Cordova (`npm install -g cordova`)
   - ✅ Android Studio

2. **執行建置腳本**
   ```batch
   雙擊執行「完整自動建置.bat」
   ```

3. **等待建置完成**
   - ⏱️ 首次建置約需 5-10 分鐘
   - 腳本會自動下載 Gradle 和相依套件
   - 建置完成後會自動開啟 APK 所在資料夾

4. **APK 位置**
   ```
   platforms\android\app\build\outputs\apk\debug\app-debug.apk
   ```

### 腳本功能
此腳本會自動：
- ✅ 偵測 Android Studio 的 JDK
- ✅ 偵測 Android SDK
- ✅ 設定環境變數（JAVA_HOME、ANDROID_HOME）
- ✅ 驗證 Java 和 Cordova
- ✅ 執行建置
- ✅ 開啟 APK 所在資料夾

---

## 方法二：使用「自動建置APK.bat」（⚡ 快速）

### 適用情況
- 環境變數已正確設定
- 之前建置過，只是程式碼有更新
- 想要快速建置

### 使用步驟

1. **執行建置腳本**
   ```batch
   雙擊執行「自動建置APK.bat」
   ```

2. **等待建置完成**
   - 建置完成後會自動開啟 APK 所在資料夾

### 注意事項
- 此腳本不會自動設定環境變數
- 如果建置失敗，請使用「方法一」

---

## 方法三：使用命令列手動建置

### 適用情況
- 想要更多控制權
- 需要查看詳細建置日誌
- 環境變數已正確設定

### 使用步驟

1. **開啟命令提示字元或 PowerShell**
   ```batch
   cd C:\Users\user\.gemini\antigravity\scratch\pinsheng-quotation
   ```

2. **執行建置命令**
   ```batch
   cordova build android
   ```

3. **如需詳細日誌**
   ```batch
   cordova build android --verbose
   ```

---

## 🔧 常見問題解決

### 問題 1：找不到 JDK

**錯誤訊息：**
```
Error: Failed to find 'JAVA_HOME' environment variable
```

**解決方法：**
1. 使用「完整自動建置.bat」（會自動偵測）
2. 或手動設定環境變數：
   - 變數名：`JAVA_HOME`
   - 變數值：`C:\Program Files\Android\Android Studio\jbr`

---

### 問題 2：找不到 Android SDK

**錯誤訊息：**
```
Error: Failed to find 'ANDROID_HOME' environment variable
```

**解決方法：**
1. 使用「完整自動建置.bat」（會自動偵測）
2. 或手動設定環境變數：
   - 變數名：`ANDROID_HOME`
   - 變數值：`%LOCALAPPDATA%\Android\Sdk`

---

### 問題 3：Gradle 兼容性問題

**錯誤訊息：**
```
Cannot select root node 'debugRuntimeClasspathCopy' as a variant
```

**原因：**
Cordova Android 14.0.1 與 Gradle 9.0 不相容

**解決方法：**
修改 `platforms\android\gradle\wrapper\gradle-wrapper.properties`：

```properties
# 將 Gradle 版本改為 8.10
distributionUrl=https\://services.gradle.org/distributions/gradle-8.10-all.zip
```

詳見：[GRADLE_FIX.md](file:///C:/Users/user/.gemini/antigravity/scratch/pinsheng-quotation/GRADLE_FIX.md)

---

### 問題 4：建置時間過長

**正常情況：**
- 首次建置：5-10 分鐘（需下載 Gradle 和相依套件）
- 後續建置：1-3 分鐘

**如果超過 15 分鐘：**
1. 檢查網路連線
2. 重新執行建置腳本
3. 清除 Gradle 快取後重試：
   ```batch
   cd platforms\android
   gradlew clean
   ```

---

### 問題 5：APK 檔案找不到

**檢查路徑：**
```
platforms\android\app\build\outputs\apk\debug\app-debug.apk
```

**如果不存在：**
1. 確認建置過程沒有錯誤
2. 檢查建置日誌
3. 使用 `--verbose` 參數重新建置

---

## 📱 安裝 APK 到手機

### 方法一：USB 傳輸

1. **在電腦上：**
   - 找到 `app-debug.apk` 檔案
   - 用 USB 連接手機
   - 將 APK 複製到手機

2. **在手機上：**
   - 找到 APK 檔案
   - 點擊安裝
   - 允許「安裝未知來源」
   - 完成安裝

### 方法二：雲端硬碟

1. 將 APK 上傳到 Google Drive / OneDrive
2. 在手機上下載 APK
3. 點擊安裝

### 方法三：即時通訊

1. 透過 LINE、Telegram 等將 APK 傳送給自己
2. 在手機上下載 APK
3. 點擊安裝

---

## ⚠️ 安全提示

1. **允許未知來源**
   - 安裝時需要開啟「允許此來源」
   - 安裝完成後可以關閉此選項

2. **APK 簽署**
   - 目前建置的是 Debug APK（測試版）
   - 如需正式發布，需要建置 Release APK 並簽署

3. **權限說明**
   - 應用程式需要檔案存取權限（用於匯出 PDF 和資料）
   - 不會存取任何個人資料或聯絡人

---

## 🚀 更新程式後重新建置

當你修改了程式碼（HTML/CSS/JS），需要重新建置 APK：

1. **修改檔案**
   - 編輯 `www/` 目錄下的檔案
   - 例如：`www/index.html`、`www/script.js`、`www/style.css`

2. **重新建置**
   ```batch
   雙擊執行「自動建置APK.bat」
   ```

3. **安裝新版本**
   - 在手機上直接安裝新的 APK
   - 系統會覆蓋舊版本
   - **資料不會遺失**（LocalStorage 會保留）

---

## 📋 建置檢查清單

建置前確認：
- ✅ Node.js 已安裝
- ✅ Cordova 已安裝（`npm install -g cordova`）
- ✅ Android Studio 已安裝
- ✅ Android Studio 已完成首次設定
- ✅ 網路連線正常（首次建置需下載 Gradle）

---

**版本**：1.0.0  
**最後更新**：2026-02-02
