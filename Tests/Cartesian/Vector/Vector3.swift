//
//  Vector3.swift
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

@Suite("Vector3")
struct Vector3Tests {
/// Tests the default initializer, which is expected to create a zero vector.
///
	@Test("Default Initializer")
	func defaultInitializer() async throws {
		let v = Vector3<Double>()
		#expect(v.x == .zero)
		#expect(v.y == .zero)
		#expect(v.z == .zero)
	}

/// Tests the labeled x/y/z initializer.
///
	@Test("Initializer (x:y:z:)")
	func initializerXYZ() async throws {
		let v = Vector3<Double>(x: 1.0, y: 2.0, z: 3.0)
		#expect(v.x == 1.0)
		#expect(v.y == 2.0)
		#expect(v.z == 3.0)
	}

/// Tests the unlabeled positional initializer.
///
	@Test("Initializer (_:_:_:)")
	func initializerPositional() async throws {
		let v = Vector3<Double>(4.0, 5.0, 6.0)
		#expect(v.x == 4.0)
		#expect(v.y == 5.0)
		#expect(v.z == 6.0)
	}

/// Tests the array literal initializer.
///
	@Test("Initializer (arrayLiteral:)")
	func initializerArrayLiteral() async throws {
		let v: Vector3<Double> = [7.0, 8.0, 9.0]
		#expect(v.x == 7.0)
		#expect(v.y == 8.0)
		#expect(v.z == 9.0)
	}

/// Tests that x/y/z and first/second/third alias the same storage.
///
	@Test("Component Accessors Alias")
	func componentAccessors() async throws {
		let v = Vector3<Double>(x: 1.0, y: 2.0, z: 3.0)
		#expect(v.x == v.first)
		#expect(v.y == v.second)
		#expect(v.z == v.third)
	}

/// Tests that setters on all aliases update the same underlying storage.
///
	@Test("Component Setter Aliases")
	func componentSetterAliases() async throws {
		var v = Vector3<Double>(x: 1.0, y: 2.0, z: 3.0)
		v.first = 10.0
		#expect(v.x == 10.0)
		v.second = 20.0
		#expect(v.y == 20.0)
		v.third = 30.0
		#expect(v.z == 30.0)
	}

/// Tests JSON round-trip encoding and decoding.
///
	@Test("Codable")
	func codable() async throws {
		let original = Vector3<Double>(x: 1.5, y: -2.5, z: 3.75)
		let encoded = try JSONEncoder().encode(original)
		let decoded = try JSONDecoder().decode(Vector3<Double>.self, from: encoded)
		#expect(decoded.x == original.x)
		#expect(decoded.y == original.y)
		#expect(decoded.z == original.z)
	}

/// Tests equality and inequality.
///
	@Test("Equatable")
	func equatable() async throws {
		let a = Vector3<Double>(x: 1.0, y: 2.0, z: 3.0)
		let b = Vector3<Double>(x: 1.0, y: 2.0, z: 3.0)
		let c = Vector3<Double>(x: 1.0, y: 2.0, z: 3.0.nextUp)
		#expect(a == b)
		#expect(a != c)
	}
}

// MARK: - VectorMath

extension Vector3Tests {
	@Suite("VectorMath")
	struct VectorMathSuite {
	/// Tests component-wise addition.
	///
	/// (1, 2, 3) + (4, 5, 6) = (5, 7, 9)
	///
		@Test("Addition")
		func addition() async throws {
			let lhs = Vector3<Double>(x: 1.0, y: 2.0, z: 3.0)
			let rhs = Vector3<Double>(x: 4.0, y: 5.0, z: 6.0)
			let result = lhs + rhs
			#expect(result.x == 5.0)
			#expect(result.y == 7.0)
			#expect(result.z == 9.0)

		#if canImport(simd)
			let simdResult = simd_double3(1.0, 2.0, 3.0) + simd_double3(4.0, 5.0, 6.0)
			#expect(result.x == simdResult.x)
			#expect(result.y == simdResult.y)
			#expect(result.z == simdResult.z)
		#endif
		}

