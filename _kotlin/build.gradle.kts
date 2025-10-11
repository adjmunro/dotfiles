plugins {
    alias(libs.plugins.orbit.android.library)
    alias(libs.plugins.junit5.android)
}

android {
    namespace = "{{NAMESPACE}}"

    defaultConfig {
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        testInstrumentationRunnerArguments["runnerBuilder"] = "de.mannodermaus.junit5.AndroidJUnit5Builder"
    }

    testOptions {
        unitTests.all { it.useJUnitPlatform() }
    }
}

dependencies {
    implementation(platform(libs.koin.bom))
    implementation(libs.koin.core)

    testImplementation(libs.bundles.test.junit5)
    testImplementation(libs.bundles.test.kotest)
    testImplementation(libs.bundles.test.mockk)
    testImplementation(libs.jetbrains.coroutines.test)

    androidTestImplementation(libs.bundles.androidTest.junit5)
    androidTestRuntimeOnly(libs.junit5.android.test.runner)
}

