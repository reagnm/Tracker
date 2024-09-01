// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Tracker",
    products: [
        .executable(
            name:"Tracker",
            targets: ["Tracker"]
        )
    ],
    targets: [
        .executableTarget(
            name: "Tracker",
            dependencies: [
                "Tracker"
            ]
        )
    ]
)