	/// Tests mutating addition.
	///
		@Test("Addition Assignment")
		func additionAssignment() async throws {
			var lhs = Vector3<Double>(x: 1.0, y: 2.0, z: 3.0)
			lhs += Vector3<Double>(x: 4.0, y: 5.0, z: 6.0)
			#expect(lhs.x == 5.0)
			#expect(lhs.y == 7.0)
			#expect(lhs.z == 9.0)
		}

	/// Tests component-wise subtraction.
	///
	/// (5, 7, 9) - (1, 2, 3) = (4, 5, 6)
	///
		@Test("Subtraction")
		func subtraction() async throws {
			let lhs = Vector3<Double>(x: 5.0, y: 7.0, z: 9.0)
			let rhs = Vector3<Double>(x: 1.0, y: 2.0, z: 3.0)
			let result = lhs - rhs
			#expect(result.x == 4.0)
			#expect(result.y == 5.0)
			#expect(result.z == 6.0)

		#if canImport(simd)
			let simdResult = simd_double3(5.0, 7.0, 9.0) - simd_double3(1.0, 2.0, 3.0)
			#expect(result.x == simdResult.x)
			#expect(result.y == simdResult.y)
			#expect(result.z == simdResult.z)
		#endif
		}

	/// Tests mutating subtraction.
	///
		@Test("Subtraction Assignment")
		func subtractionAssignment() async throws {
			var lhs = Vector3<Double>(x: 5.0, y: 7.0, z: 9.0)
			lhs -= Vector3<Double>(x: 1.0, y: 2.0, z: 3.0)
			#expect(lhs.x == 4.0)
			#expect(lhs.y == 5.0)
			#expect(lhs.z == 6.0)
		}

	/// Tests component-wise multiplication.
	///
	/// (2, 3, 4) * (5, 6, 7) = (10, 18, 28)
	///
		@Test("Multiplication (vector)")
		func multiplicationVector() async throws {
			let lhs = Vector3<Double>(x: 2.0, y: 3.0, z: 4.0)
			let rhs = Vector3<Double>(x: 5.0, y: 6.0, z: 7.0)
			let result = lhs * rhs
			#expect(result.x == 10.0)
			#expect(result.y == 18.0)
			#expect(result.z == 28.0)
		}

	/// Tests mutating component-wise multiplication.
	///
		@Test("Multiplication Assignment (vector)")
		func multiplicationAssignmentVector() async throws {
			var lhs = Vector3<Double>(x: 2.0, y: 3.0, z: 4.0)
			lhs *= Vector3<Double>(x: 5.0, y: 6.0, z: 7.0)
			#expect(lhs.x == 10.0)
			#expect(lhs.y == 18.0)
			#expect(lhs.z == 28.0)
		}

	/// Tests scalar multiplication.
	///
	/// (1, 2, 3) * 3 = (3, 6, 9)
	///
		@Test("Multiplication (scalar)")
		func multiplicationScalar() async throws {
			let v = Vector3<Double>(x: 1.0, y: 2.0, z: 3.0)
			let result1 = v * 3.0
			let result2 = 3.0 * v
			#expect(result1.x == 3.0)
			#expect(result1.y == 6.0)
			#expect(result1.z == 9.0)
			#expect(result2.x == 3.0)
			#expect(result2.y == 6.0)
			#expect(result2.z == 9.0)
		}

	/// Tests component-wise division.
	///
	/// (10, 18, 28) / (2, 3, 4) = (5, 6, 7)
	///
		@Test("Division (vector)")
		func divisionVector() async throws {
			let lhs = Vector3<Double>(x: 10.0, y: 18.0, z: 28.0)
			let rhs = Vector3<Double>(x: 2.0, y: 3.0, z: 4.0)
			let result = lhs / rhs
			#expect(result.x == 5.0)
			#expect(result.y == 6.0)
			#expect(result.z == 7.0)
		}

