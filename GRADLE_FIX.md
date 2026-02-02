# 🔧 Cordova Android + Gradle 9.0 兼容性問題解決方案

## 問題
```
Cannot select root node 'debugRuntimeClasspathCopy' as a variant
```

這是**Cordova Android 14.0.1 與 Gradle 9.0 的已知兼容性問題**。

## 解決方案 1：降級 Gradle（最簡單）✅

修改 `gradle-wrapper.properties`:

```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.10-all.zip
```

Gradle 8.x 與 Cordova Android 14 完全兼容。

---

## 解決方案 2：升級 Cordova Android（需要時間）

升級到 Cordova Android 15+ (尚未發布穩定版)

---

## 解決方案 3：使用命令列建置（繞過 Android Studio）

```batch
cd platforms\android
gradlew assembleDebug
```

---

**建議：使用解決方案 1（降級 Gradle）**

這是最快且最可靠的方法。Gradle 8.10 是穩定版本，與所有 Cordova Android 14.x 完全兼容。
