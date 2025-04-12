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
	],
	targets: [
		.target(
			name: "Cartesian",
			dependencies: [
				"Units"
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
