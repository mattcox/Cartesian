//
//  Quaternion.swift
//  Cartesian
//
//  Created by Matt Cox on 02/07/2025.
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

@Suite("Quaternion")
struct QuaternionTests {
/// Tests the default initializer, which is expected to create a quaternion
/// with all components set to zero.
///
/// Output:
/// ```swift
/// imaginary = (0, 0, 0), real = 0
/// ```
///
	@Test("Initializer")
	func initializer() async throws {
		let q = Quaternion<Double>()
		#expect(q.imaginary[0] == .zero)
		#expect(q.imaginary[1] == .zero)
		#expect(q.imaginary[2] == .zero)
		#expect(q.real == .zero)
	}

/// Tests the imaginary/real component initializer.
///
/// Input:
/// ```swift
/// imaginary = (1, 2, 3), real = 4
/// ```
///
/// Output:
/// ```swift
/// imaginary = (1, 2, 3), real = 4
/// ```
///
	@Test("Initializer (imaginary:real:)")
	func initializerImaginaryReal() async throws {
		let q = Quaternion<Double>(imaginary: Vector3(1.0, 2.0, 3.0), real: 4.0)
		#expect(q.imaginary[0] == 1.0)
		#expect(q.imaginary[1] == 2.0)
		#expect(q.imaginary[2] == 3.0)
		#expect(q.real == 4.0)
	}

/// Tests the array literal initializer.
///
/// Elements map to [imaginary.x, imaginary.y, imaginary.z, real].
///
/// Input:
/// ```swift
/// [1.0, 2.0, 3.0, 4.0]
/// ```
///
/// Output:
/// ```swift
/// imaginary = (1, 2, 3), real = 4
/// ```
///
	@Test("Initializer (arrayLiteral)")
	func initializerArrayLiteral() async throws {
		let q: Quaternion<Double> = [1.0, 2.0, 3.0, 4.0]
		#expect(q.imaginary[0] == 1.0)
		#expect(q.imaginary[1] == 2.0)
		#expect(q.imaginary[2] == 3.0)
		#expect(q.real == 4.0)
	}

/// Tests the axis-angle initializer for a 90° rotation around the Z axis.
///
/// A 90° rotation around Z should give:
///   imaginary = (0, 0, sin(π/4)) ≈ (0, 0, 0.7071)
///   real = cos(π/4) ≈ 0.7071
///
	@Test("Initializer (withAxis:angle:)")
	func initializerWithAxisAngle() async throws {
		let axis = Vector3<Double>(0.0, 0.0, 1.0)
		let angle = Angle<Double>(radians: Double.pi / 2.0)
		let q = Quaternion(withAxis: axis, angle: angle)

		let sinHalf = Double.sin(Double.pi / 4.0) // ≈ 0.7071067811865476
		let cosHalf = Double.cos(Double.pi / 4.0) // ≈ 0.7071067811865476

		#expect(q.imaginary[0].isApproximatelyEqual(to: 0.0))
		#expect(q.imaginary[1].isApproximatelyEqual(to: 0.0))
		#expect(q.imaginary[2].isApproximatelyEqual(to: sinHalf))
		#expect(q.real.isApproximatelyEqual(to: cosHalf))
	}

/// Tests JSON encode/decode round-trip.
///
	@Test("Serialization")
	func serialization() async throws {
		let q = Quaternion<Double>(imaginary: Vector3(0.5, -0.25, 0.75), real: 0.3)
		let encoded = try JSONEncoder().encode(q)
		let decoded = try JSONDecoder().decode(Quaternion<Double>.self, from: encoded)

		#expect(q.imaginary[0] == decoded.imaginary[0])
		#expect(q.imaginary[1] == decoded.imaginary[1])
		#expect(q.imaginary[2] == decoded.imaginary[2])
		#expect(q.real == decoded.real)
	}

/// Tests that the imaginary setter correctly updates the imaginary components.
///
	@Test("Component Accessors — imaginary setter")
	func componentAccessorsImaginarySetter() async throws {
		var q = Quaternion<Double>(imaginary: Vector3(1.0, 2.0, 3.0), real: 4.0)
		q.imaginary = Vector3(7.0, 8.0, 9.0)
		#expect(q.imaginary[0] == 7.0)
		#expect(q.imaginary[1] == 8.0)
		#expect(q.imaginary[2] == 9.0)
		#expect(q.real == 4.0)
	}

/// Tests that the real setter correctly updates the real component without
/// disturbing the imaginary part.
///
	@Test("Component Accessors — real setter")
	func componentAccessorsRealSetter() async throws {
		var q = Quaternion<Double>(imaginary: Vector3(1.0, 2.0, 3.0), real: 4.0)
		q.real = 99.0
		#expect(q.imaginary[0] == 1.0)
		#expect(q.imaginary[1] == 2.0)
		#expect(q.imaginary[2] == 3.0)
		#expect(q.real == 99.0)
	}

/// Tests Equatable conformance.
///
	@Test("Equatable")
	func equatable() async throws {
		let a = Quaternion<Double>(imaginary: Vector3(1.0, 2.0, 3.0), real: 4.0)
		let b = Quaternion<Double>(imaginary: Vector3(1.0, 2.0, 3.0), real: 4.0)
		let c = Quaternion<Double>(imaginary: Vector3(1.0, 2.0, 3.0), real: 5.0)

		#expect(a == b)
		#expect(a != c)
		#expect(a == a)
	}

/// Tests Hashable conformance: equal quaternions must produce the same hash.
///
	@Test("Hashable")
	func hashable() async throws {
		let a = Quaternion<Double>(imaginary: Vector3(1.0, 2.0, 3.0), real: 4.0)
		let b = Quaternion<Double>(imaginary: Vector3(1.0, 2.0, 3.0), real: 4.0)
		#expect(a.hashValue == b.hashValue)
	}
}

// MARK: - Identity

extension QuaternionTests {
	@Suite("Identity")
	struct Identity {
	/// Tests that the identity quaternion has imaginary = (0,0,0), real = 1.
	///
		@Test("identity")
		func identity() async throws {
			let id = Quaternion<Double>.identity
			#expect(id.imaginary[0] == 0.0)
			#expect(id.imaginary[1] == 0.0)
			#expect(id.imaginary[2] == 0.0)
			#expect(id.real == 1.0)
		}

	/// Tests that isIdentity returns true for the identity quaternion.
	///
		@Test("isIdentity #1")
		func isIdentity_1() async throws {
			#expect(Quaternion<Double>.identity.isIdentity == true)
		}

	/// Tests that isIdentity returns false for the zero quaternion.
	///
		@Test("isIdentity #2")
		func isIdentity_2() async throws {
			#expect(Quaternion<Double>().isIdentity == false)
		}

	/// Tests that isIdentity returns false for a non-identity quaternion.
	///
		@Test("isIdentity #3")
		func isIdentity_3() async throws {
			let q = Quaternion<Double>(imaginary: Vector3(0.0, 0.0, 0.1), real: 0.995)
			#expect(q.isIdentity == false)
		}

	/// Tests that toIdentity() resets the quaternion to identity.
	///
		@Test("toIdentity")
		func toIdentity() async throws {
			var q = Quaternion<Double>(imaginary: Vector3(0.5, 0.5, 0.5), real: 0.5)
			#expect(q.isIdentity == false)
			q.toIdentity()
			#expect(q.isIdentity == true)
			#expect(q.imaginary[0] == 0.0)
			#expect(q.imaginary[1] == 0.0)
			#expect(q.imaginary[2] == 0.0)
			#expect(q.real == 1.0)
		}
	}
}

// MARK: - Normalizable

extension QuaternionTests {
	@Suite("Normalizable")
	struct Normalizable {
	/// Tests that normalized produces a unit quaternion.
	///
	/// Input: imaginary=(3,1,4), real=1 (not unit length)
	///
		@Test("normalized")
		func normalized() async throws {
			let q = Quaternion<Double>(imaginary: Vector3(3.0, 1.0, 4.0), real: 1.0)
			let n = q.normalized
			// A normalized quaternion must have magnitude ≈ 1.
			let mag = Double.sqrt(
				n.imaginary[0] * n.imaginary[0] +
				n.imaginary[1] * n.imaginary[1] +
				n.imaginary[2] * n.imaginary[2] +
				n.real * n.real
			)
			#expect(mag.isApproximatelyEqual(to: 1.0))
		}

