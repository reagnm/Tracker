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
    dependencies: [
        .package(url: "https://github.com/aheze/Setting", from: "1.0.1")
        .package(url: "https://github.com/sbertix/Swiftagram", from: "5.4.0")
        .package(url: "https://github.com/Wouter01/SwiftUI-HiddenAPI", from: "1.0")
    ],
    targets: [
        .executableTarget(
            name: "Tracker",
            dependencies: ["Setting","Swiftagram","SwiftUI-HiddenAPI"],
            path: "Tracker/Tracker/Tracker.swift"
        )
    ]
)
