//
//  Vector2.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
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

@Suite("Vector2")
struct Vector2Tests {
/// Tests the default initializer, which is expected to create a zero vector.
///
	@Test("Default Initializer")
	func defaultInitializer() async throws {
		let v = Vector2<Double>()
		#expect(v.x == .zero)
		#expect(v.y == .zero)
	}

/// Tests the labeled x/y initializer.
///
	@Test("Initializer (x:y:)")
	func initializerXY() async throws {
		let v = Vector2<Double>(x: 3.0, y: 4.0)
		#expect(v.x == 3.0)
		#expect(v.y == 4.0)
	}

/// Tests the labeled u/v initializer.
///
	@Test("Initializer (u:v:)")
	func initializerUV() async throws {
		let v = Vector2<Double>(u: 5.0, v: 6.0)
		#expect(v.u == 5.0)
		#expect(v.v == 6.0)
	}

/// Tests the unlabeled positional initializer.
///
	@Test("Initializer (_:_:)")
	func initializerPositional() async throws {
		let v = Vector2<Double>(7.0, 8.0)
		#expect(v.x == 7.0)
		#expect(v.y == 8.0)
	}

/// Tests the array literal initializer.
///
	@Test("Initializer (arrayLiteral:)")
	func initializerArrayLiteral() async throws {
		let v: Vector2<Double> = [9.0, 10.0]
		#expect(v.x == 9.0)
		#expect(v.y == 10.0)
	}

/// Tests that x/y, u/v, and first/second all alias the same underlying
/// storage.
///
	@Test("Component Accessors Alias")
	func componentAccessors() async throws {
		let v = Vector2<Double>(x: 1.0, y: 2.0)
		#expect(v.x == v.u)
		#expect(v.x == v.first)
		#expect(v.y == v.v)
		#expect(v.y == v.second)
	}

/// Tests that setters on all aliases update the same underlying storage.
///
	@Test("Component Setter Aliases")
	func componentSetterAliases() async throws {
		var v = Vector2<Double>(x: 1.0, y: 2.0)
		v.u = 11.0
		#expect(v.x == 11.0)
		v.first = 21.0
		#expect(v.x == 21.0)
		v.v = 12.0
		#expect(v.y == 12.0)
		v.second = 22.0
		#expect(v.y == 22.0)
	}

/// Tests JSON round-trip encoding and decoding.
///
	@Test("Codable")
	func codable() async throws {
		let original = Vector2<Double>(x: 1.5, y: -2.5)
		let encoded = try JSONEncoder().encode(original)
		let decoded = try JSONDecoder().decode(Vector2<Double>.self, from: encoded)
		#expect(decoded.x == original.x)
		#expect(decoded.y == original.y)
	}

/// Tests equality and inequality.
///
	@Test("Equatable")
	func equatable() async throws {
		let a = Vector2<Double>(x: 1.0, y: 2.0)
		let b = Vector2<Double>(x: 1.0, y: 2.0)
		let c = Vector2<Double>(x: 1.0 + .ulpOfOne, y: 2.0)
		#expect(a == b)
		#expect(a != c)
	}
}

// MARK: - VectorMath

extension Vector2Tests {
	@Suite("VectorMath")
	struct VectorMathSuite {
	/// Tests component-wise addition of two vectors.
	///
	/// (1, 2) + (3, 4) = (4, 6)
	///
		@Test("Addition")
		func addition() async throws {
			let lhs = Vector2<Double>(x: 1.0, y: 2.0)
			let rhs = Vector2<Double>(x: 3.0, y: 4.0)
			let result = lhs + rhs
			#expect(result.x == 4.0)
			#expect(result.y == 6.0)

		#if canImport(simd)
			let simdResult = simd_double2(1.0, 2.0) + simd_double2(3.0, 4.0)
			#expect(result.x == simdResult.x)
			#expect(result.y == simdResult.y)
		#endif
		}

	/// Tests mutating addition of two vectors.
	///
		@Test("Addition Assignment")
		func additionAssignment() async throws {
			var lhs = Vector2<Double>(x: 1.0, y: 2.0)
			lhs += Vector2<Double>(x: 3.0, y: 4.0)
			#expect(lhs.x == 4.0)
			#expect(lhs.y == 6.0)
		}