	/// Tests that the mutating normalize() function produces the same result
	/// as the computed property.
	///
		@Test("normalize()")
		func normalize() async throws {
			let q = Quaternion<Double>(imaginary: Vector3(3.0, 1.0, 4.0), real: 1.0)
			var mutable = q
			mutable.normalize()
			let expected = q.normalized
			#expect(mutable.imaginary[0].isApproximatelyEqual(to: expected.imaginary[0]))
			#expect(mutable.imaginary[1].isApproximatelyEqual(to: expected.imaginary[1]))
			#expect(mutable.imaginary[2].isApproximatelyEqual(to: expected.imaginary[2]))
			#expect(mutable.real.isApproximatelyEqual(to: expected.real))
		}
	}
}

// MARK: - Conjugate

extension QuaternionTests {
	@Suite("Conjugate")
	struct Conjugate {
	/// Tests that conjugate negates the imaginary part and keeps the real part.
	///
		@Test("conjugate negates imaginary")
		func conjugateNegatesImaginary() async throws {
			let q = Quaternion<Double>(imaginary: Vector3(1.0, 2.0, 3.0), real: 4.0)
			let c = q.conjugate
			#expect(c.imaginary[0] == -1.0)
			#expect(c.imaginary[1] == -2.0)
			#expect(c.imaginary[2] == -3.0)
			#expect(c.real == 4.0)
		}

	/// For a unit quaternion q, q * conjugate(q) should equal the identity.
	///
	/// q * q* = (imaginary * real2 + imaginary2 * real + cross)
	/// For a unit quaternion the real part = dot(q,q) = 1, imaginary = 0.
	///
		@Test("q * conjugate(q) = identity (unit quaternion)")
		func unitTimesConjugateIsIdentity() async throws {
			// Use 90° around Z, which is already unit.
			let q = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let product = q * q.conjugate
			// Real part should equal |q|² = 1.
			// Imaginary part should be zero.
			#expect(product.imaginary[0].isApproximatelyEqual(to: 0.0))
			#expect(product.imaginary[1].isApproximatelyEqual(to: 0.0))
			#expect(product.imaginary[2].isApproximatelyEqual(to: 0.0))
			#expect(product.real.isApproximatelyEqual(to: 1.0))
		}

	/// For a non-unit quaternion q, q * conjugate(q) real part = |q|².
	///
		@Test("q * conjugate(q) real = dot(q,q)")
		func timesConjugateRealIsDotProduct() async throws {
			let q = Quaternion<Double>(imaginary: Vector3(1.0, 2.0, 3.0), real: 4.0)
			let dotQQ = q.dot(q) // 1+4+9+16 = 30
			let product = q * q.conjugate
			#expect(product.real.isApproximatelyEqual(to: dotQQ))
			#expect(product.imaginary[0].isApproximatelyEqual(to: 0.0))
			#expect(product.imaginary[1].isApproximatelyEqual(to: 0.0))
			#expect(product.imaginary[2].isApproximatelyEqual(to: 0.0))
		}
	}
}

// MARK: - Dot Product

extension QuaternionTests {
	@Suite("Dot Product")
	struct DotProduct {
	/// Tests that a unit quaternion dotted with itself equals 1.
	///
		@Test("unit dot unit = 1")
		func unitDotUnit() async throws {
			let q = Quaternion<Double>.identity
			#expect(q.dot(q).isApproximatelyEqual(to: 1.0))
		}

	/// Tests the dot product formula: sum of component products.
	///
		@Test("dot product formula")
		func dotProductFormula() async throws {
			let q1 = Quaternion<Double>(imaginary: Vector3(1.0, 2.0, 3.0), real: 4.0)
			let q2 = Quaternion<Double>(imaginary: Vector3(5.0, 6.0, 7.0), real: 8.0)
			// dot = 1*5 + 2*6 + 3*7 + 4*8 = 5 + 12 + 21 + 32 = 70
			#expect(q1.dot(q2).isApproximatelyEqual(to: 70.0))
		}

	/// Tests that the dot product of a non-unit quaternion with itself equals
	/// the squared magnitude.
	///
		@Test("dot(q,q) = magnitude squared")
		func dotSelfIsMagnitudeSquared() async throws {
			let q = Quaternion<Double>(imaginary: Vector3(1.0, 2.0, 3.0), real: 4.0)
			let magSquared = 1.0 + 4.0 + 9.0 + 16.0 // = 30
			#expect(q.dot(q).isApproximatelyEqual(to: magSquared))
		}
	}
}

// MARK: - Hamilton Product

extension QuaternionTests {
	@Suite("Hamilton Product")
	struct HamiltonProduct {
	/// Tests that identity * q = q.
	///
		@Test("identity * q = q")
		func identityLeftMultiply() async throws {
			let q = Quaternion<Double>(imaginary: Vector3(0.5, 0.5, 0.5), real: 0.5)
			let result = Quaternion<Double>.identity * q
			#expect(result.imaginary[0].isApproximatelyEqual(to: q.imaginary[0]))
			#expect(result.imaginary[1].isApproximatelyEqual(to: q.imaginary[1]))
			#expect(result.imaginary[2].isApproximatelyEqual(to: q.imaginary[2]))
			#expect(result.real.isApproximatelyEqual(to: q.real))
		}

	/// Tests that q * identity = q.
	///
		@Test("q * identity = q")
		func identityRightMultiply() async throws {
			let q = Quaternion<Double>(imaginary: Vector3(0.5, 0.5, 0.5), real: 0.5)
			let result = q * Quaternion<Double>.identity
			#expect(result.imaginary[0].isApproximatelyEqual(to: q.imaginary[0]))
			#expect(result.imaginary[1].isApproximatelyEqual(to: q.imaginary[1]))
			#expect(result.imaginary[2].isApproximatelyEqual(to: q.imaginary[2]))
			#expect(result.real.isApproximatelyEqual(to: q.real))
		}

	/// Tests the basis product i * j = k.
	///
	/// i = (1,0,0,0), j = (0,1,0,0), k = (0,0,1,0)
	/// i*j: imaginary = i×j + i*0 + j*0 = k, real = 0*0 - i·j = 0
	/// Result: (0,0,1,0)
	///
		@Test("i * j = k")
		func basisITimesJ() async throws {
			let i = Quaternion<Double>(imaginary: Vector3(1.0, 0.0, 0.0), real: 0.0)
			let j = Quaternion<Double>(imaginary: Vector3(0.0, 1.0, 0.0), real: 0.0)
			let result = i * j
			#expect(result.imaginary[0].isApproximatelyEqual(to: 0.0))
			#expect(result.imaginary[1].isApproximatelyEqual(to: 0.0))
			#expect(result.imaginary[2].isApproximatelyEqual(to: 1.0))
			#expect(result.real.isApproximatelyEqual(to: 0.0))
		}

	/// Tests the basis product j * k = i.
	///
	/// j = (0,1,0,0), k = (0,0,1,0)
	/// j×k = (1,0,0), real = 0*0 - j·k = 0
	/// Result: (1,0,0,0)
	///
		@Test("j * k = i")
		func basisJTimesK() async throws {
			let j = Quaternion<Double>(imaginary: Vector3(0.0, 1.0, 0.0), real: 0.0)
			let k = Quaternion<Double>(imaginary: Vector3(0.0, 0.0, 1.0), real: 0.0)
			let result = j * k
			#expect(result.imaginary[0].isApproximatelyEqual(to: 1.0))
			#expect(result.imaginary[1].isApproximatelyEqual(to: 0.0))
			#expect(result.imaginary[2].isApproximatelyEqual(to: 0.0))
			#expect(result.real.isApproximatelyEqual(to: 0.0))
		}

	/// Tests the basis product k * i = j.
	///
	/// k = (0,0,1,0), i = (1,0,0,0)
	/// k×i = (0,1,0), real = 0*0 - k·i = 0
	/// Result: (0,1,0,0)
	///
		@Test("k * i = j")
		func basisKTimesI() async throws {
			let k = Quaternion<Double>(imaginary: Vector3(0.0, 0.0, 1.0), real: 0.0)
			let i = Quaternion<Double>(imaginary: Vector3(1.0, 0.0, 0.0), real: 0.0)
			let result = k * i
			#expect(result.imaginary[0].isApproximatelyEqual(to: 0.0))
			#expect(result.imaginary[1].isApproximatelyEqual(to: 1.0))
			#expect(result.imaginary[2].isApproximatelyEqual(to: 0.0))
			#expect(result.real.isApproximatelyEqual(to: 0.0))
		}