	/// Tests mutating component-wise division.
	///
		@Test("Division Assignment (vector)")
		func divisionAssignmentVector() async throws {
			var lhs = Vector3<Double>(x: 10.0, y: 18.0, z: 28.0)
			lhs /= Vector3<Double>(x: 2.0, y: 3.0, z: 4.0)
			#expect(lhs.x == 5.0)
			#expect(lhs.y == 6.0)
			#expect(lhs.z == 7.0)
		}

	/// Tests prefix negation.
	///
	/// -(1, -2, 3) = (-1, 2, -3)
	///
		@Test("Negation")
		func negation() async throws {
			let v = Vector3<Double>(x: 1.0, y: -2.0, z: 3.0)
			let result = -v
			#expect(result.x == -1.0)
			#expect(result.y == 2.0)
			#expect(result.z == -3.0)
		}

	/// Tests min() — the smallest component.
	///
		@Test("min()")
		func minComponent() async throws {
			let v = Vector3<Double>(x: 7.0, y: 3.0, z: 5.0)
			#expect(v.min() == 3.0)
		}

	/// Tests max() — the largest component.
	///
		@Test("max()")
		func maxComponent() async throws {
			let v = Vector3<Double>(x: 7.0, y: 3.0, z: 5.0)
			#expect(v.max() == 7.0)
		}

	/// Tests average() — mean of components.
	///
	/// (3, 6, 9) → 6.0
	///
		@Test("average()")
		func average() async throws {
			let v = Vector3<Double>(x: 3.0, y: 6.0, z: 9.0)
			#expect(v.average() == 6.0)
		}

	/// Tests sum() — sum of components.
	///
	/// (1, 2, 3) → 6.0
	///
		@Test("sum()")
		func sum() async throws {
			let v = Vector3<Double>(x: 1.0, y: 2.0, z: 3.0)
			#expect(v.sum() == 6.0)
		}
	}
}

// MARK: - Componentwise min/max/abs

extension Vector3Tests {
	@Suite("Componentwise")
	struct ComponentwiseSuite {
	/// Tests Vector3.min(_:_:).
	///
	/// min((1, 5, 3), (4, 2, 6)) = (1, 2, 3)
	///
		@Test("min(_:_:)")
		func componentwiseMin() async throws {
			let a = Vector3<Double>(x: 1.0, y: 5.0, z: 3.0)
			let b = Vector3<Double>(x: 4.0, y: 2.0, z: 6.0)
			let result = Vector3<Double>.min(a, b)
			#expect(result.x == 1.0)
			#expect(result.y == 2.0)
			#expect(result.z == 3.0)
		}

	/// Tests Vector3.max(_:_:).
	///
	/// max((1, 5, 3), (4, 2, 6)) = (4, 5, 6)
	///
		@Test("max(_:_:)")
		func componentwiseMax() async throws {
			let a = Vector3<Double>(x: 1.0, y: 5.0, z: 3.0)
			let b = Vector3<Double>(x: 4.0, y: 2.0, z: 6.0)
			let result = Vector3<Double>.max(a, b)
			#expect(result.x == 4.0)
			#expect(result.y == 5.0)
			#expect(result.z == 6.0)
		}

	/// Tests abs() — makes all components non-negative.
	///
	/// (-1, 2, -3).abs() = (1, 2, 3)
	///
		@Test("abs()")
		func componentwiseAbs() async throws {
			let v = Vector3<Double>(x: -1.0, y: 2.0, z: -3.0)
			let result = v.abs()
			#expect(result.x == 1.0)
			#expect(result.y == 2.0)
			#expect(result.z == 3.0)
		}
	}
}

// MARK: - DotProduct