	/// Tests component-wise subtraction of two vectors.
	///
	/// (5, 7) - (2, 3) = (3, 4)
	///
		@Test("Subtraction")
		func subtraction() async throws {
			let lhs = Vector2<Double>(x: 5.0, y: 7.0)
			let rhs = Vector2<Double>(x: 2.0, y: 3.0)
			let result = lhs - rhs
			#expect(result.x == 3.0)
			#expect(result.y == 4.0)

		#if canImport(simd)
			let simdResult = simd_double2(5.0, 7.0) - simd_double2(2.0, 3.0)
			#expect(result.x == simdResult.x)
			#expect(result.y == simdResult.y)
		#endif
		}

	/// Tests mutating subtraction.
	///
		@Test("Subtraction Assignment")
		func subtractionAssignment() async throws {
			var lhs = Vector2<Double>(x: 5.0, y: 7.0)
			lhs -= Vector2<Double>(x: 2.0, y: 3.0)
			#expect(lhs.x == 3.0)
			#expect(lhs.y == 4.0)
		}

	/// Tests component-wise multiplication of two vectors.
	///
	/// (2, 3) * (4, 5) = (8, 15)
	///
		@Test("Multiplication (vector)")
		func multiplicationVector() async throws {
			let lhs = Vector2<Double>(x: 2.0, y: 3.0)
			let rhs = Vector2<Double>(x: 4.0, y: 5.0)
			let result = lhs * rhs
			#expect(result.x == 8.0)
			#expect(result.y == 15.0)
		}

	/// Tests mutating component-wise multiplication.
	///
		@Test("Multiplication Assignment (vector)")
		func multiplicationAssignmentVector() async throws {
			var lhs = Vector2<Double>(x: 2.0, y: 3.0)
			lhs *= Vector2<Double>(x: 4.0, y: 5.0)
			#expect(lhs.x == 8.0)
			#expect(lhs.y == 15.0)
		}

	/// Tests scalar multiplication: vector * scalar and scalar * vector.
	///
	/// (3, 4) * 2 = (6, 8)
	///
		@Test("Multiplication (scalar)")
		func multiplicationScalar() async throws {
			let v = Vector2<Double>(x: 3.0, y: 4.0)
			let result1 = v * 2.0
			let result2 = 2.0 * v
			#expect(result1.x == 6.0)
			#expect(result1.y == 8.0)
			#expect(result2.x == 6.0)
			#expect(result2.y == 8.0)
		}

	/// Tests component-wise division of two vectors.
	///
	/// (8, 15) / (2, 3) = (4, 5)
	///
		@Test("Division (vector)")
		func divisionVector() async throws {
			let lhs = Vector2<Double>(x: 8.0, y: 15.0)
			let rhs = Vector2<Double>(x: 2.0, y: 3.0)
			let result = lhs / rhs
			#expect(result.x == 4.0)
			#expect(result.y == 5.0)
		}

	/// Tests mutating component-wise division.
	///
		@Test("Division Assignment (vector)")
		func divisionAssignmentVector() async throws {
			var lhs = Vector2<Double>(x: 8.0, y: 15.0)
			lhs /= Vector2<Double>(x: 2.0, y: 3.0)
			#expect(lhs.x == 4.0)
			#expect(lhs.y == 5.0)
		}

	/// Tests prefix negation, which should invert each component.
	///
	/// -(3, -4) = (-3, 4)
	///
		@Test("Negation")
		func negation() async throws {
			let v = Vector2<Double>(x: 3.0, y: -4.0)
			let result = -v
			#expect(result.x == -3.0)
			#expect(result.y == 4.0)
		}

	/// Tests min() — the smallest component value.
	///
		@Test("min()")
		func minComponent() async throws {
			let v = Vector2<Double>(x: 7.0, y: 3.0)
			#expect(v.min() == 3.0)
		}

	/// Tests max() — the largest component value.
	///
		@Test("max()")
		func maxComponent() async throws {
			let v = Vector2<Double>(x: 7.0, y: 3.0)
			#expect(v.max() == 7.0)
		}