	/// Tests the basis product i * i = -1.
	///
	/// i = (1,0,0,0)
	/// i×i = (0,0,0), real = 0*0 - i·i = -1
	/// Result: (0,0,0,-1)
	///
		@Test("i * i = -1")
		func basisISquared() async throws {
			let i = Quaternion<Double>(imaginary: Vector3(1.0, 0.0, 0.0), real: 0.0)
			let result = i * i
			#expect(result.imaginary[0].isApproximatelyEqual(to: 0.0))
			#expect(result.imaginary[1].isApproximatelyEqual(to: 0.0))
			#expect(result.imaginary[2].isApproximatelyEqual(to: 0.0))
			#expect(result.real.isApproximatelyEqual(to: -1.0))
		}

	/// Tests that quaternion multiplication is non-commutative.
	///
	/// For q1 = 90° around X and q2 = 90° around Y:
	/// q1 * q2 ≠ q2 * q1
	///
		@Test("Non-commutativity")
		func nonCommutativity() async throws {
			let q1 = Quaternion<Double>(
				withAxis: Vector3(1.0, 0.0, 0.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let q2 = Quaternion<Double>(
				withAxis: Vector3(0.0, 1.0, 0.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let forward = q1 * q2
			let reverse = q2 * q1
			// At least one component must differ.
			let imaginaryDiffers =
				!forward.imaginary[0].isApproximatelyEqual(to: reverse.imaginary[0]) ||
				!forward.imaginary[1].isApproximatelyEqual(to: reverse.imaginary[1]) ||
				!forward.imaginary[2].isApproximatelyEqual(to: reverse.imaginary[2])
			let realDiffers = !forward.real.isApproximatelyEqual(to: reverse.real)
			#expect(imaginaryDiffers || realDiffers)
		}

	/// Tests quaternion multiplication against simd_quatd where available.
	///
		@Test("simd comparison")
		func simdComparison() async throws {
		#if canImport(simd)
			let q1 = Quaternion<Double>(
				withAxis: Vector3(1.0, 0.0, 0.0),
				angle: Angle(radians: Double.pi / 3.0)
			)
			let q2 = Quaternion<Double>(
				withAxis: Vector3(0.0, 1.0, 0.0),
				angle: Angle(radians: Double.pi / 4.0)
			)
			let result = q1 * q2

			let sq1 = simd_quatd(ix: q1.imaginary[0], iy: q1.imaginary[1], iz: q1.imaginary[2], r: q1.real)
			let sq2 = simd_quatd(ix: q2.imaginary[0], iy: q2.imaginary[1], iz: q2.imaginary[2], r: q2.real)
			let sResult = sq1 * sq2

			#expect(result.imaginary[0].isApproximatelyEqual(to: sResult.imag.x))
			#expect(result.imaginary[1].isApproximatelyEqual(to: sResult.imag.y))
			#expect(result.imaginary[2].isApproximatelyEqual(to: sResult.imag.z))
			#expect(result.real.isApproximatelyEqual(to: sResult.real))
		#endif
		}

	/// Tests the compound assignment operator *=.
	///
		@Test("*= operator")
		func compoundAssignment() async throws {
			let q1 = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 4.0)
			)
			let q2 = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 4.0)
			)
			var mutable = q1
			mutable *= q2
			let expected = q1 * q2
			#expect(mutable.imaginary[0].isApproximatelyEqual(to: expected.imaginary[0]))
			#expect(mutable.imaginary[1].isApproximatelyEqual(to: expected.imaginary[1]))
			#expect(mutable.imaginary[2].isApproximatelyEqual(to: expected.imaginary[2]))
			#expect(mutable.real.isApproximatelyEqual(to: expected.real))
		}
	}
}

// MARK: - Scalar Arithmetic

extension QuaternionTests {
	@Suite("Scalar Arithmetic")
	struct ScalarArithmetic {
	/// Tests that dividing by 2.0 halves all components.
	///
		@Test("q / 2.0")
		func divideByScalar() async throws {
			let q = Quaternion<Double>(imaginary: Vector3(2.0, 4.0, 6.0), real: 8.0)
			let result = q / 2.0
			#expect(result.imaginary[0].isApproximatelyEqual(to: 1.0))
			#expect(result.imaginary[1].isApproximatelyEqual(to: 2.0))
			#expect(result.imaginary[2].isApproximatelyEqual(to: 3.0))
			#expect(result.real.isApproximatelyEqual(to: 4.0))
		}

	/// Tests that multiplying by a scalar scales all components.
	///
		@Test("q * scalar")
		func multiplyByScalar() async throws {
			let q = Quaternion<Double>(imaginary: Vector3(1.0, 2.0, 3.0), real: 4.0)
			let result = q * 3.0
			#expect(result.imaginary[0].isApproximatelyEqual(to: 3.0))
			#expect(result.imaginary[1].isApproximatelyEqual(to: 6.0))
			#expect(result.imaginary[2].isApproximatelyEqual(to: 9.0))
			#expect(result.real.isApproximatelyEqual(to: 12.0))
		}

	/// Tests scalar * quaternion commutativity for scalar multiplication.
	///
		@Test("scalar * q")
		func scalarTimesQuaternion() async throws {
			let q = Quaternion<Double>(imaginary: Vector3(1.0, 2.0, 3.0), real: 4.0)
			let result = 3.0 * q
			#expect(result.imaginary[0].isApproximatelyEqual(to: 3.0))
			#expect(result.imaginary[1].isApproximatelyEqual(to: 6.0))
			#expect(result.imaginary[2].isApproximatelyEqual(to: 9.0))
			#expect(result.real.isApproximatelyEqual(to: 12.0))
		}

	/// Tests component-wise addition of two quaternions.
	///
		@Test("q1 + q2")
		func componentWiseAddition() async throws {
			let q1 = Quaternion<Double>(imaginary: Vector3(1.0, 2.0, 3.0), real: 4.0)
			let q2 = Quaternion<Double>(imaginary: Vector3(5.0, 6.0, 7.0), real: 8.0)
			let result = q1 + q2
			#expect(result.imaginary[0].isApproximatelyEqual(to: 6.0))
			#expect(result.imaginary[1].isApproximatelyEqual(to: 8.0))
			#expect(result.imaginary[2].isApproximatelyEqual(to: 10.0))
			#expect(result.real.isApproximatelyEqual(to: 12.0))
		}

	/// Tests component-wise subtraction of two quaternions.
	///
		@Test("q1 - q2")
		func componentWiseSubtraction() async throws {
			let q1 = Quaternion<Double>(imaginary: Vector3(5.0, 6.0, 7.0), real: 8.0)
			let q2 = Quaternion<Double>(imaginary: Vector3(1.0, 2.0, 3.0), real: 4.0)
			let result = q1 - q2
			#expect(result.imaginary[0].isApproximatelyEqual(to: 4.0))
			#expect(result.imaginary[1].isApproximatelyEqual(to: 4.0))
			#expect(result.imaginary[2].isApproximatelyEqual(to: 4.0))
			#expect(result.real.isApproximatelyEqual(to: 4.0))
		}

	/// Tests the negation prefix operator.
	///
	/// -q should negate all four components.
	///
		@Test("negation")
		func negation() async throws {
			let q = Quaternion<Double>(imaginary: Vector3(1.0, 2.0, 3.0), real: 4.0)
			let result = -q
			#expect(result.imaginary[0].isApproximatelyEqual(to: -1.0))
			#expect(result.imaginary[1].isApproximatelyEqual(to: -2.0))
			#expect(result.imaginary[2].isApproximatelyEqual(to: -3.0))
			#expect(result.real.isApproximatelyEqual(to: -4.0))
		}
	}
}

// MARK: - Invertible

extension QuaternionTests {
	@Suite("Invertible")
	struct Invertible {
	/// Tests that the inverse of the identity quaternion is identity.
	///
		@Test("inverse of identity")
		func inverseOfIdentity() async throws {
			let id = Quaternion<Double>.identity
			let inv = id.inverse
			#expect(inv != nil)
			#expect(inv!.imaginary[0].isApproximatelyEqual(to: 0.0))
			#expect(inv!.imaginary[1].isApproximatelyEqual(to: 0.0))
			#expect(inv!.imaginary[2].isApproximatelyEqual(to: 0.0))
			#expect(inv!.real.isApproximatelyEqual(to: 1.0))
		}