extension Vector3Tests {
	@Suite("DotProduct")
	struct DotProductSuite {
	/// Perpendicular unit vectors must have dot product 0.
	///
		@Test("Perpendicular vectors")
		func perpendicular() async throws {
			let a = Vector3<Double>(x: 1.0, y: 0.0, z: 0.0)
			let b = Vector3<Double>(x: 0.0, y: 1.0, z: 0.0)
			#expect(a.dot(b).isApproximatelyEqual(to: 0.0))
		}

	/// A unit vector dotted with itself must equal 1.
	///
		@Test("Parallel unit vectors")
		func parallel() async throws {
			let a = Vector3<Double>(x: 1.0, y: 0.0, z: 0.0)
			#expect(a.dot(a).isApproximatelyEqual(to: 1.0))
		}

	/// Concrete value: (1, 2, 3) · (4, 5, 6) = 4 + 10 + 18 = 32
	///
		@Test("Concrete values")
		func concreteValues() async throws {
			let a = Vector3<Double>(x: 1.0, y: 2.0, z: 3.0)
			let b = Vector3<Double>(x: 4.0, y: 5.0, z: 6.0)
			#expect(a.dot(b).isApproximatelyEqual(to: 32.0))

		#if canImport(simd)
			let simdResult = simd_dot(simd_double3(1.0, 2.0, 3.0), simd_double3(4.0, 5.0, 6.0))
			#expect(a.dot(b) == simdResult)
		#endif
		}
	}
}

// MARK: - CrossProduct (3D)

extension Vector3Tests {
	@Suite("CrossProduct")
	struct CrossProductSuite {
	/// cross(+X, +Y) must equal +Z.
	///
		@Test("X cross Y = Z")
		func xCrossYEqualsZ() async throws {
			let x = Vector3<Double>(x: 1.0, y: 0.0, z: 0.0)
			let y = Vector3<Double>(x: 0.0, y: 1.0, z: 0.0)
			let result = x.cross(y)
			#expect(result.x.isApproximatelyEqual(to: 0.0))
			#expect(result.y.isApproximatelyEqual(to: 0.0))
			#expect(result.z.isApproximatelyEqual(to: 1.0))

		#if canImport(simd)
			let simdResult = simd_cross(simd_double3(1.0, 0.0, 0.0), simd_double3(0.0, 1.0, 0.0))
			#expect(result.x.isApproximatelyEqual(to: simdResult.x))
			#expect(result.y.isApproximatelyEqual(to: simdResult.y))
			#expect(result.z.isApproximatelyEqual(to: simdResult.z))
		#endif
		}

	/// cross(+Y, +X) must equal -Z (anti-commutativity).
	///
		@Test("Y cross X = -Z")
		func yCrossXEqualsNegativeZ() async throws {
			let x = Vector3<Double>(x: 1.0, y: 0.0, z: 0.0)
			let y = Vector3<Double>(x: 0.0, y: 1.0, z: 0.0)
			let result = y.cross(x)
			#expect(result.x.isApproximatelyEqual(to: 0.0))
			#expect(result.y.isApproximatelyEqual(to: 0.0))
			#expect(result.z.isApproximatelyEqual(to: -1.0))
		}

	/// cross(a, b) = -cross(b, a) for any vectors.
	///
		@Test("Anti-commutativity")
		func antiCommutativity() async throws {
			let a = Vector3<Double>(x: 1.0, y: 2.0, z: 3.0)
			let b = Vector3<Double>(x: 4.0, y: 5.0, z: 6.0)
			let ab = a.cross(b)
			let ba = b.cross(a)
			#expect(ab.x.isApproximatelyEqual(to: -ba.x))
			#expect(ab.y.isApproximatelyEqual(to: -ba.y))
			#expect(ab.z.isApproximatelyEqual(to: -ba.z))
		}

	/// Concrete value: (1, 2, 3) × (4, 5, 6)
	/// = (2*6 - 3*5, 3*4 - 1*6, 1*5 - 2*4) = (-3, 6, -3)
	///
		@Test("Concrete values")
		func concreteValues() async throws {
			let a = Vector3<Double>(x: 1.0, y: 2.0, z: 3.0)
			let b = Vector3<Double>(x: 4.0, y: 5.0, z: 6.0)
			let result = a.cross(b)
			#expect(result.x.isApproximatelyEqual(to: -3.0))
			#expect(result.y.isApproximatelyEqual(to: 6.0))
			#expect(result.z.isApproximatelyEqual(to: -3.0))
		}

