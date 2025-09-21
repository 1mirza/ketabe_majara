// >>>>> شروع کدهای اضافه شده - بخش اول (نسخه کاتلین - نهایی) <<<<<
// این دو خط برای حل خطا اضافه شده‌اند
import java.util.Properties
import java.io.FileInputStream
// >>>>> پایان کدهای اضافه شده - بخش اول (نسخه کاتلین - نهایی) <<<<<

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// >>>>> شروع کدهای اضافه شده - بخش دوم (نسخه کاتلین) <<<<<
// این بخش فایل key.properties را می‌خواند تا به رمزها دسترسی داشته باشد
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
// >>>>> پایان کدهای اضافه شده - بخش دوم (نسخه کاتلین) <<<<<

android {
    namespace = "com.example.flutter_application_1"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // >>>>> شروع کدهای اضافه شده - بخش سوم (نسخه کاتلین) <<<<<
    // این بخش، تنظیمات کلید امضای شما را تعریف می‌کند
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }
    // >>>>> پایان کdeos اضافه شده - بخش سوم (نسخه کاتلین) <<<<<

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.hamidrezaalimirzaei.ketabe_majara"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            // TODO: Add your own signing config for the release build.
            // >>>>> این خط تغییر کرده است <<<<<
            // به جای استفاده از کلید دیباگ، از کلید رسمی که ساختیم استفاده می‌کنیم
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