	/// Tests that q * q.inverse ≈ identity.
	///
		@Test("q * q.inverse = identity")
		func timesInverseIsIdentity() async throws {
			let q = Quaternion<Double>(
				withAxis: Vector3(1.0, 1.0, 0.0),
				angle: Angle(radians: Double.pi / 3.0)
			)
			let inv = q.inverse
			#expect(inv != nil)
			let product = q * inv!
			#expect(product.imaginary[0].isApproximatelyEqual(to: 0.0))
			#expect(product.imaginary[1].isApproximatelyEqual(to: 0.0))
			#expect(product.imaginary[2].isApproximatelyEqual(to: 0.0))
			#expect(product.real.isApproximatelyEqual(to: 1.0))
		}

	/// Tests that the zero quaternion has no inverse.
	///
		@Test("zero quaternion has no inverse")
		func zeroHasNoInverse() async throws {
			let zero = Quaternion<Double>()
			#expect(zero.inverse == nil)
		}

	/// Tests that invert() returns true for an invertible quaternion and
	/// mutates it to the inverse.
	///
		@Test("invert() returns true and mutates")
		func invertReturnsTrueAndMutates() async throws {
			let q = Quaternion<Double>.identity
			var mutable = q
			let succeeded = mutable.invert()
			#expect(succeeded == true)
			#expect(mutable.imaginary[0].isApproximatelyEqual(to: 0.0))
			#expect(mutable.imaginary[1].isApproximatelyEqual(to: 0.0))
			#expect(mutable.imaginary[2].isApproximatelyEqual(to: 0.0))
			#expect(mutable.real.isApproximatelyEqual(to: 1.0))
		}

	/// Tests that invert() returns false for the zero quaternion and leaves
	/// it unchanged.
	///
		@Test("invert() returns false for zero quaternion")
		func invertReturnsFalseForZero() async throws {
			var zero = Quaternion<Double>()
			let succeeded = zero.invert()
			#expect(succeeded == false)
			// Should remain zero.
			#expect(zero.imaginary[0] == 0.0)
			#expect(zero.real == 0.0)
		}
	}
}

// MARK: - Vector Rotation

extension QuaternionTests {
	@Suite("Vector Rotation")
	struct VectorRotation {
	/// Tests that a 90° rotation around Z maps (1,0,0) → (0,1,0).
	///
		@Test("90° around Z: (1,0,0) → (0,1,0)")
		func rotate90DegZ() async throws {
			let q = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let v = Vector3<Double>(1.0, 0.0, 0.0)
			let result = q.rotate(vector: v)
			#expect(result[0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(result[1].isApproximatelyEqual(to: 1.0))
			#expect(result[2].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
		}