	/// Tests average() — the mean of all components.
	///
	/// (4, 8) → average = 6.0
	///
		@Test("average()")
		func average() async throws {
			let v = Vector2<Double>(x: 4.0, y: 8.0)
			#expect(v.average() == 6.0)
		}

	/// Tests sum() — the sum of all components.
	///
	/// (4, 8) → sum = 12.0
	///
		@Test("sum()")
		func sum() async throws {
			let v = Vector2<Double>(x: 4.0, y: 8.0)
			#expect(v.sum() == 12.0)
		}
	}
}

// MARK: - Componentwise min/max/abs

extension Vector2Tests {
	@Suite("Componentwise")
	struct ComponentwiseSuite {
	/// Tests Vector2.min(_:_:), which returns the per-component minimum.
	///
	/// min((1, 5), (3, 2)) = (1, 2)
	///
		@Test("min(_:_:)")
		func componentwiseMin() async throws {
			let a = Vector2<Double>(x: 1.0, y: 5.0)
			let b = Vector2<Double>(x: 3.0, y: 2.0)
			let result = Vector2<Double>.min(a, b)
			#expect(result.x == 1.0)
			#expect(result.y == 2.0)
		}

	/// Tests Vector2.max(_:_:), which returns the per-component maximum.
	///
	/// max((1, 5), (3, 2)) = (3, 5)
	///
		@Test("max(_:_:)")
		func componentwiseMax() async throws {
			let a = Vector2<Double>(x: 1.0, y: 5.0)
			let b = Vector2<Double>(x: 3.0, y: 2.0)
			let result = Vector2<Double>.max(a, b)
			#expect(result.x == 3.0)
			#expect(result.y == 5.0)
		}

	/// Tests abs(), which makes every component non-negative.
	///
	/// (-3, 4).abs() = (3, 4)
	///
		@Test("abs()")
		func componentwiseAbs() async throws {
			let v = Vector2<Double>(x: -3.0, y: 4.0)
			let result = v.abs()
			#expect(result.x == 3.0)
			#expect(result.y == 4.0)
		}
	}
}

// MARK: - DotProduct

extension Vector2Tests {
	@Suite("DotProduct")
	struct DotProductSuite {
	/// Perpendicular unit vectors must have a dot product of zero.
	///
		@Test("Perpendicular vectors")
		func perpendicular() async throws {
			let a = Vector2<Double>(x: 1.0, y: 0.0)
			let b = Vector2<Double>(x: 0.0, y: 1.0)
			#expect(a.dot(b).isApproximatelyEqual(to: 0.0))
		}

	/// Parallel unit vectors must have a dot product of 1.
	///
		@Test("Parallel unit vectors")
		func parallel() async throws {
			let a = Vector2<Double>(x: 1.0, y: 0.0)
			#expect(a.dot(a).isApproximatelyEqual(to: 1.0))
		}

	/// Concrete value: (2, 3) · (4, 5) = 8 + 15 = 23
	///
		@Test("Concrete values")
		func concreteValues() async throws {
			let a = Vector2<Double>(x: 2.0, y: 3.0)
			let b = Vector2<Double>(x: 4.0, y: 5.0)
			#expect(a.dot(b).isApproximatelyEqual(to: 23.0))

		#if canImport(simd)
			let simdResult = simd_dot(simd_double2(2.0, 3.0), simd_double2(4.0, 5.0))
			#expect(a.dot(b) == simdResult)
		#endif
		}
	}
}

// MARK: - CrossProduct

extension Vector2Tests {
	@Suite("CrossProduct")
	struct CrossProductSuite {
	/// The 2D cross product returns a positive scalar when b is
	/// counter-clockwise from a (right-hand convention).
	///
	/// (+x) cross (+y) should be positive (CCW).
	///
		@Test("CCW positive")
		func crossCCWPositive() async throws {
			let a = Vector2<Double>(x: 1.0, y: 0.0)
			let b = Vector2<Double>(x: 0.0, y: 1.0)
			// a.x * b.y - a.y * b.x = 1*1 - 0*0 = 1
			#expect(a.cross(b) > 0.0)
		}

