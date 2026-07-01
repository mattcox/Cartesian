//
//  Vector4.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import Foundation
import Testing

@testable import Cartesian
import Units

// The simd module (where available) provides additional testing, using it as
// functional benchmark to test against - the results from Cartesian are tested
// against the results from similar functions in the simd library.
//
#if canImport(simd)
import simd
#endif

@Suite("Vector4")
struct Vector4Tests {
/// Tests the default initializer, which is expected to create a zero vector.
///
	@Test("Default Initializer")
	func defaultInitializer() async throws {
		let v = Vector4<Double>()
		#expect(v.x == .zero)
		#expect(v.y == .zero)
		#expect(v.z == .zero)
		#expect(v.w == .zero)
	}

/// Tests the labeled x/y/z/w initializer.
///
	@Test("Initializer (x:y:z:w:)")
	func initializerXYZW() async throws {
		let v = Vector4<Double>(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
		#expect(v.x == 1.0)
		#expect(v.y == 2.0)
		#expect(v.z == 3.0)
		#expect(v.w == 4.0)
	}

/// Tests the unlabeled positional initializer.
///
	@Test("Initializer (_:_:_:_:)")
	func initializerPositional() async throws {
		let v = Vector4<Double>(5.0, 6.0, 7.0, 8.0)
		#expect(v.x == 5.0)
		#expect(v.y == 6.0)
		#expect(v.z == 7.0)
		#expect(v.w == 8.0)
	}

/// Tests the array literal initializer.
///
	@Test("Initializer (arrayLiteral:)")
	func initializerArrayLiteral() async throws {
		let v: Vector4<Double> = [9.0, 10.0, 11.0, 12.0]
		#expect(v.x == 9.0)
		#expect(v.y == 10.0)
		#expect(v.z == 11.0)
		#expect(v.w == 12.0)
	}

/// Tests that x/y/z/w and first/second/third/fourth alias the same storage.
///
	@Test("Component Accessors Alias")
	func componentAccessors() async throws {
		let v = Vector4<Double>(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
		#expect(v.x == v.first)
		#expect(v.y == v.second)
		#expect(v.z == v.third)
		#expect(v.w == v.fourth)
	}

/// Tests that setters on all aliases update the same underlying storage.
///
	@Test("Component Setter Aliases")
	func componentSetterAliases() async throws {
		var v = Vector4<Double>(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
		v.first = 10.0
		#expect(v.x == 10.0)
		v.second = 20.0
		#expect(v.y == 20.0)
		v.third = 30.0
		#expect(v.z == 30.0)
		v.fourth = 40.0
		#expect(v.w == 40.0)
	}

/// Tests JSON round-trip encoding and decoding.
///
	@Test("Codable")
	func codable() async throws {
		let original = Vector4<Double>(x: 1.5, y: -2.5, z: 3.75, w: -4.25)
		let encoded = try JSONEncoder().encode(original)
		let decoded = try JSONDecoder().decode(Vector4<Double>.self, from: encoded)
		#expect(decoded.x == original.x)
		#expect(decoded.y == original.y)
		#expect(decoded.z == original.z)
		#expect(decoded.w == original.w)
	}

/// Tests equality and inequality.
///
	@Test("Equatable")
	func equatable() async throws {
		let a = Vector4<Double>(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
		let b = Vector4<Double>(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
		let c = Vector4<Double>(x: 1.0, y: 2.0, z: 3.0, w: 4.0.nextUp)
		#expect(a == b)
		#expect(a != c)
	}
}

// MARK: - VectorMath

extension Vector4Tests {
	@Suite("VectorMath")
	struct VectorMathSuite {
	/// Tests component-wise addition.
	///
	/// (1, 2, 3, 4) + (5, 6, 7, 8) = (6, 8, 10, 12)
	///
		@Test("Addition")
		func addition() async throws {
			let lhs = Vector4<Double>(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
			let rhs = Vector4<Double>(x: 5.0, y: 6.0, z: 7.0, w: 8.0)
			let result = lhs + rhs
			#expect(result.x == 6.0)
			#expect(result.y == 8.0)
			#expect(result.z == 10.0)
			#expect(result.w == 12.0)

		#if canImport(simd)
			let simdResult = simd_double4(1.0, 2.0, 3.0, 4.0) + simd_double4(5.0, 6.0, 7.0, 8.0)
			#expect(result.x == simdResult.x)
			#expect(result.y == simdResult.y)
			#expect(result.z == simdResult.z)
			#expect(result.w == simdResult.w)
		#endif
		}

	/// Tests mutating addition.
	///
		@Test("Addition Assignment")
		func additionAssignment() async throws {
			var lhs = Vector4<Double>(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
			lhs += Vector4<Double>(x: 5.0, y: 6.0, z: 7.0, w: 8.0)
			#expect(lhs.x == 6.0)
			#expect(lhs.y == 8.0)
			#expect(lhs.z == 10.0)
			#expect(lhs.w == 12.0)
		}

	/// Tests component-wise subtraction.
	///
	/// (6, 8, 10, 12) - (1, 2, 3, 4) = (5, 6, 7, 8)
	///
		@Test("Subtraction")
		func subtraction() async throws {
			let lhs = Vector4<Double>(x: 6.0, y: 8.0, z: 10.0, w: 12.0)
			let rhs = Vector4<Double>(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
			let result = lhs - rhs
			#expect(result.x == 5.0)
			#expect(result.y == 6.0)
			#expect(result.z == 7.0)
			#expect(result.w == 8.0)

		#if canImport(simd)
			let simdResult = simd_double4(6.0, 8.0, 10.0, 12.0) - simd_double4(1.0, 2.0, 3.0, 4.0)
			#expect(result.x == simdResult.x)
			#expect(result.y == simdResult.y)
			#expect(result.z == simdResult.z)
			#expect(result.w == simdResult.w)
		#endif
		}

	/// Tests mutating subtraction.
	///
		@Test("Subtraction Assignment")
		func subtractionAssignment() async throws {
			var lhs = Vector4<Double>(x: 6.0, y: 8.0, z: 10.0, w: 12.0)
			lhs -= Vector4<Double>(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
			#expect(lhs.x == 5.0)
			#expect(lhs.y == 6.0)
			#expect(lhs.z == 7.0)
			#expect(lhs.w == 8.0)
		}

	/// Tests component-wise multiplication.
	///
	/// (2, 3, 4, 5) * (6, 7, 8, 9) = (12, 21, 32, 45)
	///
		@Test("Multiplication (vector)")
		func multiplicationVector() async throws {
			let lhs = Vector4<Double>(x: 2.0, y: 3.0, z: 4.0, w: 5.0)
			let rhs = Vector4<Double>(x: 6.0, y: 7.0, z: 8.0, w: 9.0)
			let result = lhs * rhs
			#expect(result.x == 12.0)
			#expect(result.y == 21.0)
			#expect(result.z == 32.0)
			#expect(result.w == 45.0)
		}

	/// Tests mutating component-wise multiplication.
	///
		@Test("Multiplication Assignment (vector)")
		func multiplicationAssignmentVector() async throws {
			var lhs = Vector4<Double>(x: 2.0, y: 3.0, z: 4.0, w: 5.0)
			lhs *= Vector4<Double>(x: 6.0, y: 7.0, z: 8.0, w: 9.0)
			#expect(lhs.x == 12.0)
			#expect(lhs.y == 21.0)
			#expect(lhs.z == 32.0)
			#expect(lhs.w == 45.0)
		}

	/// Tests scalar multiplication: vector * scalar and scalar * vector.
	///
	/// (1, 2, 3, 4) * 2 = (2, 4, 6, 8)
	///
		@Test("Multiplication (scalar)")
		func multiplicationScalar() async throws {
			let v = Vector4<Double>(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
			let result1 = v * 2.0
			let result2 = 2.0 * v
			#expect(result1.x == 2.0)
			#expect(result1.y == 4.0)
			#expect(result1.z == 6.0)
			#expect(result1.w == 8.0)
			#expect(result2.x == 2.0)
			#expect(result2.y == 4.0)
			#expect(result2.z == 6.0)
			#expect(result2.w == 8.0)
		}

	/// Tests component-wise division.
	///
	/// (12, 21, 32, 45) / (2, 3, 4, 5) = (6, 7, 8, 9)
	///
		@Test("Division (vector)")
		func divisionVector() async throws {
			let lhs = Vector4<Double>(x: 12.0, y: 21.0, z: 32.0, w: 45.0)
			let rhs = Vector4<Double>(x: 2.0, y: 3.0, z: 4.0, w: 5.0)
			let result = lhs / rhs
			#expect(result.x == 6.0)
			#expect(result.y == 7.0)
			#expect(result.z == 8.0)
			#expect(result.w == 9.0)
		}

	/// Tests mutating component-wise division.
	///
		@Test("Division Assignment (vector)")
		func divisionAssignmentVector() async throws {
			var lhs = Vector4<Double>(x: 12.0, y: 21.0, z: 32.0, w: 45.0)
			lhs /= Vector4<Double>(x: 2.0, y: 3.0, z: 4.0, w: 5.0)
			#expect(lhs.x == 6.0)
			#expect(lhs.y == 7.0)
			#expect(lhs.z == 8.0)
			#expect(lhs.w == 9.0)
		}

	/// Tests prefix negation.
	///
	/// -(1, -2, 3, -4) = (-1, 2, -3, 4)
	///
		@Test("Negation")
		func negation() async throws {
			let v = Vector4<Double>(x: 1.0, y: -2.0, z: 3.0, w: -4.0)
			let result = -v
			#expect(result.x == -1.0)
			#expect(result.y == 2.0)
			#expect(result.z == -3.0)
			#expect(result.w == 4.0)
		}

	/// Tests min() — the smallest component.
	///
		@Test("min()")
		func minComponent() async throws {
			let v = Vector4<Double>(x: 7.0, y: 3.0, z: 5.0, w: 1.0)
			#expect(v.min() == 1.0)
		}

	/// Tests max() — the largest component.
	///
		@Test("max()")
		func maxComponent() async throws {
			let v = Vector4<Double>(x: 7.0, y: 3.0, z: 5.0, w: 1.0)
			#expect(v.max() == 7.0)
		}

	/// Tests average() — mean of all components.
	///
	/// (2, 4, 6, 8) → 5.0
	///
		@Test("average()")
		func average() async throws {
			let v = Vector4<Double>(x: 2.0, y: 4.0, z: 6.0, w: 8.0)
			#expect(v.average() == 5.0)
		}

	/// Tests sum() — sum of all components.
	///
	/// (1, 2, 3, 4) → 10.0
	///
		@Test("sum()")
		func sum() async throws {
			let v = Vector4<Double>(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
			#expect(v.sum() == 10.0)
		}
	}
}

// MARK: - Componentwise min/max/abs

extension Vector4Tests {
	@Suite("Componentwise")
	struct ComponentwiseSuite {
	/// Tests Vector4.min(_:_:).
	///
	/// min((1, 5, 3, 7), (4, 2, 6, 0)) = (1, 2, 3, 0)
	///
		@Test("min(_:_:)")
		func componentwiseMin() async throws {
			let a = Vector4<Double>(x: 1.0, y: 5.0, z: 3.0, w: 7.0)
			let b = Vector4<Double>(x: 4.0, y: 2.0, z: 6.0, w: 0.0)
			let result = Vector4<Double>.min(a, b)
			#expect(result.x == 1.0)
			#expect(result.y == 2.0)
			#expect(result.z == 3.0)
			#expect(result.w == 0.0)
		}

	/// Tests Vector4.max(_:_:).
	///
	/// max((1, 5, 3, 7), (4, 2, 6, 0)) = (4, 5, 6, 7)
	///
		@Test("max(_:_:)")
		func componentwiseMax() async throws {
			let a = Vector4<Double>(x: 1.0, y: 5.0, z: 3.0, w: 7.0)
			let b = Vector4<Double>(x: 4.0, y: 2.0, z: 6.0, w: 0.0)
			let result = Vector4<Double>.max(a, b)
			#expect(result.x == 4.0)
			#expect(result.y == 5.0)
			#expect(result.z == 6.0)
			#expect(result.w == 7.0)
		}

	/// Tests abs() — makes all components non-negative.
	///
	/// (-1, 2, -3, 4).abs() = (1, 2, 3, 4)
	///
		@Test("abs()")
		func componentwiseAbs() async throws {
			let v = Vector4<Double>(x: -1.0, y: 2.0, z: -3.0, w: 4.0)
			let result = v.abs()
			#expect(result.x == 1.0)
			#expect(result.y == 2.0)
			#expect(result.z == 3.0)
			#expect(result.w == 4.0)
		}
	}
}

// MARK: - DotProduct

extension Vector4Tests {
	@Suite("DotProduct")
	struct DotProductSuite {
	/// Perpendicular unit vectors in 4D must have dot product 0.
	///
		@Test("Perpendicular vectors")
		func perpendicular() async throws {
			let a = Vector4<Double>(x: 1.0, y: 0.0, z: 0.0, w: 0.0)
			let b = Vector4<Double>(x: 0.0, y: 1.0, z: 0.0, w: 0.0)
			#expect(a.dot(b).isApproximatelyEqual(to: 0.0))
		}

	/// A unit axis vector dotted with itself must equal 1.
	///
		@Test("Parallel unit vectors")
		func parallel() async throws {
			let a = Vector4<Double>(x: 1.0, y: 0.0, z: 0.0, w: 0.0)
			#expect(a.dot(a).isApproximatelyEqual(to: 1.0))
		}

	/// Concrete value: (1, 2, 3, 4) · (5, 6, 7, 8)
	/// = 5 + 12 + 21 + 32 = 70
	///
		@Test("Concrete values")
		func concreteValues() async throws {
			let a = Vector4<Double>(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
			let b = Vector4<Double>(x: 5.0, y: 6.0, z: 7.0, w: 8.0)
			#expect(a.dot(b).isApproximatelyEqual(to: 70.0))

		#if canImport(simd)
			let simdResult = simd_dot(simd_double4(1.0, 2.0, 3.0, 4.0), simd_double4(5.0, 6.0, 7.0, 8.0))
			#expect(a.dot(b) == simdResult)
		#endif
		}

	/// W component participates fully in dot product.
	///
	/// (0, 0, 0, 3) · (0, 0, 0, 4) = 12
	///
		@Test("W component participates")
		func wComponentParticipates() async throws {
			let a = Vector4<Double>(x: 0.0, y: 0.0, z: 0.0, w: 3.0)
			let b = Vector4<Double>(x: 0.0, y: 0.0, z: 0.0, w: 4.0)
			#expect(a.dot(b).isApproximatelyEqual(to: 12.0))
		}
	}
}

// MARK: - Magnitude

extension Vector4Tests {
	@Suite("Magnitude")
	struct MagnitudeSuite {
	/// (0, 0, 3, 4) has magnitude 5 (3-4-5 triple in z-w plane).
	///
		@Test("Known value")
		func magnitudeKnownValue() async throws {
			let v = Vector4<Double>(x: 0.0, y: 0.0, z: 3.0, w: 4.0)
			#expect(v.magnitude.isApproximatelyEqual(to: 5.0))

		#if canImport(simd)
			#expect(v.magnitude.isApproximatelyEqual(to: simd_length(simd_double4(0.0, 0.0, 3.0, 4.0))))
		#endif
		}

	/// (1, 1, 1, 1) has magnitude sqrt(4) = 2.
	///
		@Test("(1, 1, 1, 1) magnitude")
		func magnitudeUniform() async throws {
			let v = Vector4<Double>(x: 1.0, y: 1.0, z: 1.0, w: 1.0)
			#expect(v.magnitude.isApproximatelyEqual(to: 2.0))
		}

	/// Setting magnitude scales the vector while preserving direction.
	///
		@Test("Set magnitude")
		func setMagnitude() async throws {
			var v = Vector4<Double>(x: 0.0, y: 0.0, z: 3.0, w: 4.0)
			v.magnitude = 10.0
			#expect(v.magnitude.isApproximatelyEqual(to: 10.0))
			#expect(v.x.isApproximatelyEqual(to: 0.0))
			#expect(v.y.isApproximatelyEqual(to: 0.0))
			#expect(v.z.isApproximatelyEqual(to: 6.0))
			#expect(v.w.isApproximatelyEqual(to: 8.0))
		}
	}
}

// MARK: - Normalized

extension Vector4Tests {
	@Suite("Normalized")
	struct NormalizedSuite {
	/// Normalizing a non-zero vector must produce magnitude 1.
	///
		@Test("Magnitude is 1.0")
		func magnitudeIsOne() async throws {
			let v = Vector4<Double>(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
			let n = v.normalized
			#expect(n.magnitude.isApproximatelyEqual(to: 1.0))
		}

	/// Normalizing an axis-aligned vector gives that unit axis vector.
	///
		@Test("Axis-aligned normalization")
		func axisAligned() async throws {
			let v = Vector4<Double>(x: 0.0, y: 0.0, z: 0.0, w: 7.0)
			let n = v.normalized
			#expect(n.x.isApproximatelyEqual(to: 0.0))
			#expect(n.y.isApproximatelyEqual(to: 0.0))
			#expect(n.z.isApproximatelyEqual(to: 0.0))
			#expect(n.w.isApproximatelyEqual(to: 1.0))
		}

	/// Mutating normalize() must produce the same result as the computed property.
	///
		@Test("Mutating normalize()")
		func mutatingNormalize() async throws {
			var v = Vector4<Double>(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
			let expected = v.normalized
			v.normalize()
			#expect(v.x.isApproximatelyEqual(to: expected.x))
			#expect(v.y.isApproximatelyEqual(to: expected.y))
			#expect(v.z.isApproximatelyEqual(to: expected.z))
			#expect(v.w.isApproximatelyEqual(to: expected.w))
		}
	}
}

// MARK: - EuclideanDistance

extension Vector4Tests {
	@Suite("EuclideanDistance")
	struct EuclideanDistanceSuite {
	/// Distance from (0,0,0,0) to (0,0,3,4) is 5.
	///
		@Test("distance")
		func distance() async throws {
			let a = Vector4<Double>(x: 0.0, y: 0.0, z: 0.0, w: 0.0)
			let b = Vector4<Double>(x: 0.0, y: 0.0, z: 3.0, w: 4.0)
			#expect(a.distance(to: b).isApproximatelyEqual(to: 5.0))
		}

	/// Squared distance from (0,0,0,0) to (0,0,3,4) is 25.
	///
		@Test("squaredDistance")
		func squaredDistance() async throws {
			let a = Vector4<Double>(x: 0.0, y: 0.0, z: 0.0, w: 0.0)
			let b = Vector4<Double>(x: 0.0, y: 0.0, z: 3.0, w: 4.0)
			#expect(a.squaredDistance(to: b).isApproximatelyEqual(to: 25.0))
		}

	/// Distance from (1,1,1,1) to (1,1,4,5) is 5.
	///
		@Test("distance (offset)")
		func distanceOffset() async throws {
			let a = Vector4<Double>(x: 1.0, y: 1.0, z: 1.0, w: 1.0)
			let b = Vector4<Double>(x: 1.0, y: 1.0, z: 4.0, w: 5.0)
			#expect(a.distance(to: b).isApproximatelyEqual(to: 5.0))
		}
	}
}

// MARK: - Blendable

extension Vector4Tests {
	@Suite("Blendable")
	struct BlendableSuite {
	/// blend(amount: 0) must return the from vector.
	///
		@Test("blend 0.0 = from")
		func blendZero() async throws {
			let from = Vector4<Double>(x: 0.0, y: 0.0, z: 0.0, w: 0.0)
			let to = Vector4<Double>(x: 10.0, y: 20.0, z: 30.0, w: 40.0)
			let result = Vector4<Double>.blend(from: from, to: to, by: 0.0)
			#expect(result.x.isApproximatelyEqual(to: 0.0))
			#expect(result.y.isApproximatelyEqual(to: 0.0))
			#expect(result.z.isApproximatelyEqual(to: 0.0))
			#expect(result.w.isApproximatelyEqual(to: 0.0))
		}

	/// blend(amount: 1) must return the to vector.
	///
		@Test("blend 1.0 = to")
		func blendOne() async throws {
			let from = Vector4<Double>(x: 0.0, y: 0.0, z: 0.0, w: 0.0)
			let to = Vector4<Double>(x: 10.0, y: 20.0, z: 30.0, w: 40.0)
			let result = Vector4<Double>.blend(from: from, to: to, by: 1.0)
			#expect(result.x.isApproximatelyEqual(to: 10.0))
			#expect(result.y.isApproximatelyEqual(to: 20.0))
			#expect(result.z.isApproximatelyEqual(to: 30.0))
			#expect(result.w.isApproximatelyEqual(to: 40.0))
		}

	/// blend(amount: 0.5) must return the midpoint.
	///
		@Test("blend 0.5 = midpoint")
		func blendHalf() async throws {
			let from = Vector4<Double>(x: 0.0, y: 0.0, z: 0.0, w: 0.0)
			let to = Vector4<Double>(x: 10.0, y: 20.0, z: 30.0, w: 40.0)
			let result = Vector4<Double>.blend(from: from, to: to, by: 0.5)
			#expect(result.x.isApproximatelyEqual(to: 5.0))
			#expect(result.y.isApproximatelyEqual(to: 10.0))
			#expect(result.z.isApproximatelyEqual(to: 15.0))
			#expect(result.w.isApproximatelyEqual(to: 20.0))
		}
	}
}

// MARK: - AngleMeasurable

extension Vector4Tests {
	@Suite("AngleMeasurable")
	struct AngleMeasurableSuite {
	/// The angle between identical unit vectors is 0°.
	///
		@Test("Angle 0 degrees")
		func angleZeroDegrees() async throws {
			let v = Vector4<Double>(x: 1.0, y: 0.0, z: 0.0, w: 0.0)
			let angle = Vector4<Double>.angle(from: v, to: v, by: nil)
			#expect(angle.radians.isApproximatelyEqual(to: 0.0))
		}

	/// The angle between +X and +Y (4D) is 90° (π/2 radians).
	///
		@Test("Angle 90 degrees")
		func angleNinetyDegrees() async throws {
			let a = Vector4<Double>(x: 1.0, y: 0.0, z: 0.0, w: 0.0)
			let b = Vector4<Double>(x: 0.0, y: 1.0, z: 0.0, w: 0.0)
			let angle = Vector4<Double>.angle(from: a, to: b, by: nil)
			#expect(angle.radians.isApproximatelyEqual(to: .pi / 2, relativeTolerance: 1e-10))
		}

	/// The angle between +X and -X (4D) is 180° (π radians).
	///
		@Test("Angle 180 degrees")
		func angleOneEightyDegrees() async throws {
			let a = Vector4<Double>(x: 1.0, y: 0.0, z: 0.0, w: 0.0)
			let b = Vector4<Double>(x: -1.0, y: 0.0, z: 0.0, w: 0.0)
			let angle = Vector4<Double>.angle(from: a, to: b, by: nil)
			#expect(angle.radians.isApproximatelyEqual(to: .pi, relativeTolerance: 1e-10))
		}
	}
}

// MARK: - Reflection

extension Vector4Tests {
	@Suite("Reflection")
	struct ReflectionSuite {
	/// Reflecting (1, -1, 0, 0) off a surface with normal (0, 1, 0, 0) gives (1, 1, 0, 0).
	///
		@Test("Reflect off surface")
		func reflectOffSurface() async throws {
			let ray = Vector4<Double>(x: 1.0, y: -1.0, z: 0.0, w: 0.0)
			let normal = Vector4<Double>(x: 0.0, y: 1.0, z: 0.0, w: 0.0)
			let result = ray.reflection(withNormal: normal)
			#expect(result.x.isApproximatelyEqual(to: 1.0))
			#expect(result.y.isApproximatelyEqual(to: 1.0))
			#expect(result.z.isApproximatelyEqual(to: 0.0))
			#expect(result.w.isApproximatelyEqual(to: 0.0))
		}

	/// Reflecting (0, -1, 0, 0) straight at normal (0, 1, 0, 0) gives (0, 1, 0, 0).
	///
		@Test("Straight-axis reflection")
		func straightAxisReflection() async throws {
			let ray = Vector4<Double>(x: 0.0, y: -1.0, z: 0.0, w: 0.0)
			let normal = Vector4<Double>(x: 0.0, y: 1.0, z: 0.0, w: 0.0)
			let result = ray.reflection(withNormal: normal)
			#expect(result.x.isApproximatelyEqual(to: 0.0))
			#expect(result.y.isApproximatelyEqual(to: 1.0))
			#expect(result.z.isApproximatelyEqual(to: 0.0))
			#expect(result.w.isApproximatelyEqual(to: 0.0))
		}
	}
}

// MARK: - Refraction

extension Vector4Tests {
	@Suite("Refraction")
	struct RefractionSuite {
	/// Total internal reflection: steep angle with high IOR returns zero vector.
	///
		@Test("Total internal reflection returns zero")
		func totalInternalReflection() async throws {
			let angle: Double = 70.0 * .pi / 180.0
			let ray = Vector4<Double>(x: Double.sin(angle), y: -Double.cos(angle), z: 0.0, w: 0.0)
			let normal = Vector4<Double>(x: 0.0, y: 1.0, z: 0.0, w: 0.0)
			let result = ray.refraction(withNormal: normal, indexOfRefraction: 1.5)
			#expect(result.x.isApproximatelyEqual(to: 0.0))
			#expect(result.y.isApproximatelyEqual(to: 0.0))
			#expect(result.z.isApproximatelyEqual(to: 0.0))
			#expect(result.w.isApproximatelyEqual(to: 0.0))
		}

	/// IOR = 1.0 (same medium) passes the ray straight through.
	///
		@Test("No-op refraction (IOR = 1.0)")
		func noOpRefraction() async throws {
			let ray = Vector4<Double>(x: 0.0, y: -1.0, z: 0.0, w: 0.0)
			let normal = Vector4<Double>(x: 0.0, y: 1.0, z: 0.0, w: 0.0)
			let result = ray.refraction(withNormal: normal, indexOfRefraction: 1.0)
			#expect(result.x.isApproximatelyEqual(to: 0.0))
			#expect(result.y.isApproximatelyEqual(to: -1.0))
			#expect(result.z.isApproximatelyEqual(to: 0.0))
			#expect(result.w.isApproximatelyEqual(to: 0.0))
		}
	}
}

// MARK: - SIMD

extension Vector4Tests {
	@Suite("SIMDConvertible")
	struct SIMDSuite {
	/// The .simd property must round-trip through the SIMD representation.
	///
		@Test("SIMD round-trip")
		func simdRoundTrip() async throws {
			let v = Vector4<Double>(x: 1.5, y: -2.5, z: 3.75, w: -4.25)
			let simdValue = v.simd
			let reconstructed = Vector4<Double>(simdValue)
			#expect(reconstructed.x == v.x)
			#expect(reconstructed.y == v.y)
			#expect(reconstructed.z == v.z)
			#expect(reconstructed.w == v.w)
		}

	#if canImport(simd)
	/// The .simd value must agree with the equivalent simd_double4.
	///
		@Test("SIMD matches simd_double4")
		func simdMatchesSIMD4() async throws {
			let v = Vector4<Double>(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
			let reference = simd_double4(1.0, 2.0, 3.0, 4.0)
			#expect(v.simd.x == reference.x)
			#expect(v.simd.y == reference.y)
			#expect(v.simd.z == reference.z)
			#expect(v.simd.w == reference.w)
		}
	#endif
	}
}
