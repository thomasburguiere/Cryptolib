// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CryptoLib",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "CryptoLib",
            targets: ["CryptoLib"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        
        .package(url: "https://github.com/vapor/service.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/console.git", from: "3.0.0"),
        .package(url: "https://github.com/thomasburguiere/rx-rest-caller.git", from: "0.0.4"),
        .package(url: "https://github.com/socketio/socket.io-client-swift.git", .upToNextMinor(from: "15.2.0"))

    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "CryptoLib",
            dependencies: ["RxRestCaller", "SocketIO", "Service", "Console"]),
        .testTarget(
            name: "CryptoLibTests",
            dependencies: ["CryptoLib"]),
    ]
)