	/// The 2D cross product returns a negative scalar when b is clockwise from
	/// a.
	///
		@Test("CW negative")
		func crossCWNegative() async throws {
			let a = Vector2<Double>(x: 0.0, y: 1.0)
			let b = Vector2<Double>(x: 1.0, y: 0.0)
			// a.x * b.y - a.y * b.x = 0*0 - 1*1 = -1
			#expect(a.cross(b) < 0.0)
		}

	/// Concrete signed area: (1, 2) cross (3, 4) = 1*4 - 2*3 = -2
	///
		@Test("Concrete value")
		func crossConcreteValue() async throws {
			let a = Vector2<Double>(x: 1.0, y: 2.0)
			let b = Vector2<Double>(x: 3.0, y: 4.0)
			#expect(a.cross(b).isApproximatelyEqual(to: -2.0))
		}

	/// Collinear vectors must have a cross product of zero.
	///
		@Test("Collinear vectors")
		func crossCollinear() async throws {
			let a = Vector2<Double>(x: 2.0, y: 4.0)
			let b = Vector2<Double>(x: 1.0, y: 2.0)
			#expect(a.cross(b).isApproximatelyEqual(to: 0.0))
		}
	}
}

// MARK: - Magnitude

extension Vector2Tests {
	@Suite("Magnitude")
	struct MagnitudeSuite {
	/// A (3, 4) vector must have magnitude 5.0 (3-4-5 Pythagorean triple).
	///
		@Test("Known value")
		func magnitudeKnownValue() async throws {
			let v = Vector2<Double>(x: 3.0, y: 4.0)
			#expect(v.magnitude.isApproximatelyEqual(to: 5.0))

		#if canImport(simd)
			#expect(v.magnitude.isApproximatelyEqual(to: simd_length(simd_double2(3.0, 4.0))))
		#endif
		}

	/// Setting the magnitude should scale the vector while preserving direction.
	///
		@Test("Set magnitude")
		func setMagnitude() async throws {
			var v = Vector2<Double>(x: 3.0, y: 4.0)
			v.magnitude = 10.0
			#expect(v.magnitude.isApproximatelyEqual(to: 10.0))
			// Direction preserved: x/y ratio should stay 3/4
			#expect(v.x.isApproximatelyEqual(to: 6.0))
			#expect(v.y.isApproximatelyEqual(to: 8.0))
		}
	}
}

// MARK: - Normalized

extension Vector2Tests {
	@Suite("Normalized")
	struct NormalizedSuite {
	/// Normalizing any non-zero vector must produce a vector of magnitude 1.
	///
		@Test("Magnitude is 1.0")
		func magnitudeIsOne() async throws {
			let v = Vector2<Double>(x: 3.0, y: 4.0)
			let n = v.normalized
			#expect(n.magnitude.isApproximatelyEqual(to: 1.0))
		}

	/// Direction must be preserved after normalization.
	///
		@Test("Direction preserved")
		func directionPreserved() async throws {
			let v = Vector2<Double>(x: 3.0, y: 4.0)
			let n = v.normalized
			// Components should scale to 3/5 and 4/5 respectively.
			#expect(n.x.isApproximatelyEqual(to: 0.6))
			#expect(n.y.isApproximatelyEqual(to: 0.8))
		}

	/// Mutating normalize() must produce the same result as the computed property.
	///
		@Test("Mutating normalize()")
		func mutatingNormalize() async throws {
			var v = Vector2<Double>(x: 3.0, y: 4.0)
			let expected = v.normalized
			v.normalize()
			#expect(v.x.isApproximatelyEqual(to: expected.x))
			#expect(v.y.isApproximatelyEqual(to: expected.y))
		}
	}
}

// MARK: - EuclideanDistance

extension Vector2Tests {
	@Suite("EuclideanDistance")
	struct EuclideanDistanceSuite {
	/// Distance from (0,0) to (3,4) is 5 (3-4-5 triple).
	///
		@Test("distance")
		func distance() async throws {
			let a = Vector2<Double>(x: 0.0, y: 0.0)
			let b = Vector2<Double>(x: 3.0, y: 4.0)
			#expect(a.distance(to: b).isApproximatelyEqual(to: 5.0))
		}

