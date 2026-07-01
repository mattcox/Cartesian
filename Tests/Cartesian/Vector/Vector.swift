//
//  Vector.swift
//  Cartesian
//
//  Created by Matt Cox on 30/06/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import Foundation
import Testing

@testable import Cartesian
import Units

// The generic `Vector` type is backed by `InlineArray` and is only available on
// the newest platforms. The Swift Testing macros cannot be combined with an
// `@available` attribute, so each test narrows availability at runtime with a
// `guard #available` instead.
//
@Suite("Vector (generic)")
struct VectorGenericTests {
/// Tests the default initializer, which is expected to create a zero vector.
///
	@Test("Default Initializer")
	func defaultInitializer() async throws {
		guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
		let v = Vector<3, Double>()
		#expect(v[0] == .zero)
		#expect(v[1] == .zero)
		#expect(v[2] == .zero)
		#expect(Vector<3, Double>.count == 3)
	}

/// Tests the two-component labeled initializers.
///
	@Test("Initializer (2 components)")
	func initializerTwoComponents() async throws {
		guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
		let xy = Vector<2, Double>(x: 3.0, y: 4.0)
		#expect(xy.x == 3.0)
		#expect(xy.y == 4.0)

		let uv = Vector<2, Double>(u: 5.0, v: 6.0)
		#expect(uv.u == 5.0)
		#expect(uv.v == 6.0)

		let unlabelled = Vector<2, Double>(7.0, 8.0)
		#expect(unlabelled.first == 7.0)
		#expect(unlabelled.second == 8.0)
	}

/// Tests the three-component labeled initializers and accessors.
///
	@Test("Initializer (3 components)")
	func initializerThreeComponents() async throws {
		guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
		let v = Vector<3, Double>(x: 1.0, y: 2.0, z: 3.0)
		#expect(v.x == 1.0)
		#expect(v.y == 2.0)
		#expect(v.z == 3.0)
		#expect(v.first == 1.0)
		#expect(v.second == 2.0)
		#expect(v.third == 3.0)
	}

/// Tests the four-component labeled initializers and accessors.
///
	@Test("Initializer (4 components)")
	func initializerFourComponents() async throws {
		guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
		let v = Vector<4, Double>(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
		#expect(v.x == 1.0)
		#expect(v.y == 2.0)
		#expect(v.z == 3.0)
		#expect(v.w == 4.0)
		#expect(v.fourth == 4.0)
	}

/// Tests that component setters mutate the stored value.
///
	@Test("Component setters")
	func componentSetters() async throws {
		guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
		var v = Vector<3, Double>(1.0, 2.0, 3.0)
		v.x = 10.0
		v.y = 20.0
		v.z = 30.0
		#expect(v[0] == 10.0)
		#expect(v[1] == 20.0)
		#expect(v[2] == 30.0)
	}

/// Tests the subscript getter and setter.
///
	@Test("Subscript get/set")
	func subscriptGetSet() async throws {
		guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
		var v = Vector<4, Double>()
		v[0] = 1.0
		v[3] = 4.0
		#expect(v[0] == 1.0)
		#expect(v[1] == 0.0)
		#expect(v[3] == 4.0)
	}

/// Tests initialization from a fixed-size Vector2/3/4 and the `fixed`
/// accessor round-trips back to the same values.
///
	@Test("Interop with fixed-size vectors")
	func fixedInterop() async throws {
		guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
		let two = Vector<2, Double>(Vector2(1.0, 2.0))
		#expect(two.fixed == Vector2(1.0, 2.0))

		let three = Vector<3, Double>(Vector3(1.0, 2.0, 3.0))
		#expect(three.fixed == Vector3(1.0, 2.0, 3.0))

		let four = Vector<4, Double>(Vector4(1.0, 2.0, 3.0, 4.0))
		#expect(four.fixed == Vector4(1.0, 2.0, 3.0, 4.0))
	}

/// Tests the SIMD accessor and init(simd:).
///
	@Test("SIMD interop")
	func simdInterop() async throws {
		guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
		let v = Vector<3, Double>(1.0, 2.0, 3.0)
		let simd = v.simd
		let restored = Vector<3, Double>(simd: simd)
		#expect(restored == v)
	}

/// Tests the collection initializer, which fills from the start and pads any
/// remaining components with zero.
///
	@Test("Collection initializer with padding")
	func collectionInitializer() async throws {
		guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
		let v = Vector<4, Double>([1.0, 2.0])
		#expect(v[0] == 1.0)
		#expect(v[1] == 2.0)
		#expect(v[2] == 0.0)
		#expect(v[3] == 0.0)
	}

/// Tests the array literal initializer, including zero-padding of shorter
/// literals.
///
	@Test("Array literal initializer")
	func arrayLiteralInitializer() async throws {
		guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
		let v: Vector<5, Double> = [1.0, 2.0, 3.0, 4.0, 5.0]
		#expect(v[0] == 1.0)
		#expect(v[4] == 5.0)

		let padded: Vector<4, Double> = [9.0, 8.0]
		#expect(padded[0] == 9.0)
		#expect(padded[1] == 8.0)
		#expect(padded[2] == 0.0)
		#expect(padded[3] == 0.0)
	}

/// Tests clear() resets all components to zero.
///
	@Test("clear()")
	func clear() async throws {
		guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
		var v = Vector<3, Double>(1.0, 2.0, 3.0)
		v.clear()
		#expect(v == Vector<3, Double>())
	}

/// Tests Equatable conformance.
///
	@Test("Equatable")
	func equatable() async throws {
		guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
		let a = Vector<3, Double>(1.0, 2.0, 3.0)
		let b = Vector<3, Double>(1.0, 2.0, 3.0)
		let c = Vector<3, Double>(1.0, 2.0, 4.0)
		#expect(a == b)
		#expect(a != c)
	}

/// Tests JSON encode/decode round-trip.
///
	@Test("Serialization")
	func serialization() async throws {
		guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
		let v = Vector<5, Double>(arrayLiteral: 1.0, -2.0, 3.5, 0.0, 42.0)
		let encoded = try JSONEncoder().encode(v)
		let decoded = try JSONDecoder().decode(Vector<5, Double>.self, from: encoded)
		#expect(decoded == v)
	}
}

// MARK: - Arithmetic

extension VectorGenericTests {
	@Suite("Arithmetic")
	struct Arithmetic {
	/// Tests component-wise addition and subtraction of two vectors.
	///
		@Test("vector +/- vector")
		func vectorAddSubtract() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let a = Vector<3, Double>(1.0, 2.0, 3.0)
			let b = Vector<3, Double>(4.0, 5.0, 6.0)
			#expect(a + b == Vector<3, Double>(5.0, 7.0, 9.0))
			#expect(b - a == Vector<3, Double>(3.0, 3.0, 3.0))
		}