	/// Tests that a 90° rotation around X maps (0,1,0) → (0,0,1).
	///
		@Test("90° around X: (0,1,0) → (0,0,1)")
		func rotate90DegX() async throws {
			let q = Quaternion<Double>(
				withAxis: Vector3(1.0, 0.0, 0.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let v = Vector3<Double>(0.0, 1.0, 0.0)
			let result = q.rotate(vector: v)
			#expect(result[0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(result[1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(result[2].isApproximatelyEqual(to: 1.0))
		}

	/// Tests that a 90° rotation around Y maps (0,0,1) → (1,0,0).
	///
		@Test("90° around Y: (0,0,1) → (1,0,0)")
		func rotate90DegY() async throws {
			let q = Quaternion<Double>(
				withAxis: Vector3(0.0, 1.0, 0.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let v = Vector3<Double>(0.0, 0.0, 1.0)
			let result = q.rotate(vector: v)
			#expect(result[0].isApproximatelyEqual(to: 1.0))
			#expect(result[1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(result[2].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
		}

	/// Tests that q.rotate(vector:) agrees with the matrix form q.matrix * v
	/// for a 90° rotation around Z.
	///
		@Test("rotate(vector:) matches matrix * v (Z axis)")
		func rotateMatchesMatrixZ() async throws {
			let q = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let v = Vector3<Double>(1.0, 0.0, 0.0)
			let fromRotate = q.rotate(vector: v)
			let fromMatrix = q.matrix * v
			#expect(fromRotate[0].isApproximatelyEqual(to: fromMatrix[0]))
			#expect(fromRotate[1].isApproximatelyEqual(to: fromMatrix[1]))
			#expect(fromRotate[2].isApproximatelyEqual(to: fromMatrix[2]))
		}

	/// Tests that q.rotate(vector:) agrees with the matrix form q.matrix * v
	/// for a 90° rotation around X.
	///
		@Test("rotate(vector:) matches matrix * v (X axis)")
		func rotateMatchesMatrixX() async throws {
			let q = Quaternion<Double>(
				withAxis: Vector3(1.0, 0.0, 0.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let v = Vector3<Double>(0.0, 1.0, 0.0)
			let fromRotate = q.rotate(vector: v)
			let fromMatrix = q.matrix * v
			#expect(fromRotate[0].isApproximatelyEqual(to: fromMatrix[0]))
			#expect(fromRotate[1].isApproximatelyEqual(to: fromMatrix[1]))
			#expect(fromRotate[2].isApproximatelyEqual(to: fromMatrix[2]))
		}

	/// Tests that q.rotate(vector:) agrees with the matrix form q.matrix * v
	/// for an arbitrary rotation.
	///
		@Test("rotate(vector:) matches matrix * v (arbitrary)")
		func rotateMatchesMatrixArbitrary() async throws {
			let q = Quaternion<Double>(
				withAxis: Vector3(1.0, 1.0, 1.0),
				angle: Angle(radians: Double.pi / 3.0)
			)
			let v = Vector3<Double>(2.0, -1.0, 3.0)
			let fromRotate = q.rotate(vector: v)
			let fromMatrix = q.matrix * v
			#expect(fromRotate[0].isApproximatelyEqual(to: fromMatrix[0]))
			#expect(fromRotate[1].isApproximatelyEqual(to: fromMatrix[1]))
			#expect(fromRotate[2].isApproximatelyEqual(to: fromMatrix[2]))
		}

	/// Tests that q.rotate(vector:) matches simd_quatd.act(_:) for a 90°
	/// rotation around Z.
	///
		@Test("rotate(vector:) matches simd act")
		func rotateMatchesSimdAct() async throws {
		#if canImport(simd)
			let q = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let v = Vector3<Double>(1.0, 0.0, 0.0)
			let result = q.rotate(vector: v)

			let sq = simd_quatd(ix: q.imaginary[0], iy: q.imaginary[1], iz: q.imaginary[2], r: q.real)
			let sv = SIMD3<Double>(1.0, 0.0, 0.0)
			let sResult = sq.act(sv)

			#expect(result[0].isApproximatelyEqual(to: sResult.x, absoluteTolerance: 1e-12))
			#expect(result[1].isApproximatelyEqual(to: sResult.y, absoluteTolerance: 1e-12))
			#expect(result[2].isApproximatelyEqual(to: sResult.z, absoluteTolerance: 1e-12))
		#endif
		}

	/// Tests that QuaternionRotatable.rotated(by:) gives the same result as
	/// q.rotate(vector:).
	///
		@Test("rotated(by:) protocol method")
		func rotatedByProtocol() async throws {
			let q = Quaternion<Double>(
				withAxis: Vector3(0.0, 1.0, 0.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let v = Vector3<Double>(0.0, 0.0, 1.0)
			let fromRotate = q.rotate(vector: v)
			let fromRotated = v.rotated(by: q)
			#expect(fromRotated[0].isApproximatelyEqual(to: fromRotate[0]))
			#expect(fromRotated[1].isApproximatelyEqual(to: fromRotate[1]))
			#expect(fromRotated[2].isApproximatelyEqual(to: fromRotate[2]))
		}
	}
}

// MARK: - Matrix

extension QuaternionTests {
	@Suite("Matrix")
	struct MatrixTests {
	/// Tests that the identity quaternion produces an identity matrix.
	///
		@Test("identity quaternion → identity matrix")
		func identityQuaternionMatrix() async throws {
			let m = Quaternion<Double>.identity.matrix
			for col in 0..<3 {
				for row in 0..<3 {
					let expected = (col == row) ? 1.0 : 0.0
					#expect(m[col][row].isApproximatelyEqual(to: expected))
				}
			}
		}

	/// Tests the rotation matrix for a 90° rotation around Z.
	///
	/// Expected result: column-major
	///   col 0: (0, 1, 0)   [x-axis maps to y-axis]
	///   col 1: (-1, 0, 0)  [y-axis maps to -x-axis]
	///   col 2: (0, 0, 1)   [z-axis unchanged]
	///
	/// In column-major matrix[col][row]:
	///   matrix[0][0] ≈  0   matrix[0][1] ≈  1   matrix[0][2] ≈ 0
	///   matrix[1][0] ≈ -1   matrix[1][1] ≈  0   matrix[1][2] ≈ 0
	///   matrix[2][0] ≈  0   matrix[2][1] ≈  0   matrix[2][2] ≈ 1
	///
		@Test("90° around Z matrix")
		func matrix90DegZ() async throws {
			let q = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let m = q.matrix
			// Column 0 (the column that x-hat maps to): should be (0, 1, 0)
			#expect(m[0][0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(m[0][1].isApproximatelyEqual(to: 1.0))
			#expect(m[0][2].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			// Column 1 (what y-hat maps to): should be (-1, 0, 0)
			#expect(m[1][0].isApproximatelyEqual(to: -1.0))
			#expect(m[1][1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(m[1][2].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			// Column 2 (what z-hat maps to): should be (0, 0, 1)
			#expect(m[2][0].isApproximatelyEqual(to: 0.0))
			#expect(m[2][1].isApproximatelyEqual(to: 0.0))
			#expect(m[2][2].isApproximatelyEqual(to: 1.0))
		}

	/// Tests that q.matrix agrees with simd_quatd.act matrix for an
	/// arbitrary rotation.
	///
		@Test("matrix matches simd")
		func matrixMatchesSimd() async throws {
		#if canImport(simd)
			let q = Quaternion<Double>(
				withAxis: Vector3(1.0, 1.0, 1.0),
				angle: Angle(radians: Double.pi / 4.0)
			)
			let m = q.matrix

			// simd_quatd produces a matrix3x3: ask it to act on basis vectors
			// and compare with our matrix columns.
			let sq = simd_quatd(ix: q.imaginary[0], iy: q.imaginary[1], iz: q.imaginary[2], r: q.real)
			let smX = sq.act(SIMD3<Double>(1.0, 0.0, 0.0))
			let smY = sq.act(SIMD3<Double>(0.0, 1.0, 0.0))
			let smZ = sq.act(SIMD3<Double>(0.0, 0.0, 1.0))

			// Column 0 = where x-hat goes
			#expect(m[0][0].isApproximatelyEqual(to: smX.x))
			#expect(m[0][1].isApproximatelyEqual(to: smX.y))
			#expect(m[0][2].isApproximatelyEqual(to: smX.z))
			// Column 1 = where y-hat goes
			#expect(m[1][0].isApproximatelyEqual(to: smY.x))
			#expect(m[1][1].isApproximatelyEqual(to: smY.y))
			#expect(m[1][2].isApproximatelyEqual(to: smY.z))
			// Column 2 = where z-hat goes
			#expect(m[2][0].isApproximatelyEqual(to: smZ.x))
			#expect(m[2][1].isApproximatelyEqual(to: smZ.y))
			#expect(m[2][2].isApproximatelyEqual(to: smZ.z))
		#endif
		}

	/// Tests that setting the matrix property updates the quaternion via
	/// Shepperd's method and the resulting quaternion still encodes the
	/// same rotation.
	///
		@Test("matrix setter round-trip")
		func matrixSetterRoundTrip() async throws {
			var q = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let originalMatrix = q.matrix
			q.matrix = originalMatrix
			// The resulting quaternion's matrix should match the original.
			let recoveredMatrix = q.matrix
			for col in 0..<3 {
				for row in 0..<3 {
					#expect(recoveredMatrix[col][row].isApproximatelyEqual(to: originalMatrix[col][row]))
				}
			}
		}
	}
}

// MARK: - init(withMatrix:) — Shepperd Method

extension QuaternionTests {
	@Suite("Shepperd Method (init(withMatrix:))")
	struct ShepperdMethod {
	/// Helper: verifies that q2.rotate(v) ≈ q1.rotate(v) for several vectors.
	///
		private func assertSameRotation(
			_ q1: Quaternion<Double>,
			_ q2: Quaternion<Double>
		) {
			let vectors: [Vector3<Double>] = [
				Vector3(1.0, 0.0, 0.0),
				Vector3(0.0, 1.0, 0.0),
				Vector3(0.0, 0.0, 1.0),
				Vector3(1.0, 1.0, 0.0),
				Vector3(0.0, 1.0, 1.0),
			]
			for v in vectors {
				let r1 = q1.rotate(vector: v)
				let r2 = q2.rotate(vector: v)
				#expect(r1[0].isApproximatelyEqual(to: r2[0]))
				#expect(r1[1].isApproximatelyEqual(to: r2[1]))
				#expect(r1[2].isApproximatelyEqual(to: r2[2]))
			}
		}

	/// Tests a round-trip via the identity quaternion (Branch 1: trace > 0).
	///
	/// The identity quaternion has trace = 3, so Branch 1 activates.
	///
		@Test("Branch 1 (trace > 0): identity round-trip")
		func branch1Identity() async throws {
			let q = Quaternion<Double>.identity
			let matrix = q.matrix
			let recovered = Quaternion<Double>(withMatrix: matrix)
			assertSameRotation(q, recovered)
		}

	/// Tests a round-trip via a general rotation with positive trace
	/// (Branch 1: trace > 0).
	///
	/// A small 30° rotation around Z keeps trace positive.
	///
		@Test("Branch 1 (trace > 0): 30° around Z round-trip")
		func branch1General() async throws {
			let q = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 6.0)
			)
			let matrix = q.matrix
			let recovered = Quaternion<Double>(withMatrix: matrix)
			assertSameRotation(q, recovered)
		}

	/// Tests a round-trip for a 90° rotation around X.
	///
	/// For 90° around X: matrix[0][0]=1, matrix[1][1]=0, matrix[2][2]=0.
	/// trace = 1 + 0 + 0 = 1 > 0, so this still hits Branch 1, but we
	/// verify correctness of the round-trip regardless.
	///
		@Test("Branch 2 (m[0][0] largest): 90° around X round-trip")
		func branch2() async throws {
			// For branch 2 we need matrix[0][0] to be the largest diagonal
			// element and trace ≤ 0. A 180° rotation around X achieves:
			// matrix[0][0]=1, matrix[1][1]=-1, matrix[2][2]=-1, trace=-1 ≤ 0.
			let q = Quaternion<Double>(
				withAxis: Vector3(1.0, 0.0, 0.0),
				angle: Angle(radians: Double.pi)
			)
			let matrix = q.matrix
			let recovered = Quaternion<Double>(withMatrix: matrix)
			assertSameRotation(q, recovered)
		}

	/// Tests a round-trip for a 180° rotation around Y (Branch 3).
	///
	/// For 180° around Y: matrix[0][0]=-1, matrix[1][1]=1, matrix[2][2]=-1,
	/// trace=-1 ≤ 0; matrix[1][1] > matrix[0][0], so Branch 3 activates.
	///
		@Test("Branch 3 (m[1][1] largest): 180° around Y round-trip")
		func branch3() async throws {
			let q = Quaternion<Double>(
				withAxis: Vector3(0.0, 1.0, 0.0),
				angle: Angle(radians: Double.pi)
			)
			let matrix = q.matrix
			let recovered = Quaternion<Double>(withMatrix: matrix)
			assertSameRotation(q, recovered)
		}

	/// Tests a round-trip for a 180° rotation around Z (Branch 4).
	///
	/// For 180° around Z: matrix[0][0]=-1, matrix[1][1]=-1, matrix[2][2]=1,
	/// trace=-1 ≤ 0; matrix[2][2] is largest, so Branch 4 activates.
	///
		@Test("Branch 4 (m[2][2] largest): 180° around Z round-trip")
		func branch4() async throws {
			let q = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi)
			)
			let matrix = q.matrix
			let recovered = Quaternion<Double>(withMatrix: matrix)
			assertSameRotation(q, recovered)
		}

	/// Tests that an arbitrary quaternion round-trips through matrix form.
	///
		@Test("Arbitrary quaternion round-trip")
		func arbitraryRoundTrip() async throws {
			let q = Quaternion<Double>(
				withAxis: Vector3(1.0, 2.0, 3.0),
				angle: Angle(radians: 1.2)
			)
			let matrix = q.matrix
			let recovered = Quaternion<Double>(withMatrix: matrix)
			assertSameRotation(q, recovered)
		}
	}
}

// MARK: - Axis / Angle

extension QuaternionTests {
	@Suite("Axis and Angle Accessors")
	struct AxisAndAngle {
	/// Tests that the axis accessor returns (0,0,1) for a 90° around Z
	/// quaternion.
	///
		@Test("axis of 90° around Z")
		func axisOf90DegZ() async throws {
			let q = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let axis = q.axis
			#expect(axis[0].isApproximatelyEqual(to: 0.0))
			#expect(axis[1].isApproximatelyEqual(to: 0.0))
			#expect(axis[2].isApproximatelyEqual(to: 1.0))
		}

	/// Tests that the angle accessor returns π/2 for a 90° around Z
	/// quaternion.
	///
		@Test("angle of 90° around Z")
		func angleOf90DegZ() async throws {
			let q = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			#expect(q.angle.radians.isApproximatelyEqual(to: Double.pi / 2.0))
		}

	/// Tests axis for 45° rotation around X.
	///
		@Test("axis of 45° around X")
		func axisOf45DegX() async throws {
			let q = Quaternion<Double>(
				withAxis: Vector3(1.0, 0.0, 0.0),
				angle: Angle(radians: Double.pi / 4.0)
			)
			let axis = q.axis
			#expect(axis[0].isApproximatelyEqual(to: 1.0))
			#expect(axis[1].isApproximatelyEqual(to: 0.0))
			#expect(axis[2].isApproximatelyEqual(to: 0.0))
		}

	/// Tests angle for 60° rotation around Y.
	///
		@Test("angle of 60° around Y")
		func angleOf60DegY() async throws {
			let q = Quaternion<Double>(
				withAxis: Vector3(0.0, 1.0, 0.0),
				angle: Angle(radians: Double.pi / 3.0)
			)
			#expect(q.angle.radians.isApproximatelyEqual(to: Double.pi / 3.0))
		}

	/// Tests the axis angle for the identity quaternion: angle should be 0,
	/// axis is undefined but should not crash.
	///
		@Test("identity quaternion angle")
		func identityQuaternionAngle() async throws {
			let id = Quaternion<Double>.identity
			#expect(id.angle.radians.isApproximatelyEqual(to: 0.0))
		}

	/// Tests that setting the axis updates the quaternion correctly.
	///
		@Test("axis setter")
		func axisSetter() async throws {
			var q = Quaternion<Double>(
				withAxis: Vector3(1.0, 0.0, 0.0),
				angle: Angle(radians: Double.pi / 4.0)
			)
			let originalAngle = q.angle

			q.axis = Vector3(0.0, 1.0, 0.0)
			// Angle should remain the same, axis should now be (0,1,0).
			#expect(q.angle.radians.isApproximatelyEqual(to: originalAngle.radians))
			#expect(q.axis[0].isApproximatelyEqual(to: 0.0))
			#expect(q.axis[1].isApproximatelyEqual(to: 1.0))
			#expect(q.axis[2].isApproximatelyEqual(to: 0.0))
		}

	/// Tests that setting the angle updates the quaternion correctly.
	///
		@Test("angle setter")
		func angleSetter() async throws {
			var q = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 4.0)
			)
			q.angle = Angle(radians: Double.pi / 2.0)
			#expect(q.angle.radians.isApproximatelyEqual(to: Double.pi / 2.0))
			// Axis should remain approximately (0,0,1).
			#expect(q.axis[0].isApproximatelyEqual(to: 0.0))
			#expect(q.axis[1].isApproximatelyEqual(to: 0.0))
			#expect(q.axis[2].isApproximatelyEqual(to: 1.0))
		}
	}
}

// MARK: - Lerp / Slerp

extension QuaternionTests {
	@Suite("Lerp and Slerp")
	struct LerpAndSlerp {
	/// Tests that lerp at t=0 returns q1.
	///
		@Test("lerp at t=0 gives q1")
		func lerpAtZero() async throws {
			let q1 = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: 0.0)
			)
			let q2 = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			// Note: lerp normalizes, so compare against normalized q1.
			let result = Quaternion<Double>.lerp(from: q1, to: q2, by: 0.0)
			let expected = q1.normalized
			#expect(result.imaginary[0].isApproximatelyEqual(to: expected.imaginary[0]))
			#expect(result.imaginary[1].isApproximatelyEqual(to: expected.imaginary[1]))
			#expect(result.imaginary[2].isApproximatelyEqual(to: expected.imaginary[2]))
			#expect(result.real.isApproximatelyEqual(to: expected.real))
		}

