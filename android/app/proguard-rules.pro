# --- OkHttp / Dio ---
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# --- Dio internals использует dart:ffi/platform каналы, но подстрахуемся от warning'ов ---
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**

# --- Gson (если используется где-то в зависимостях) ---
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# --- Общее правило: не трогать классы с @Keep ---
-keep class androidx.annotation.Keep
-keep @androidx.annotation.Keep class * { *; }