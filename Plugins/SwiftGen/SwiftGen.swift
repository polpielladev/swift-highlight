import PackagePlugin

@main
struct SwiftGenPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        // Get the path for the output files
        let outputPath = context.pluginWorkDirectory
        let outputFilePath = outputPath.appending("GeneratedColors.swift")

        return [
            .prebuildCommand(
                displayName: "SwiftGen",
                executable: try context.tool(named: "swiftgen").path,
                arguments: [
                    "run", "xcassets",
                    "\(context.package.directory)/Sources/Theme/Resources/Colors.xcassets",
                    "--param", "publicAccess",
                    "--templateName", "swift5",
                    "--output", "\(outputFilePath)"],
                environment: [:],
                outputFilesDirectory: outputPath
            ),
        ]
    }
}