	/// Tests that lerp at t=1 returns q2.
	///
		@Test("lerp at t=1 gives q2")
		func lerpAtOne() async throws {
			let q1 = Quaternion<Double>.identity
			let q2 = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let result = Quaternion<Double>.lerp(from: q1, to: q2, by: 1.0)
			let expected = q2.normalized
			#expect(result.imaginary[0].isApproximatelyEqual(to: expected.imaginary[0]))
			#expect(result.imaginary[1].isApproximatelyEqual(to: expected.imaginary[1]))
			#expect(result.imaginary[2].isApproximatelyEqual(to: expected.imaginary[2]))
			#expect(result.real.isApproximatelyEqual(to: expected.real))
		}

	/// Tests that lerp result is a unit quaternion.
	///
		@Test("lerp result is unit quaternion")
		func lerpResultIsUnit() async throws {
			let q1 = Quaternion<Double>.identity
			let q2 = Quaternion<Double>(
				withAxis: Vector3(1.0, 0.0, 0.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let result = Quaternion<Double>.lerp(from: q1, to: q2, by: 0.5)
			let mag = Double.sqrt(
				result.imaginary[0] * result.imaginary[0] +
				result.imaginary[1] * result.imaginary[1] +
				result.imaginary[2] * result.imaginary[2] +
				result.real * result.real
			)
			#expect(mag.isApproximatelyEqual(to: 1.0))
		}

	/// Tests that slerp at t=0 returns q1.
	///
		@Test("slerp at t=0 gives q1")
		func slerpAtZero() async throws {
			let q1 = Quaternion<Double>.identity
			let q2 = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let result = Quaternion<Double>.slerp(from: q1, to: q2, by: 0.0)
			#expect(result.imaginary[0].isApproximatelyEqual(to: q1.imaginary[0]))
			#expect(result.imaginary[1].isApproximatelyEqual(to: q1.imaginary[1]))
			#expect(result.imaginary[2].isApproximatelyEqual(to: q1.imaginary[2]))
			#expect(result.real.isApproximatelyEqual(to: q1.real))
		}

	/// Tests that slerp at t=1 returns q2.
	///
		@Test("slerp at t=1 gives q2")
		func slerpAtOne() async throws {
			let q1 = Quaternion<Double>.identity
			let q2 = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let result = Quaternion<Double>.slerp(from: q1, to: q2, by: 1.0)
			#expect(result.imaginary[0].isApproximatelyEqual(to: q2.imaginary[0]))
			#expect(result.imaginary[1].isApproximatelyEqual(to: q2.imaginary[1]))
			#expect(result.imaginary[2].isApproximatelyEqual(to: q2.imaginary[2]))
			#expect(result.real.isApproximatelyEqual(to: q2.real))
		}

	/// Tests that slerp at t=0.5 between identity and 90° around Z produces
	/// a quaternion that is unit length and encodes a 45° rotation around Z.
	///
		@Test("slerp at t=0.5: identity → 90° around Z = 45° around Z")
		func slerpMidpoint() async throws {
			let q1 = Quaternion<Double>.identity
			let q2 = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let result = Quaternion<Double>.slerp(from: q1, to: q2, by: 0.5)

			// The midpoint should represent a 45° rotation around Z.
			let expected = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 4.0)
			)

			// It should be unit length.
			let mag = Double.sqrt(
				result.imaginary[0] * result.imaginary[0] +
				result.imaginary[1] * result.imaginary[1] +
				result.imaginary[2] * result.imaginary[2] +
				result.real * result.real
			)
			#expect(mag.isApproximatelyEqual(to: 1.0))

			// Check the angle by rotating a test vector.
			let v = Vector3<Double>(1.0, 0.0, 0.0)
			let rotated = result.rotate(vector: v)
			let expectedRotated = expected.rotate(vector: v)
			#expect(rotated[0].isApproximatelyEqual(to: expectedRotated[0]))
			#expect(rotated[1].isApproximatelyEqual(to: expectedRotated[1]))
			#expect(rotated[2].isApproximatelyEqual(to: expectedRotated[2]))
		}