	/// The cross product of parallel vectors must be the zero vector.
	///
		@Test("Parallel vectors give zero")
		func parallelVectorsZero() async throws {
			let a = Vector3<Double>(x: 1.0, y: 2.0, z: 3.0)
			let b = Vector3<Double>(x: 2.0, y: 4.0, z: 6.0)
			let result = a.cross(b)
			#expect(result.x.isApproximatelyEqual(to: 0.0))
			#expect(result.y.isApproximatelyEqual(to: 0.0))
			#expect(result.z.isApproximatelyEqual(to: 0.0))
		}
	}
}

// MARK: - Magnitude

extension Vector3Tests {
	@Suite("Magnitude")
	struct MagnitudeSuite {
	/// (0, 3, 4) has magnitude 5 (3-4-5 triple in y-z plane).
	///
		@Test("Known value")
		func magnitudeKnownValue() async throws {
			let v = Vector3<Double>(x: 0.0, y: 3.0, z: 4.0)
			#expect(v.magnitude.isApproximatelyEqual(to: 5.0))

		#if canImport(simd)
			#expect(v.magnitude.isApproximatelyEqual(to: simd_length(simd_double3(0.0, 3.0, 4.0))))
		#endif
		}

	/// (1, 1, 1) has magnitude sqrt(3).
	///
		@Test("(1, 1, 1) magnitude")
		func magnitudeUnitDiagonal() async throws {
			let v = Vector3<Double>(x: 1.0, y: 1.0, z: 1.0)
			#expect(v.magnitude.isApproximatelyEqual(to: Double.sqrt(3.0)))
		}

	/// Setting magnitude scales the vector while preserving direction.
	///
		@Test("Set magnitude")
		func setMagnitude() async throws {
			var v = Vector3<Double>(x: 0.0, y: 3.0, z: 4.0)
			v.magnitude = 10.0
			#expect(v.magnitude.isApproximatelyEqual(to: 10.0))
			#expect(v.x.isApproximatelyEqual(to: 0.0))
			#expect(v.y.isApproximatelyEqual(to: 6.0))
			#expect(v.z.isApproximatelyEqual(to: 8.0))
		}
	}
}

// MARK: - Normalized

extension Vector3Tests {
	@Suite("Normalized")
	struct NormalizedSuite {
	/// Normalizing a non-zero vector must produce magnitude 1.
	///
		@Test("Magnitude is 1.0")
		func magnitudeIsOne() async throws {
			let v = Vector3<Double>(x: 1.0, y: 2.0, z: 3.0)
			let n = v.normalized
			#expect(n.magnitude.isApproximatelyEqual(to: 1.0))
		}

	/// Normalizing an axis-aligned vector gives that unit axis vector.
	///
		@Test("Axis-aligned normalization")
		func axisAligned() async throws {
			let v = Vector3<Double>(x: 5.0, y: 0.0, z: 0.0)
			let n = v.normalized
			#expect(n.x.isApproximatelyEqual(to: 1.0))
			#expect(n.y.isApproximatelyEqual(to: 0.0))
			#expect(n.z.isApproximatelyEqual(to: 0.0))
		}

	/// Mutating normalize() must produce the same result as the computed property.
	///
		@Test("Mutating normalize()")
		func mutatingNormalize() async throws {
			var v = Vector3<Double>(x: 1.0, y: 2.0, z: 3.0)
			let expected = v.normalized
			v.normalize()
			#expect(v.x.isApproximatelyEqual(to: expected.x))
			#expect(v.y.isApproximatelyEqual(to: expected.y))
			#expect(v.z.isApproximatelyEqual(to: expected.z))
		}
	}
}

