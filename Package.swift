// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Petitio",
    products: [
        .library(
            name: "Petitio",
            targets: ["Petitio"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/http.git", from: "3.1.6"),

//        .package(url: "https://github.com/orta/PackageConfig.git", from: "0.0.1"), // dev

//        .package(url: "https://github.com/orta/Komondor", from: "1.0.0"), // dev

//        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.35.8"), // dev

//        .package(url: "https://github.com/Realm/SwiftLint", from: "0.28.1"), // dev

//        .package(url: "https://github.com/f-meloni/Rocket", from: "0.4.0"), // dev
    ],
    targets: [
        .target(
            name: "Petitio",
            dependencies: ["HTTP"]
        ),
        .testTarget(
            name: "PetitioTests",
            dependencies: ["Petitio"]
        ),
    ]
)

#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfig([
        "komondor": [
            "pre-push": "swift test",
            "pre-commit": [
                "swift run swiftformat Sources/",
                "swift run swiftformat Package.swift",
                "swift run swiftlint autocorrect --path Sources/",
                "git add .",
            ],
        ],
        "rocket": ["steps":
            [
                ["script": ["content": "echo \"Releasing $VERSION\""]],
                "hide_dev_dependencies",
                ["git_add": ["paths": ["Package.swift"]]],
                ["commit": [
                    "message": "Release of version $VERSION",
                    "no_verify": true,
                ]],
                "tag",
                "unhide_dev_dependencies",
                ["git_add": ["paths": ["Package.swift"]]],
                ["commit": [
                    "message": "Unhide dev dependencies",
                    "no_verify": true,
                ]],
                "push",
                ["script": ["content": "echo \"Version $VERSION release 🎉\""]],
        ]],
    ])
#endif