	/// Tests the mutating slerp(to:by:) method.
	///
		@Test("mutating slerp(to:by:)")
		func mutatingSlerp() async throws {
			var q = Quaternion<Double>.identity
			let target = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let staticResult = Quaternion<Double>.slerp(from: q, to: target, by: 0.5)
			q.slerp(to: target, by: 0.5)
			#expect(q.imaginary[0].isApproximatelyEqual(to: staticResult.imaginary[0]))
			#expect(q.imaginary[1].isApproximatelyEqual(to: staticResult.imaginary[1]))
			#expect(q.imaginary[2].isApproximatelyEqual(to: staticResult.imaginary[2]))
			#expect(q.real.isApproximatelyEqual(to: staticResult.real))
		}

	/// Tests the mutating lerp(to:by:) method.
	///
		@Test("mutating lerp(to:by:)")
		func mutatingLerp() async throws {
			var q = Quaternion<Double>.identity
			let target = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let staticResult = Quaternion<Double>.lerp(from: q, to: target, by: 0.5)
			q.lerp(to: target, by: 0.5)
			#expect(q.imaginary[0].isApproximatelyEqual(to: staticResult.imaginary[0]))
			#expect(q.imaginary[1].isApproximatelyEqual(to: staticResult.imaginary[1]))
			#expect(q.imaginary[2].isApproximatelyEqual(to: staticResult.imaginary[2]))
			#expect(q.real.isApproximatelyEqual(to: staticResult.real))
		}
	}
}

// MARK: - Angle Between Quaternions

extension QuaternionTests {
	@Suite("Angle Between Quaternions")
	struct AngleBetweenQuaternions {
	/// Tests that the angle from a quaternion to itself is 0.
	///
		@Test("angle from q to q = 0")
		func angleToSelf() async throws {
			let q = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 4.0)
			)
			let angle = q.angle(to: q)
			#expect(angle.radians.isApproximatelyEqual(to: 0.0))
		}

	/// Tests the angle between identity and 90° around Z.
	///
	/// The angle between them should be 90°.
	///
		@Test("angle from identity to 90° around Z = 90°")
		func angleBetweenIdentityAnd90DegZ() async throws {
			let q1 = Quaternion<Double>.identity
			let q2 = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let angle = Quaternion<Double>.angle(from: q1, to: q2)
			#expect(angle.radians.isApproximatelyEqual(to: Double.pi / 2.0))
		}

	/// Tests that the angle is symmetric: angle(from: a, to: b) = angle(from: b, to: a).
	///
		@Test("angle is symmetric")
		func angleIsSymmetric() async throws {
			let q1 = Quaternion<Double>.identity
			let q2 = Quaternion<Double>(
				withAxis: Vector3(1.0, 0.0, 0.0),
				angle: Angle(radians: Double.pi / 3.0)
			)
			let forward = Quaternion<Double>.angle(from: q1, to: q2)
			let reverse = Quaternion<Double>.angle(from: q2, to: q1)
			#expect(forward.radians.isApproximatelyEqual(to: reverse.radians))
		}
	}
}

// MARK: - lookRotation

extension QuaternionTests {
	@Suite("lookRotation")
	struct LookRotation {
	/// Tests that lookRotation(forward:) pointing along -Z returns a rotation
	/// that maps the local +Z toward world -Z, which is equivalent to identity
	/// in a forward=-Z convention or a 180° flip around Y.
	///
	/// More directly: the rotation returned should be such that
	/// q.rotate(Vector3(0,0,1)) ≈ forward.
	///
		@Test("forward = (0, 0, -1)")
		func forwardNegativeZ() async throws {
			let forward = Vector3<Double>(0.0, 0.0, -1.0)
			let q = Quaternion<Double>.lookRotation(forward: forward)
			#expect(q != nil)
			// The quaternion rotates local +Z toward the target forward.
			let rotated = q!.rotate(vector: Vector3(0.0, 0.0, 1.0))
			#expect(rotated[0].isApproximatelyEqual(to: forward[0]))
			#expect(rotated[1].isApproximatelyEqual(to: forward[1]))
			#expect(rotated[2].isApproximatelyEqual(to: forward[2]))
		}

	/// Tests that lookRotation(forward:) pointing along +Z (forward) gives
	/// a rotation where local +Z aligns with world +Z.
	///
		@Test("forward = (0, 0, 1)")
		func forwardPositiveZ() async throws {
			let forward = Vector3<Double>(0.0, 0.0, 1.0)
			let q = Quaternion<Double>.lookRotation(forward: forward)
			#expect(q != nil)
			let rotated = q!.rotate(vector: Vector3(0.0, 0.0, 1.0))
			#expect(rotated[0].isApproximatelyEqual(to: 0.0))
			#expect(rotated[1].isApproximatelyEqual(to: 0.0))
			#expect(rotated[2].isApproximatelyEqual(to: 1.0))
		}

	/// Tests that lookRotation returns nil when forward is parallel to up.
	///
		@Test("parallel to up returns nil")
		func parallelToUpReturnsNil() async throws {
			// Default up is (0,1,0); forward parallel to up → nil.
			let forward = Vector3<Double>(0.0, 1.0, 0.0)
			let q = Quaternion<Double>.lookRotation(forward: forward)
			#expect(q == nil)
		}

	/// Tests that the result is a unit quaternion.
	///
		@Test("result is unit quaternion")
		func resultIsUnit() async throws {
			let forward = Vector3<Double>(1.0, 0.0, -1.0)
			let q = Quaternion<Double>.lookRotation(forward: forward)
			#expect(q != nil)
			let mag = Double.sqrt(
				q!.imaginary[0] * q!.imaginary[0] +
				q!.imaginary[1] * q!.imaginary[1] +
				q!.imaginary[2] * q!.imaginary[2] +
				q!.real * q!.real
			)
			#expect(mag.isApproximatelyEqual(to: 1.0))
		}
	}
}

// MARK: - fromToRotation

extension QuaternionTests {
	@Suite("fromToRotation")
	struct FromToRotation {
	/// Tests that fromToRotation(from: (1,0,0), to: (0,1,0)) rotates (1,0,0)
	/// to approximately (0,1,0).
	///
		@Test("(1,0,0) → (0,1,0)")
		func xAxisToYAxis() async throws {
			let from = Vector3<Double>(1.0, 0.0, 0.0)
			let to = Vector3<Double>(0.0, 1.0, 0.0)
			let q = Quaternion<Double>.fromToRotation(from: from, to: to)
			let rotated = q.rotate(vector: from)
			#expect(rotated[0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(rotated[1].isApproximatelyEqual(to: 1.0))
			#expect(rotated[2].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
		}

	/// Tests that fromToRotation(from: (0,0,1), to: (1,0,0)) rotates (0,0,1)
	/// to approximately (1,0,0).
	///
		@Test("(0,0,1) → (1,0,0)")
		func zAxisToXAxis() async throws {
			let from = Vector3<Double>(0.0, 0.0, 1.0)
			let to = Vector3<Double>(1.0, 0.0, 0.0)
			let q = Quaternion<Double>.fromToRotation(from: from, to: to)
			let rotated = q.rotate(vector: from)
			#expect(rotated[0].isApproximatelyEqual(to: 1.0))
			#expect(rotated[1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(rotated[2].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
		}

	/// Tests that fromToRotation of identical vectors returns identity.
	///
		@Test("identical vectors → identity")
		func identicalVectorsGiveIdentity() async throws {
			let v = Vector3<Double>(1.0, 0.0, 0.0)
			let q = Quaternion<Double>.fromToRotation(from: v, to: v)
			#expect(q.isIdentity)
		}