// MARK: - EuclideanDistance

extension Vector3Tests {
	@Suite("EuclideanDistance")
	struct EuclideanDistanceSuite {
	/// Distance from (0,0,0) to (0,3,4) is 5.
	///
		@Test("distance")
		func distance() async throws {
			let a = Vector3<Double>(x: 0.0, y: 0.0, z: 0.0)
			let b = Vector3<Double>(x: 0.0, y: 3.0, z: 4.0)
			#expect(a.distance(to: b).isApproximatelyEqual(to: 5.0))
		}

	/// Squared distance from (0,0,0) to (0,3,4) is 25.
	///
		@Test("squaredDistance")
		func squaredDistance() async throws {
			let a = Vector3<Double>(x: 0.0, y: 0.0, z: 0.0)
			let b = Vector3<Double>(x: 0.0, y: 3.0, z: 4.0)
			#expect(a.squaredDistance(to: b).isApproximatelyEqual(to: 25.0))
		}

	/// Distance from (1,1,1) to (1,4,5) is 5.
	///
		@Test("distance (offset)")
		func distanceOffset() async throws {
			let a = Vector3<Double>(x: 1.0, y: 1.0, z: 1.0)
			let b = Vector3<Double>(x: 1.0, y: 4.0, z: 5.0)
			#expect(a.distance(to: b).isApproximatelyEqual(to: 5.0))
		}
	}
}

// MARK: - Blendable

extension Vector3Tests {
	@Suite("Blendable")
	struct BlendableSuite {
	/// blend(amount: 0) must return the from vector.
	///
		@Test("blend 0.0 = from")
		func blendZero() async throws {
			let from = Vector3<Double>(x: 0.0, y: 0.0, z: 0.0)
			let to = Vector3<Double>(x: 10.0, y: 20.0, z: 30.0)
			let result = Vector3<Double>.blend(from: from, to: to, by: 0.0)
			#expect(result.x.isApproximatelyEqual(to: 0.0))
			#expect(result.y.isApproximatelyEqual(to: 0.0))
			#expect(result.z.isApproximatelyEqual(to: 0.0))
		}

	/// blend(amount: 1) must return the to vector.
	///
		@Test("blend 1.0 = to")
		func blendOne() async throws {
			let from = Vector3<Double>(x: 0.0, y: 0.0, z: 0.0)
			let to = Vector3<Double>(x: 10.0, y: 20.0, z: 30.0)
			let result = Vector3<Double>.blend(from: from, to: to, by: 1.0)
			#expect(result.x.isApproximatelyEqual(to: 10.0))
			#expect(result.y.isApproximatelyEqual(to: 20.0))
			#expect(result.z.isApproximatelyEqual(to: 30.0))
		}

	/// blend(amount: 0.5) must return the midpoint.
	///
		@Test("blend 0.5 = midpoint")
		func blendHalf() async throws {
			let from = Vector3<Double>(x: 0.0, y: 0.0, z: 0.0)
			let to = Vector3<Double>(x: 10.0, y: 20.0, z: 30.0)
			let result = Vector3<Double>.blend(from: from, to: to, by: 0.5)
			#expect(result.x.isApproximatelyEqual(to: 5.0))
			#expect(result.y.isApproximatelyEqual(to: 10.0))
			#expect(result.z.isApproximatelyEqual(to: 15.0))
		}
	}
}

// MARK: - AngleMeasurable

extension Vector3Tests {
	@Suite("AngleMeasurable")
	struct AngleMeasurableSuite {
	/// The angle between identical unit vectors is 0°.
	///
		@Test("Angle 0 degrees")
		func angleZeroDegrees() async throws {
			let v = Vector3<Double>(x: 1.0, y: 0.0, z: 0.0)
			let angle = Vector3.angle(from: v, to: v, by: nil)
			#expect(angle.radians.isApproximatelyEqual(to: 0.0))
		}

