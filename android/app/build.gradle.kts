import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // Firebase (project: coinsights-eabc4)
    id("com.google.gms.google-services")
}

// Release signing, read from android/key.properties (gitignored — never
// commit a keystore or its passwords). Falls back to debug signing when the
// file is absent, so `flutter build apk/appbundle --release` still works on
// a fresh clone or in CI that hasn't been given the release keystore.
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
val hasReleaseSigning = keystorePropertiesFile.exists()
if (hasReleaseSigning) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
}

android {
    namespace = "com.cognizeapp.coinsights"
    compileSdk = flutter.compileSdkVersion
    // Newer plugins (Firebase, RevenueCat, google_sign_in, sign_in_with_apple,
    // sqflite) require a higher NDK than Flutter's own default.
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.cognizeapp.coinsights"
        // firebase-auth requires >= 23; Flutter's own default (21) is too low.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // Real release keystore when key.properties is present (local
            // release builds, or CI with it supplied via secure env vars);
            // otherwise debug-signed so the build never breaks.
            signingConfig = if (hasReleaseSigning) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
