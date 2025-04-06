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
	targets: [
		.target(
			name: "Cartesian"
		),
		.testTarget(
			name: "CartesianTests",
			dependencies: [
				"Cartesian"
			]
		),
	]
)
