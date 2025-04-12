// swift-tools-version: 6.0

import PackageDescription

// Two implementations are provided for most types - a simd implementation
// on apple platforms, and a pure swift implementation on other platforms.
// When compiling on apple platforms, the swift implementation can be used
// by enabling SKIP_SIMD_IMPLEMENTATION define below.
//
var defines: [String] = [
	//"SKIP_SIMD_IMPLEMENTATION"
]

let swiftSettings: [SwiftSetting] = defines.map {
	.define($0)
}

let package = Package(
	name: "Cartesian",
	products: [
		.library(
			name: "Cartesian",
			targets: [
				"Cartesian"
			]
		),
	],
	dependencies: [
		.package(url: "https://github.com/mattcox/Units.git", branch: "main"),
	],
	targets: [
		.target(
			name: "Cartesian",
			dependencies: [
				"Units"
			],
			swiftSettings: swiftSettings
		),
		.testTarget(
			name: "CartesianTests",
			dependencies: [
				"Cartesian"
			],
			swiftSettings: swiftSettings
		),
	]
)