	/// Squared distance from (0,0) to (3,4) is 25.
	///
		@Test("squaredDistance")
		func squaredDistance() async throws {
			let a = Vector2<Double>(x: 0.0, y: 0.0)
			let b = Vector2<Double>(x: 3.0, y: 4.0)
			#expect(a.squaredDistance(to: b).isApproximatelyEqual(to: 25.0))
		}

	/// Distance from (1,2) to (4,6) is 5 (3-4-5 triple shifted).
	///
		@Test("distance (offset)")
		func distanceOffset() async throws {
			let a = Vector2<Double>(x: 1.0, y: 2.0)
			let b = Vector2<Double>(x: 4.0, y: 6.0)
			#expect(a.distance(to: b).isApproximatelyEqual(to: 5.0))
		}
	}
}

// MARK: - Blendable

extension Vector2Tests {
	@Suite("Blendable")
	struct BlendableSuite {
	/// blend(amount: 0) must return the from vector.
	///
		@Test("blend 0.0 = from")
		func blendZero() async throws {
			let from = Vector2<Double>(x: 0.0, y: 0.0)
			let to = Vector2<Double>(x: 10.0, y: 20.0)
			let result = Vector2<Double>.blend(from: from, to: to, by: 0.0)
			#expect(result.x.isApproximatelyEqual(to: 0.0))
			#expect(result.y.isApproximatelyEqual(to: 0.0))
		}

	/// blend(amount: 1) must return the to vector.
	///
		@Test("blend 1.0 = to")
		func blendOne() async throws {
			let from = Vector2<Double>(x: 0.0, y: 0.0)
			let to = Vector2<Double>(x: 10.0, y: 20.0)
			let result = Vector2<Double>.blend(from: from, to: to, by: 1.0)
			#expect(result.x.isApproximatelyEqual(to: 10.0))
			#expect(result.y.isApproximatelyEqual(to: 20.0))
		}

	/// blend(amount: 0.5) must return the midpoint.
	///
		@Test("blend 0.5 = midpoint")
		func blendHalf() async throws {
			let from = Vector2<Double>(x: 0.0, y: 0.0)
			let to = Vector2<Double>(x: 10.0, y: 20.0)
			let result = Vector2<Double>.blend(from: from, to: to, by: 0.5)
			#expect(result.x.isApproximatelyEqual(to: 5.0))
			#expect(result.y.isApproximatelyEqual(to: 10.0))
		}
	}
}

// MARK: - AngleMeasurable

extension Vector2Tests {
	@Suite("AngleMeasurable")
	struct AngleMeasurableSuite {
	/// The angle between identical unit vectors is 0°.
	///
		@Test("Angle 0 degrees")
		func angleZeroDegrees() async throws {
			let v = Vector2<Double>(x: 1.0, y: 0.0)
			let angle = Vector2.angle(from: v, to: v, by: nil)
			#expect(angle.radians.isApproximatelyEqual(to: 0.0))
		}

	/// The angle between +X and +Y unit vectors is 90° (π/2 radians).
	///
		@Test("Angle 90 degrees")
		func angleNinetyDegrees() async throws {
			let a = Vector2<Double>(x: 1.0, y: 0.0)
			let b = Vector2<Double>(x: 0.0, y: 1.0)
			let angle = Vector2.angle(from: a, to: b, by: nil)
			#expect(angle.radians.isApproximatelyEqual(to: .pi / 2, relativeTolerance: 1e-10))
		}

	/// The angle between +X and -X unit vectors is 180° (π radians).
	///
		@Test("Angle 180 degrees")
		func angleOneEightyDegrees() async throws {
			let a = Vector2<Double>(x: 1.0, y: 0.0)
			let b = Vector2<Double>(x: -1.0, y: 0.0)
			let angle = Vector2.angle(from: a, to: b, by: nil)
			#expect(angle.radians.isApproximatelyEqual(to: .pi, relativeTolerance: 1e-10))
		}
	}
}

// MARK: - Reflection

