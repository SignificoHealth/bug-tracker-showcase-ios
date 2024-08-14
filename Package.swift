// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BugTrackerShowcase",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "API",
            targets: ["API"]
        ),
        .library(
            name: "Repository",
            targets: ["Repository"]
        ),
        .library(
            name: "Entities",
            targets: ["Entities"]
        ),
        .library(
            name: "SharedUI",
            targets: ["SharedUI"]
        ),
        .library(
            name: "Logger",
            targets: ["Logger"]
        ),
        // MARK: Feature
        .library(
            name: "HomeTabFeature",
            targets: ["HomeTabFeature"]
        ),
        .library(
            name: "IssuesFeature",
            targets: ["IssuesFeature"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/Alamofire/Alamofire.git",
            .upToNextMajor(from: "5.9.1")
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies",
            .upToNextMajor(from: "1.3.7")
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-navigation",
            .upToNextMajor(from: "2.0.0")
        ),
        .package(
            url: "https://github.com/gonzalezreal/swift-markdown-ui",
            .upToNextMajor(from: "2.0.2")
        ),
        .package(
            url: "https://github.com/thebarndog/swift-dotenv.git", 
            .upToNextMajor(from: "2.0.0")
        ),
        .package(
            url: "https://github.com/apple/swift-log.git",
            .upToNextMajor(from: "1.0.0")
        ),
        .package(
            url: "https://github.com/chrisaljoudi/swift-log-oslog.git",
            .upToNextMajor(from: "0.2.1")
        )
    ],
    targets: [
        .target(
            name: "API",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "Dependencies", package: "swift-dependencies")
            ]
        ),
        .target(
            name: "Logger",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "LoggingOSLog", package: "swift-log-oslog")
            ]
        ),
        .target(
            name: "Repository",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "SwiftDotenv", package: "swift-dotenv"),
                "API",
                "Entities"
            ]
        ),
        .target(
            name: "Entities"
        ),
        .target(
            name: "SharedUI",
            dependencies: [
                "Entities",
                .product(name: "SwiftUINavigation", package: "swift-navigation"),
                .product(name: "MarkdownUI", package: "swift-markdown-ui")
            ],
            resources: [.process("Resources/Fonts/")]
        ),
        // MARK: Feature targets
        .target(
            name: "HomeTabFeature",
            dependencies: [
                "Repository",
                "SharedUI",
                "IssuesFeature",
                "Logger",
                .product(name: "SwiftUINavigation", package: "swift-navigation"),
                .product(name: "MarkdownUI", package: "swift-markdown-ui")
            ]
        ),
        .target(
            name: "IssuesFeature",
            dependencies: [
                "Repository",
                "SharedUI",
                "Logger",
                .product(name: "SwiftUINavigation", package: "swift-navigation"),
                .product(name: "MarkdownUI", package: "swift-markdown-ui")
            ]
        ),
        // MARK: Test targets
        .testTarget(
            name: "HomeTabFeatureTests",
            dependencies: ["HomeTabFeature"]
        ),
        .testTarget(
            name: "IssuesFeatureTests",
            dependencies: ["IssuesFeature"]
        )
    ]
)
