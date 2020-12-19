plugins {
    kotlin("multiplatform") version "1.4.10"
}

group = "me.robertstevens"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

kotlin {
    val hostOs = System.getProperty("os.name")
    val isMingwX64 = hostOs.startsWith("Windows")
    val nativeTarget = when {
        hostOs == "Mac OS X" -> macosX64("native")
        hostOs == "Linux" -> linuxX64("native")
        isMingwX64 -> mingwX64("native")
        else -> throw GradleException("Host OS is not supported in Kotlin/Native.")
    }

    nativeTarget.apply {
        binaries {
            executable {
                entryPoint = "main"
            }
        }
    }
    sourceSets {
        val nativeMain by getting
        val nativeTest by getting
        commonMain {
            dependencies {
                val ktor_version = "1.4.1"
                val kotlinx_coroutines_version = "1.3.9-native-mt"
                implementation ("io.ktor:ktor-client-curl:$ktor_version")
                implementation ("io.ktor:ktor-client-core:$ktor_version")
                implementation ("org.jetbrains.kotlinx:kotlinx-coroutines-core:$kotlinx_coroutines_version")
            }
        }
    }
}