	/// The angle between +X and +Y unit vectors is 90° (π/2 radians).
	///
		@Test("Angle 90 degrees")
		func angleNinetyDegrees() async throws {
			let a = Vector3<Double>(x: 1.0, y: 0.0, z: 0.0)
			let b = Vector3<Double>(x: 0.0, y: 1.0, z: 0.0)
			let angle = Vector3.angle(from: a, to: b, by: nil)
			#expect(angle.radians.isApproximatelyEqual(to: .pi / 2, relativeTolerance: 1e-10))
		}

	/// The angle between +X and -X is 180° (π radians).
	///
		@Test("Angle 180 degrees")
		func angleOneEightyDegrees() async throws {
			let a = Vector3<Double>(x: 1.0, y: 0.0, z: 0.0)
			let b = Vector3<Double>(x: -1.0, y: 0.0, z: 0.0)
			let angle = Vector3.angle(from: a, to: b, by: nil)
			#expect(angle.radians.isApproximatelyEqual(to: .pi, relativeTolerance: 1e-10))
		}
	}
}

// MARK: - Reflection

extension Vector3Tests {
	@Suite("Reflection")
	struct ReflectionSuite {
	/// Reflecting a ray (1, -1, 0) off a horizontal surface (normal = (0,1,0))
	/// gives (1, 1, 0).
	///
		@Test("Reflect off horizontal surface")
		func reflectHorizontalSurface() async throws {
			let ray = Vector3<Double>(x: 1.0, y: -1.0, z: 0.0)
			let normal = Vector3<Double>(x: 0.0, y: 1.0, z: 0.0)
			let result = ray.reflection(withNormal: normal)
			#expect(result.x.isApproximatelyEqual(to: 1.0))
			#expect(result.y.isApproximatelyEqual(to: 1.0))
			#expect(result.z.isApproximatelyEqual(to: 0.0))
		}

	/// Reflecting (0, -1, 0) directly at a flat surface (normal = (0,1,0))
	/// gives (0, 1, 0).
	///
		@Test("Straight-down reflection")
		func straightDownReflection() async throws {
			let ray = Vector3<Double>(x: 0.0, y: -1.0, z: 0.0)
			let normal = Vector3<Double>(x: 0.0, y: 1.0, z: 0.0)
			let result = ray.reflection(withNormal: normal)
			#expect(result.x.isApproximatelyEqual(to: 0.0))
			#expect(result.y.isApproximatelyEqual(to: 1.0))
			#expect(result.z.isApproximatelyEqual(to: 0.0))
		}
	}
}

// MARK: - Refraction

extension Vector3Tests {
	@Suite("Refraction")
	struct RefractionSuite {
	/// Total internal reflection: steep angle with high IOR returns zero vector.
	///
		@Test("Total internal reflection returns zero")
		func totalInternalReflection() async throws {
			// sin(70°) > 1/1.5 so TIR occurs with IOR 1.5
			let angle: Double = 70.0 * .pi / 180.0
			let ray = Vector3<Double>(x: Double.sin(angle), y: -Double.cos(angle), z: 0.0)
			let normal = Vector3<Double>(x: 0.0, y: 1.0, z: 0.0)
			let result = ray.refraction(withNormal: normal, indexOfRefraction: 1.5)
			#expect(result.x.isApproximatelyEqual(to: 0.0))
			#expect(result.y.isApproximatelyEqual(to: 0.0))
			#expect(result.z.isApproximatelyEqual(to: 0.0))
		}

	/// IOR = 1.0 (same medium) passes the ray straight through.
	///
		@Test("No-op refraction (IOR = 1.0)")
		func noOpRefraction() async throws {
			let ray = Vector3<Double>(x: 0.0, y: -1.0, z: 0.0)
			let normal = Vector3<Double>(x: 0.0, y: 1.0, z: 0.0)
			let result = ray.refraction(withNormal: normal, indexOfRefraction: 1.0)
			#expect(result.x.isApproximatelyEqual(to: 0.0))
			#expect(result.y.isApproximatelyEqual(to: -1.0))
			#expect(result.z.isApproximatelyEqual(to: 0.0))
		}
	}
}