	/// Tests that fromToRotation produces a unit quaternion.
	///
		@Test("result is unit quaternion")
		func resultIsUnit() async throws {
			let from = Vector3<Double>(1.0, 0.0, 0.0)
			let to = Vector3<Double>(0.0, 1.0, 1.0)
			let q = Quaternion<Double>.fromToRotation(from: from, to: to)
			let mag = Double.sqrt(
				q.imaginary[0] * q.imaginary[0] +
				q.imaginary[1] * q.imaginary[1] +
				q.imaginary[2] * q.imaginary[2] +
				q.real * q.real
			)
			#expect(mag.isApproximatelyEqual(to: 1.0))
		}

	/// Tests fromToRotation with antiparallel vectors (180° rotation).
	///
		@Test("antiparallel vectors → 180° rotation")
		func antiparallelVectors() async throws {
			let from = Vector3<Double>(1.0, 0.0, 0.0)
			let to = Vector3<Double>(-1.0, 0.0, 0.0)
			let q = Quaternion<Double>.fromToRotation(from: from, to: to)
			let rotated = q.rotate(vector: from)
			// The rotated vector should be antiparallel to the original.
			#expect(rotated[0].isApproximatelyEqual(to: -1.0))
			#expect(rotated[1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(rotated[2].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
		}
	}
}

// MARK: - Euler Rotation Round-Trip

extension QuaternionTests {
	@Suite("Euler Rotation Round-Trip")
	struct EulerRotationRoundTrip {
	/// Tests that a quaternion built from Euler angles converts back to the
	/// same angles (within numerical precision) using XYZ order.
	///
		@Test("XYZ round-trip")
		func xyzRoundTrip() async throws {
			let rotation: Units.Rotation<SIMD3<Double>> = [
				.degrees(30.0),
				.degrees(45.0),
				.degrees(-60.0)
			]
			let q = Quaternion<Double>(withRotation: rotation, order: .XYZ)
			let recovered = q.toRotation(order: .XYZ)
			#expect(recovered[0].degrees.isApproximatelyEqual(to: rotation[0].degrees))
			#expect(recovered[1].degrees.isApproximatelyEqual(to: rotation[1].degrees))
			#expect(recovered[2].degrees.isApproximatelyEqual(to: rotation[2].degrees))
		}

	/// Tests round-trip for ZYX order.
	///
		@Test("ZYX round-trip")
		func zyxRoundTrip() async throws {
			let rotation: Units.Rotation<SIMD3<Double>> = [
				.degrees(20.0),
				.degrees(-35.0),
				.degrees(50.0)
			]
			let q = Quaternion<Double>(withRotation: rotation, order: .ZYX)
			let recovered = q.toRotation(order: .ZYX)
			#expect(recovered[0].degrees.isApproximatelyEqual(to: rotation[0].degrees))
			#expect(recovered[1].degrees.isApproximatelyEqual(to: rotation[1].degrees))
			#expect(recovered[2].degrees.isApproximatelyEqual(to: rotation[2].degrees))
		}

	/// Tests round-trip for YXZ order.
	///
		@Test("YXZ round-trip")
		func yxzRoundTrip() async throws {
			let rotation: Units.Rotation<SIMD3<Double>> = [
				.degrees(15.0),
				.degrees(25.0),
				.degrees(-10.0)
			]
			let q = Quaternion<Double>(withRotation: rotation, order: .YXZ)
			let recovered = q.toRotation(order: .YXZ)
			#expect(recovered[0].degrees.isApproximatelyEqual(to: rotation[0].degrees))
			#expect(recovered[1].degrees.isApproximatelyEqual(to: rotation[1].degrees))
			#expect(recovered[2].degrees.isApproximatelyEqual(to: rotation[2].degrees))
		}

	/// Tests round-trip for ZXY order.
	///
		@Test("ZXY round-trip")
		func zxyRoundTrip() async throws {
			let rotation: Units.Rotation<SIMD3<Double>> = [
				.degrees(-45.0),
				.degrees(60.0),
				.degrees(30.0)
			]
			let q = Quaternion<Double>(withRotation: rotation, order: .ZXY)
			let recovered = q.toRotation(order: .ZXY)
			#expect(recovered[0].degrees.isApproximatelyEqual(to: rotation[0].degrees))
			#expect(recovered[1].degrees.isApproximatelyEqual(to: rotation[1].degrees))
			#expect(recovered[2].degrees.isApproximatelyEqual(to: rotation[2].degrees))
		}

	/// Tests round-trip for XZY order.
	///
		@Test("XZY round-trip")
		func xzyRoundTrip() async throws {
			let rotation: Units.Rotation<SIMD3<Double>> = [
				.degrees(10.0),
				.degrees(-20.0),
				.degrees(35.0)
			]
			let q = Quaternion<Double>(withRotation: rotation, order: .XZY)
			let recovered = q.toRotation(order: .XZY)
			#expect(recovered[0].degrees.isApproximatelyEqual(to: rotation[0].degrees))
			#expect(recovered[1].degrees.isApproximatelyEqual(to: rotation[1].degrees))
			#expect(recovered[2].degrees.isApproximatelyEqual(to: rotation[2].degrees))
		}

	/// Tests round-trip for YZX order.
	///
		@Test("YZX round-trip")
		func yzxRoundTrip() async throws {
			let rotation: Units.Rotation<SIMD3<Double>> = [
				.degrees(40.0),
				.degrees(-15.0),
				.degrees(55.0)
			]
			let q = Quaternion<Double>(withRotation: rotation, order: .YZX)
			let recovered = q.toRotation(order: .YZX)
			#expect(recovered[0].degrees.isApproximatelyEqual(to: rotation[0].degrees))
			#expect(recovered[1].degrees.isApproximatelyEqual(to: rotation[1].degrees))
			#expect(recovered[2].degrees.isApproximatelyEqual(to: rotation[2].degrees))
		}

	/// Tests that the Euler quaternion is normalized.
	///
		@Test("Euler quaternion is unit")
		func eulerQuaternionIsUnit() async throws {
			let rotation: Units.Rotation<SIMD3<Double>> = [
				.degrees(192.0),
				.degrees(27.0),
				.degrees(-60.0)
			]
			let q = Quaternion<Double>(withRotation: rotation, order: .ZXY)
			let mag = Double.sqrt(
				q.imaginary[0] * q.imaginary[0] +
				q.imaginary[1] * q.imaginary[1] +
				q.imaginary[2] * q.imaginary[2] +
				q.real * q.real
			)
			#expect(mag.isApproximatelyEqual(to: 1.0))
		}
	}
}

// MARK: - Blendable

extension QuaternionTests {
	@Suite("Blendable")
	struct BlendableTests {
	/// Tests that blend(from:to:by:) at t=0.5 matches slerp at t=0.5 — blend
	/// is defined as lerp on the Quaternion type.
	///
		@Test("blend(from:to:by:) matches lerp")
		func blendMatchesLerp() async throws {
			let q1 = Quaternion<Double>.identity
			let q2 = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let blended = Quaternion<Double>.blend(from: q1, to: q2, by: 0.5)
			let lerped = Quaternion<Double>.lerp(from: q1, to: q2, by: 0.5)
			#expect(blended.imaginary[0].isApproximatelyEqual(to: lerped.imaginary[0]))
			#expect(blended.imaginary[1].isApproximatelyEqual(to: lerped.imaginary[1]))
			#expect(blended.imaginary[2].isApproximatelyEqual(to: lerped.imaginary[2]))
			#expect(blended.real.isApproximatelyEqual(to: lerped.real))
		}

	/// Tests the mutating blend(to:by:) method.
	///
		@Test("mutating blend(to:by:)")
		func mutatingBlend() async throws {
			let q1 = Quaternion<Double>.identity
			let q2 = Quaternion<Double>(
				withAxis: Vector3(1.0, 0.0, 0.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			var mutable = q1
			mutable.blend(to: q2, by: 0.5)
			let staticResult = Quaternion<Double>.blend(from: q1, to: q2, by: 0.5)
			#expect(mutable.imaginary[0].isApproximatelyEqual(to: staticResult.imaginary[0]))
			#expect(mutable.imaginary[1].isApproximatelyEqual(to: staticResult.imaginary[1]))
			#expect(mutable.imaginary[2].isApproximatelyEqual(to: staticResult.imaginary[2]))
			#expect(mutable.real.isApproximatelyEqual(to: staticResult.real))
		}
	}
}
