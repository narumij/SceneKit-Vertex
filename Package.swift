// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SceneKit-Vertex",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SceneKit-Vertex",
            targets: ["SceneKit_Vertex"]),
        .executable(
            name: "SCNVertexClient",
            targets: ["SCNVertexClient"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0-swift-DEVELOPMENT-SNAPSHOT-2023-08-07-a"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .macro(
            name: "SCNVertexMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "SceneKit_Vertex", dependencies: ["SCNVertexMacros"]),
        .executableTarget(name: "SCNVertexClient", dependencies: [ "SceneKit_Vertex" ]),
        .testTarget(
            name: "SceneKit_VertexTests",
            dependencies: ["SceneKit_Vertex"]),
        .testTarget(
                name: "SCNVertexMacrosTests",
                dependencies: [
                    "SCNVertexMacros",
                    .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
                ]
            ),
    ]
)