extension Vector2Tests {
	@Suite("Reflection")
	struct ReflectionSuite {
	/// Reflecting an incoming ray (1, -1) off a flat horizontal surface
	/// (normal = (0, 1)) should give (1, 1).
	///
		@Test("Reflect off horizontal surface")
		func reflectHorizontalSurface() async throws {
			let ray = Vector2<Double>(x: 1.0, y: -1.0)
			let normal = Vector2<Double>(x: 0.0, y: 1.0)
			let result = ray.reflection(withNormal: normal)
			#expect(result.x.isApproximatelyEqual(to: 1.0))
			#expect(result.y.isApproximatelyEqual(to: 1.0))
		}

	/// Reflecting (-1, -1) off a vertical surface (normal = (1, 0)) gives
	/// (1, -1).
	///
		@Test("Reflect off vertical surface")
		func reflectVerticalSurface() async throws {
			let ray = Vector2<Double>(x: -1.0, y: -1.0)
			let normal = Vector2<Double>(x: 1.0, y: 0.0)
			let result = ray.reflection(withNormal: normal)
			#expect(result.x.isApproximatelyEqual(to: 1.0))
			#expect(result.y.isApproximatelyEqual(to: -1.0))
		}
	}
}

// MARK: - Refraction

extension Vector2Tests {
	@Suite("Refraction")
	struct RefractionSuite {
	/// Total internal reflection: when the incident angle exceeds the critical
	/// angle, refraction returns a zero vector.
	///
	/// A ray pointing almost parallel to the surface (grazing angle) with a
	/// large IOR will always undergo total internal reflection.
	///
		@Test("Total internal reflection returns zero")
		func totalInternalReflection() async throws {
			// Ray pointing mostly sideways (near-grazing angle), IOR > 1
			let ray = Vector2<Double>(x: 0.0, y: -1.0)
			let normal = Vector2<Double>(x: 0.0, y: 1.0)
			// IOR = 2.0, incident angle = 0° (straight on), sinSqRefracted = 4*(1-1) = 0 → no TIR here
			// Use a ray at a steep angle instead:
			// ray = (sin(70°), -cos(70°)) with n1=1.5 causes TIR
			let angle: Double = 70.0 * .pi / 180.0
			let steepRay = Vector2<Double>(x: Double.sin(angle), y: -Double.cos(angle))
			let result = steepRay.refraction(withNormal: normal, indexOfRefraction: 1.5)
			#expect(result.x.isApproximatelyEqual(to: 0.0))
			#expect(result.y.isApproximatelyEqual(to: 0.0))
		}

	/// Basic refraction: a ray coming straight down (0, -1) through a surface
	/// with normal (0, 1) and IOR = 1.0 (no change of medium) must pass
	/// straight through unchanged.
	///
		@Test("No-op refraction (IOR = 1.0)")
		func noOpRefraction() async throws {
			let ray = Vector2<Double>(x: 0.0, y: -1.0)
			let normal = Vector2<Double>(x: 0.0, y: 1.0)
			let result = ray.refraction(withNormal: normal, indexOfRefraction: 1.0)
			#expect(result.x.isApproximatelyEqual(to: 0.0))
			#expect(result.y.isApproximatelyEqual(to: -1.0))
		}
	}
}

// MARK: - SIMD

extension Vector2Tests {
	@Suite("SIMDConvertible")
	struct SIMDSuite {
	/// The .simd property must round-trip through the SIMD representation.
	///
		@Test("SIMD round-trip")
		func simdRoundTrip() async throws {
			let v = Vector2<Double>(x: 1.5, y: -2.5)
			let simdValue = v.simd
			let reconstructed = Vector2<Double>(simdValue)
			#expect(reconstructed.x == v.x)
			#expect(reconstructed.y == v.y)
		}

	#if canImport(simd)
	/// The .simd value must agree with the equivalent simd_double2.
	///
		@Test("SIMD matches simd_double2")
		func simdMatchesSIMD2() async throws {
			let v = Vector2<Double>(x: 3.0, y: 4.0)
			let reference = simd_double2(3.0, 4.0)
			#expect(v.simd.x == reference.x)
			#expect(v.simd.y == reference.y)
		}
	#endif
	}
}