	/// Tests scalar addition and subtraction (both operand orders).
	///
		@Test("vector +/- scalar")
		func scalarAddSubtract() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let a = Vector<3, Double>(1.0, 2.0, 3.0)
			#expect(a + 1.0 == Vector<3, Double>(2.0, 3.0, 4.0))
			#expect(1.0 + a == Vector<3, Double>(2.0, 3.0, 4.0))
			#expect(a - 1.0 == Vector<3, Double>(0.0, 1.0, 2.0))
			#expect(10.0 - a == Vector<3, Double>(9.0, 8.0, 7.0))
		}

	/// Tests component-wise and scalar multiplication and division.
	///
		@Test("multiplication and division")
		func multiplyDivide() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let a = Vector<3, Double>(2.0, 4.0, 6.0)
			let b = Vector<3, Double>(1.0, 2.0, 3.0)
			#expect(a * b == Vector<3, Double>(2.0, 8.0, 18.0))
			#expect(a / b == Vector<3, Double>(2.0, 2.0, 2.0))
			#expect(a * 2.0 == Vector<3, Double>(4.0, 8.0, 12.0))
			#expect(2.0 * a == Vector<3, Double>(4.0, 8.0, 12.0))
			#expect(a / 2.0 == Vector<3, Double>(1.0, 2.0, 3.0))
		}

	/// Tests the compound assignment operators.
	///
		@Test("compound assignment")
		func compoundAssignment() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			var v = Vector<3, Double>(1.0, 2.0, 3.0)
			v += Vector<3, Double>(1.0, 1.0, 1.0)
			#expect(v == Vector<3, Double>(2.0, 3.0, 4.0))
			v -= 1.0
			#expect(v == Vector<3, Double>(1.0, 2.0, 3.0))
			v *= 2.0
			#expect(v == Vector<3, Double>(2.0, 4.0, 6.0))
			v /= 2.0
			#expect(v == Vector<3, Double>(1.0, 2.0, 3.0))
		}

	/// Tests the unary negation operator.
	///
		@Test("negation")
		func negation() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let v = Vector<3, Double>(1.0, -2.0, 3.0)
			#expect(-v == Vector<3, Double>(-1.0, 2.0, -3.0))
		}

	/// Tests the reduction helpers: min, max, sum and average.
	///
		@Test("reductions")
		func reductions() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let v = Vector<4, Double>(1.0, 2.0, 3.0, 4.0)
			#expect(v.min() == 1.0)
			#expect(v.max() == 4.0)
			#expect(v.sum() == 10.0)
			#expect(v.average() == 2.5)
		}

	/// Tests component-wise static min/max and abs.
	///
		@Test("min/max/abs")
		func minMaxAbs() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let a = Vector<3, Double>(1.0, 5.0, -3.0)
			let b = Vector<3, Double>(4.0, 2.0, -1.0)
			#expect(Vector<3, Double>.min(a, b) == Vector<3, Double>(1.0, 2.0, -3.0))
			#expect(Vector<3, Double>.max(a, b) == Vector<3, Double>(4.0, 5.0, -1.0))
			#expect(a.abs() == Vector<3, Double>(1.0, 5.0, 3.0))
		}
	}
}

