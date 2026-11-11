plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.uts_2415051088_madewilasih"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.example.uts_2415051088_madewilasih"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Dukungan arsitektur untuk HP Android fisik (ARM) & emulator (x86_64)

        externalNativeBuild {
            cmake {
                arguments("-DANDROID_STL=c++_shared", "-j1")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

// Pengaman wajib untuk mencegah bug file locking / circular evaluation di Gradle 9.x pada Windows
tasks.matching { it.name.contains("configureCMake") || it.name.contains("generateCmake") }.configureEach {
    enabled = false
}