// MARK: - QuaternionRotatable

extension Vector3Tests {
	@Suite("QuaternionRotatable")
	struct QuaternionRotatableSuite {
	/// Rotating (1, 0, 0) by 90° around Z should produce approximately (0, 1, 0).
	///
		@Test("90 degree rotation around Z")
		func rotateAroundZ90() async throws {
			let v = Vector3<Double>(x: 1.0, y: 0.0, z: 0.0)
			let axis = Vector3<Double>(x: 0.0, y: 0.0, z: 1.0)
			let q = Quaternion<Double>(withAxis: axis, angle: Angle(radians: .pi / 2))
			let result = v.rotated(by: q)
			#expect(result.x.isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(result.y.isApproximatelyEqual(to: 1.0))
			#expect(result.z.isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
		}

	/// Rotating (0, 1, 0) by 90° around X should produce approximately (0, 0, 1).
	///
		@Test("90 degree rotation around X")
		func rotateAroundX90() async throws {
			let v = Vector3<Double>(x: 0.0, y: 1.0, z: 0.0)
			let axis = Vector3<Double>(x: 1.0, y: 0.0, z: 0.0)
			let q = Quaternion<Double>(withAxis: axis, angle: Angle(radians: .pi / 2))
			let result = v.rotated(by: q)
			#expect(result.x.isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(result.y.isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(result.z.isApproximatelyEqual(to: 1.0))
		}

	/// Rotating by the identity quaternion must leave the vector unchanged.
	///
		@Test("Identity quaternion leaves vector unchanged")
		func identityQuaternion() async throws {
			let v = Vector3<Double>(x: 1.0, y: 2.0, z: 3.0)
			let result = v.rotated(by: .identity)
			#expect(result.x.isApproximatelyEqual(to: 1.0))
			#expect(result.y.isApproximatelyEqual(to: 2.0))
			#expect(result.z.isApproximatelyEqual(to: 3.0))
		}

	/// Mutating rotate(by:) must produce the same result as rotated(by:).
	///
		@Test("Mutating rotate(by:)")
		func mutatingRotate() async throws {
			let v = Vector3<Double>(x: 1.0, y: 0.0, z: 0.0)
			let axis = Vector3<Double>(x: 0.0, y: 0.0, z: 1.0)
			let q = Quaternion<Double>(withAxis: axis, angle: Angle(radians: .pi / 2))
			let expected = v.rotated(by: q)
			var mutable = v
			mutable.rotate(by: q)
			#expect(mutable.x.isApproximatelyEqual(to: expected.x))
			#expect(mutable.y.isApproximatelyEqual(to: expected.y))
			#expect(mutable.z.isApproximatelyEqual(to: expected.z))
		}
	}
}

// MARK: - SIMD

extension Vector3Tests {
	@Suite("SIMDConvertible")
	struct SIMDSuite {
	/// The .simd property must round-trip through the SIMD representation.
	///
		@Test("SIMD round-trip")
		func simdRoundTrip() async throws {
			let v = Vector3<Double>(x: 1.5, y: -2.5, z: 3.75)
			let simdValue = v.simd
			let reconstructed = Vector3<Double>(simdValue)
			#expect(reconstructed.x == v.x)
			#expect(reconstructed.y == v.y)
			#expect(reconstructed.z == v.z)
		}

	#if canImport(simd)
	/// The .simd value must agree with the equivalent simd_double3.
	///
		@Test("SIMD matches simd_double3")
		func simdMatchesSIMD3() async throws {
			let v = Vector3<Double>(x: 1.0, y: 2.0, z: 3.0)
			let reference = simd_double3(1.0, 2.0, 3.0)
			#expect(v.simd.x == reference.x)
			#expect(v.simd.y == reference.y)
			#expect(v.simd.z == reference.z)
		}
	#endif
	}
}
