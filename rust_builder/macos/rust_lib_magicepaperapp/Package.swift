// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// The Rust static library is not built from source here. Swift Package Manager
// runs build tool plugins in a sandbox that blocks network access and writes
// outside a few predetermined locations, which `cargo` needs for both crate
// fetching and its target directory. See the discussion in
// https://github.com/fossasia/magic-epaper-app/issues/648.
//
// Instead the library is built ahead of time by `scripts/build_rust_xcframework.sh`
// and consumed here as a binary target. Run that script before building with
// Swift Package Manager. The CocoaPods path is unaffected and still builds the
// Rust code from source through cargokit.
let package = Package(
    name: "rust_lib_magicepaperapp",
    platforms: [
        .macOS("10.15")
    ],
    products: [
        .library(name: "rust-lib-magicepaperapp", targets: ["rust_lib_magicepaperapp"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "rust_lib_magicepaperapp",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .target(name: "rust_lib_magicepaperappFFI")
            ],
            cSettings: [
                .headerSearchPath("include/rust_lib_magicepaperapp")
            ]
        ),
        .binaryTarget(
            name: "rust_lib_magicepaperappFFI",
            path: "rust_lib_magicepaperapp.xcframework"
        )
    ]
)
