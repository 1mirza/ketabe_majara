plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// >>>>> شروع کدهای اضافه شده - بخش اول <<<<<
// این بخش فایل key.properties را می‌خواند تا به رمزها دسترسی داشته باشد
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
// >>>>> پایان کدهای اضافه شده - بخش اول <<<<<

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

    // >>>>> شروع کدهای اضافه شده - بخش دوم <<<<<
    // این بخش، تنظیمات کلید امضای شما را تعریف می‌کند
    signingConfigs {
        release {
            if (keystorePropertiesFile.exists()) {
                storeFile file(keystoreProperties['storeFile'])
                storePassword keystoreProperties['storePassword']
                keyAlias keystoreProperties['keyAlias']
                keyPassword keystoreProperties['keyPassword']
            }
        }
    }
    // >>>>> پایان کدهای اضافه شده - بخش دوم <<<<<

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.flutter_application_1"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
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



