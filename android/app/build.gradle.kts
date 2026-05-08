plugins {
    id("com.android.application")
    id("kotlin-android")
    // ¡Ojo! El plugin de Flutter debe ir después de los de Android y Kotlin para que todo fluya.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.byteup_code"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.byteup_code"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