// MARK: - Geometry

extension VectorGenericTests {
	@Suite("Geometry")
	struct Geometry {
	/// Tests the dot product.
	///
		@Test("dot product")
		func dotProduct() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let a = Vector<3, Double>(1.0, 2.0, 3.0)
			let b = Vector<3, Double>(4.0, 5.0, 6.0)
			#expect(a.dot(b).isApproximatelyEqual(to: 32.0))
		}

	/// Tests the cross product for three-component vectors.
	///
		@Test("cross product")
		func crossProduct() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let x = Vector<3, Double>(1.0, 0.0, 0.0)
			let y = Vector<3, Double>(0.0, 1.0, 0.0)
			let z = x.cross(y)
			#expect(z[0].isApproximatelyEqual(to: 0.0))
			#expect(z[1].isApproximatelyEqual(to: 0.0))
			#expect(z[2].isApproximatelyEqual(to: 1.0))
		}

	/// Tests the magnitude getter.
	///
		@Test("magnitude")
		func magnitude() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let v = Vector<2, Double>(3.0, 4.0)
			#expect(v.magnitude.isApproximatelyEqual(to: 5.0))
		}

	/// Tests the magnitude setter, which rescales the vector to the requested
	/// length while preserving direction.
	///
		@Test("magnitude setter")
		func magnitudeSetter() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			var v = Vector<2, Double>(3.0, 4.0)
			v.magnitude = 10.0
			#expect(v[0].isApproximatelyEqual(to: 6.0))
			#expect(v[1].isApproximatelyEqual(to: 8.0))
		}

	/// Tests that normalized produces a unit vector in the same direction.
	///
		@Test("normalized")
		func normalized() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let v = Vector<3, Double>(0.0, 3.0, 4.0)
			let n = v.normalized
			#expect(n.magnitude.isApproximatelyEqual(to: 1.0))
			#expect(n[1].isApproximatelyEqual(to: 0.6))
			#expect(n[2].isApproximatelyEqual(to: 0.8))
		}

	/// Tests the mutating normalize() matches the computed property.
	///
		@Test("normalize()")
		func normalize() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			var v = Vector<3, Double>(0.0, 3.0, 4.0)
			let expected = v.normalized
			v.normalize()
			#expect(v == expected)
		}

	/// Tests euclidean distance and squared distance.
	///
		@Test("distance")
		func distance() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let a = Vector<3, Double>(0.0, 0.0, 0.0)
			let b = Vector<3, Double>(3.0, 4.0, 0.0)
			#expect(a.distance(to: b).isApproximatelyEqual(to: 5.0))
			#expect(a.squaredDistance(to: b).isApproximatelyEqual(to: 25.0))
		}

	/// Tests the angle between two vectors, measured from an implicit zero
	/// pivot.
	///
		@Test("angle between vectors")
		func angleBetween() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let from = Vector<2, Double>(1.0, 0.0)
			let to = Vector<2, Double>(0.0, 1.0)
			let angle = Vector<2, Double>.angle(from: from, to: to, by: nil)
			#expect(angle.radians.isApproximatelyEqual(to: Double.pi / 2.0))
		}

	/// Tests the angle between two vectors measured around an explicit pivot.
	///
		@Test("angle around a pivot")
		func angleAroundPivot() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let pivot = Vector<2, Double>(1.0, 1.0)
			let from = Vector<2, Double>(2.0, 1.0)
			let to = Vector<2, Double>(1.0, 2.0)
			let angle = Vector<2, Double>.angle(from: from, to: to, by: pivot)
			#expect(angle.radians.isApproximatelyEqual(to: Double.pi / 2.0))
		}

	/// Tests linear blending between two vectors.
	///
		@Test("blend")
		func blend() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let a = Vector<3, Double>(0.0, 0.0, 0.0)
			let b = Vector<3, Double>(10.0, 20.0, 30.0)
			let mid = Vector<3, Double>.blend(from: a, to: b, by: 0.5)
			#expect(mid == Vector<3, Double>(5.0, 10.0, 15.0))

			var mutable = a
			mutable.blend(to: b, by: 0.25)
			#expect(mutable == Vector<3, Double>(2.5, 5.0, 7.5))
		}

	/// Tests reflection about a surface normal.
	///
		@Test("reflection")
		func reflection() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let v = Vector<2, Double>(1.0, -1.0)
			let normal = Vector<2, Double>(0.0, 1.0)
			let reflected = v.reflection(withNormal: normal)
			#expect(reflected[0].isApproximatelyEqual(to: 1.0))
			#expect(reflected[1].isApproximatelyEqual(to: 1.0))
		}

	/// Tests that refraction with a matching index of refraction passes the
	/// (normalized) ray straight through.
	///
		@Test("refraction (index 1)")
		func refractionIndexOne() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let v = Vector<2, Double>(0.0, -1.0)
			let normal = Vector<2, Double>(0.0, 1.0)
			let refracted = v.refraction(withNormal: normal, indexOfRefraction: 1.0)
			#expect(refracted[0].isApproximatelyEqual(to: 0.0))
			#expect(refracted[1].isApproximatelyEqual(to: -1.0))
		}

	/// Tests that total internal reflection returns a zero vector.
	///
		@Test("refraction (total internal reflection)")
		func refractionTotalInternalReflection() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let v = Vector<2, Double>(1.0, -1.0)
			let normal = Vector<2, Double>(0.0, 1.0)
			let refracted = v.refraction(withNormal: normal, indexOfRefraction: 2.0)
			#expect(refracted == Vector<2, Double>())
		}

	/// Tests rotating a three-component vector by a quaternion, cross-checking
	/// against the fixed-size Vector3 result.
	///
		@Test("rotated(by: quaternion)")
		func rotatedByQuaternion() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let q = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let v = Vector<3, Double>(1.0, 0.0, 0.0)
			let rotated = v.rotated(by: q)
			let expected = q.rotate(vector: Vector3(1.0, 0.0, 0.0))
			#expect(rotated[0].isApproximatelyEqual(to: expected[0], absoluteTolerance: 1e-12))
			#expect(rotated[1].isApproximatelyEqual(to: expected[1]))
			#expect(rotated[2].isApproximatelyEqual(to: expected[2], absoluteTolerance: 1e-12))
		}
	}
}
