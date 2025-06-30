// swift-tools-version: 6.0

import PackageDescription

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
		.package(url: "https://github.com/apple/swift-numerics", from: Version(1, 0, 0))
	],
	targets: [
		.target(
			name: "Cartesian",
			dependencies: [
				.product(name: "RealModule", package: "swift-numerics"),
				.product(name: "Units", package: "Units")
			]
		),
		.testTarget(
			name: "CartesianTests",
			dependencies: [
				"Cartesian"
			]
		),
	]
)
