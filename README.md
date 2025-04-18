# 🧭 Cartesian

<p align="center">
    <img src="https://img.shields.io/badge/Swift-orange.svg" alt="Swift" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/swiftpm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
</p>

Welcome to **Cartesian**, a Swift package for working with vectors and matrices in a coordinate-based mathematical space.

**Cartesian** offers SIMD-backed vectors and matrices, utilizing LLVM-accelerated simd operations for performance where supported.

## Installation

Cartesian is distributed using the [Swift Package Manager](https://swift.org/package-manager). To install it within another Swift package, add it as a dependency within your `Package.swift` manifest:

```swift
let package = Package(
    // . . .
    dependencies: [
        .package(url: "https://github.com/mattcox/Cartesian.git", branch: "main")
    ],
    // . . .
)
```

If you’d like to use Cartesian within an iOS, macOS, watchOS or tvOS app, then use Xcode’s `File > Add Packages...` menu command to add it to your project.

Import Cartesian wherever you’d like to use it:
```swift
import Cartesian
```
