# 🧭 Cartesian

<p align="center">
    <img src="https://img.shields.io/badge/Swift-orange.svg" alt="Swift" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/swiftpm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
</p>

Welcome to **Cartesian**, a Swift package for working with vectors and matrices in a coordinate-based mathematical space.

**Cartesian** offers SIMD-backed vectors, matrices, and quaternions, utilizing LLVM-accelerated simd operations for performance where supported.

Vectors, matrices and points work with both floating-point and integer components, so you can use `Vector3<Double>` for geometry and `Vector3<Int>` for grid or index math from the same API:

```swift
let a = Vector3<Int>(1, 2, 3)
let b = Vector3<Int>(4, 5, 6)
let sum = a + b            // (5, 7, 9)
let dot = a.dot(b)         // 32

let position = Vector3<Double>(3, 4, 0)
let length = position.magnitude   // 5.0
```

Operations that require real-valued math — such as `magnitude`, `normalized`, rotation, inverse and projection — are available only for floating-point (`Real`) components. Everything else, including construction, arithmetic, dot and cross products, matrix multiplication and transpose, works for any component type.

The component type is described by the `VectorComponent` protocol, which is already conformed by the standard floating-point and signed integer types. Conform your own scalar type to `VectorComponent` to store it in a vector or matrix.

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

If you’d like to use Cartesian within an iOS, macOS, watchOS, tvOS or visionOS app, then use Xcode’s `File > Add Packages...` menu command to add it to your project.

Import Cartesian wherever you’d like to use it:
```swift
import Cartesian
```
