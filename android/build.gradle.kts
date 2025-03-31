allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Asegúrate de que la ruta de la carpeta 'build' sea correcta y no cause conflictos
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    // Asegúrate de que cada subproyecto tenga su propia carpeta de construcción
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
