//
//  Matrix.swift
//  Cartesian
//
//  Created by Matt Cox on 30/06/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import Foundation
import Testing

@testable import Cartesian
import Units

// The generic `Matrix` type is backed by `InlineArray` and is only available on
// the newest platforms. The Swift Testing macros cannot be combined with an
// `@available` attribute, so each test narrows availability at runtime with a
// `guard #available` instead.
//
@Suite("Matrix (generic)")
struct MatrixGenericTests {
/// Tests the default initializer, which is expected to create a zero matrix.
///
	@Test("Default Initializer")
	func defaultInitializer() async throws {
		guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
		let m = Matrix<2, 2, Double>()
		#expect(m[0, 0] == 0.0)
		#expect(m[0, 1] == 0.0)
		#expect(m[1, 0] == 0.0)
		#expect(m[1, 1] == 0.0)
		#expect(Matrix<2, 2, Double>.columns == 2)
		#expect(Matrix<2, 2, Double>.rows == 2)
	}

/// Tests the column subscript and the (column, row) subscript.
///
	@Test("Subscripts")
	func subscripts() async throws {
		guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
		var m = Matrix<2, 2, Double>()
		m[0, 0] = 1.0
		m[1, 1] = 4.0
		#expect(m[0][0] == 1.0)
		#expect(m[1][1] == 4.0)

		m[0] = [5.0, 6.0]
		#expect(m[0, 0] == 5.0)
		#expect(m[0, 1] == 6.0)
	}

/// Tests the array literal initializer, which accepts rows and transposes
/// them into column-major storage.
///
	@Test("Array literal initializer")
	func arrayLiteral() async throws {
		guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
		// Visually:
		//   | 1  2 |
		//   | 3  4 |
		let m: Matrix<2, 2, Double> = [
			[1.0, 2.0],
			[3.0, 4.0]
		]
		#expect(m[0, 0] == 1.0)
		#expect(m[1, 0] == 2.0)
		#expect(m[0, 1] == 3.0)
		#expect(m[1, 1] == 4.0)
	}

/// Tests Equatable conformance.
///
	@Test("Equatable")
	func equatable() async throws {
		guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
		let a: Matrix<2, 2, Double> = [[1.0, 2.0], [3.0, 4.0]]
		let b: Matrix<2, 2, Double> = [[1.0, 2.0], [3.0, 4.0]]
		let c: Matrix<2, 2, Double> = [[1.0, 2.0], [3.0, 5.0]]
		#expect(a == b)
		#expect(a != c)
	}

/// Tests JSON encode/decode round-trip.
///
	@Test("Serialization")
	func serialization() async throws {
		guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
		let m: Matrix<3, 3, Double> = [
			[1.0, 2.0, 3.0],
			[4.0, 5.0, 6.0],
			[7.0, 8.0, 9.0]
		]
		let encoded = try JSONEncoder().encode(m)
		let decoded = try JSONDecoder().decode(Matrix<3, 3, Double>.self, from: encoded)
		#expect(decoded == m)
	}
}

// MARK: - Identity

extension MatrixGenericTests {
	@Suite("Identity")
	struct Identity {
	/// Tests that the identity matrix has ones on the diagonal.
	///
		@Test("identity")
		func identity() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let m = Matrix<3, 3, Double>.identity
			for c in 0..<3 {
				for r in 0..<3 {
					#expect(m[c, r] == (c == r ? 1.0 : 0.0))
				}
			}
		}

	/// Tests isIdentity for identity and non-identity matrices.
	///
		@Test("isIdentity")
		func isIdentity() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			#expect(Matrix<3, 3, Double>.identity.isIdentity)
			#expect(Matrix<3, 3, Double>().isIdentity == false)
		}

	/// Tests that toIdentity() resets the matrix.
	///
		@Test("toIdentity")
		func toIdentity() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			var m: Matrix<2, 2, Double> = [[9.0, 8.0], [7.0, 6.0]]
			m.toIdentity()
			#expect(m.isIdentity)
		}
	}
}

// MARK: - Arithmetic

extension MatrixGenericTests {
	@Suite("Arithmetic")
	struct Arithmetic {
	/// Tests matrix addition and subtraction.
	///
		@Test("addition and subtraction")
		func addSubtract() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let a: Matrix<2, 2, Double> = [[1.0, 2.0], [3.0, 4.0]]
			let b: Matrix<2, 2, Double> = [[5.0, 6.0], [7.0, 8.0]]
			let sum: Matrix<2, 2, Double> = [[6.0, 8.0], [10.0, 12.0]]
			let difference: Matrix<2, 2, Double> = [[4.0, 4.0], [4.0, 4.0]]
			#expect(a + b == sum)
			#expect(b - a == difference)
		}

	/// Tests scalar multiplication (both operand orders) and negation.
	///
		@Test("scalar multiplication and negation")
		func scalarMultiplyNegate() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let a: Matrix<2, 2, Double> = [[1.0, 2.0], [3.0, 4.0]]
			let doubled: Matrix<2, 2, Double> = [[2.0, 4.0], [6.0, 8.0]]
			let negated: Matrix<2, 2, Double> = [[-1.0, -2.0], [-3.0, -4.0]]
			#expect(a * 2.0 == doubled)
			#expect(2.0 * a == doubled)
			#expect(-a == negated)
		}

	/// Tests the compound assignment operators.
	///
		@Test("compound assignment")
		func compoundAssignment() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			var m: Matrix<2, 2, Double> = [[1.0, 2.0], [3.0, 4.0]]
			m += [[1.0, 1.0], [1.0, 1.0]]
			#expect(m == [[2.0, 3.0], [4.0, 5.0]] as Matrix<2, 2, Double>)
			m -= [[1.0, 1.0], [1.0, 1.0]]
			#expect(m == [[1.0, 2.0], [3.0, 4.0]] as Matrix<2, 2, Double>)
			m *= 3.0
			#expect(m == [[3.0, 6.0], [9.0, 12.0]] as Matrix<2, 2, Double>)
		}

	/// Tests square matrix multiplication, including the identity property.
	///
		@Test("matrix multiplication")
		func matrixMultiplication() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let a: Matrix<2, 2, Double> = [[1.0, 2.0], [3.0, 4.0]]
			let b: Matrix<2, 2, Double> = [[5.0, 6.0], [7.0, 8.0]]

			// Multiplying by the identity leaves the matrix unchanged.
			#expect(a * Matrix<2, 2, Double>.identity == a)
			#expect(Matrix<2, 2, Double>.identity * a == a)

			// | 1 2 | * | 5 6 | = | 19 22 |
			// | 3 4 |   | 7 8 |   | 43 50 |
			let product = a * b
			#expect(product[0, 0].isApproximatelyEqual(to: 19.0))
			#expect(product[1, 0].isApproximatelyEqual(to: 22.0))
			#expect(product[0, 1].isApproximatelyEqual(to: 43.0))
			#expect(product[1, 1].isApproximatelyEqual(to: 50.0))
		}

	/// Tests matrix-vector multiplication against a diagonal scale matrix.
	///
		@Test("matrix-vector multiplication")
		func matrixVectorMultiplication() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let scale: Matrix<3, 3, Double> = [
				[2.0, 0.0, 0.0],
				[0.0, 3.0, 0.0],
				[0.0, 0.0, 4.0]
			]
			let v = Vector<3, Double>(1.0, 1.0, 1.0)
			let result = scale * v
			#expect(result[0].isApproximatelyEqual(to: 2.0))
			#expect(result[1].isApproximatelyEqual(to: 3.0))
			#expect(result[2].isApproximatelyEqual(to: 4.0))

			// The identity matrix leaves the vector unchanged.
			#expect(Matrix<3, 3, Double>.identity * v == v)
		}
	}
}

// MARK: - Square Matrix Operations

extension MatrixGenericTests {
	@Suite("Square Matrix")
	struct Square {
	/// Tests the transpose, both the computed property and mutating form.
	///
		@Test("transpose")
		func transpose() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let m: Matrix<2, 2, Double> = [[1.0, 2.0], [3.0, 4.0]]
			let t = m.transposed
			#expect(t[0, 0] == 1.0)
			#expect(t[0, 1] == 2.0)
			#expect(t[1, 0] == 3.0)
			#expect(t[1, 1] == 4.0)

			var mutable = m
			mutable.transpose()
			#expect(mutable == t)

			// Transposing twice returns the original.
			#expect(m.transposed.transposed == m)
		}

	/// Tests the trace (sum of the diagonal).
	///
		@Test("trace")
		func trace() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let m: Matrix<3, 3, Double> = [
				[1.0, 2.0, 3.0],
				[4.0, 5.0, 6.0],
				[7.0, 8.0, 9.0]
			]
			#expect(m.trace.isApproximatelyEqual(to: 15.0))
		}

	/// Tests the determinant for 2×2 and 3×3 matrices.
	///
		@Test("determinant")
		func determinant() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let two: Matrix<2, 2, Double> = [[1.0, 2.0], [3.0, 4.0]]
			#expect(two.determinant.isApproximatelyEqual(to: -2.0))

			let three: Matrix<3, 3, Double> = [
				[1.0, 2.0, 3.0],
				[4.0, 5.0, 6.0],
				[7.0, 8.0, 10.0]
			]
			#expect(three.determinant.isApproximatelyEqual(to: -3.0))

			#expect(Matrix<4, 4, Double>.identity.determinant.isApproximatelyEqual(to: 1.0))
		}

	/// Tests that the inverse multiplied by the original yields the identity.
	///
		@Test("inverse")
		func inverse() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let m: Matrix<3, 3, Double> = [
				[1.0, 2.0, 3.0],
				[0.0, 1.0, 4.0],
				[5.0, 6.0, 0.0]
			]
			let inverse = try #require(m.inverse)
			let product = m * inverse
			for c in 0..<3 {
				for r in 0..<3 {
					#expect(product[c, r].isApproximatelyEqual(to: c == r ? 1.0 : 0.0, absoluteTolerance: 1e-12))
				}
			}
		}

	/// Tests that a singular matrix has no inverse.
	///
		@Test("singular matrix has no inverse")
		func singularHasNoInverse() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			// The second column is twice the first, so the matrix is singular.
			let m: Matrix<2, 2, Double> = [[1.0, 2.0], [2.0, 4.0]]
			#expect(m.inverse == nil)
		}

	/// Tests the mutating invert() for invertible and singular matrices.
	///
		@Test("invert() mutating")
		func invertMutating() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			var invertible: Matrix<2, 2, Double> = [[2.0, 0.0], [0.0, 4.0]]
			#expect(invertible.invert() == true)
			#expect(invertible[0, 0].isApproximatelyEqual(to: 0.5))
			#expect(invertible[1, 1].isApproximatelyEqual(to: 0.25))

			var singular: Matrix<2, 2, Double> = [[1.0, 2.0], [2.0, 4.0]]
			let original = singular
			#expect(singular.invert() == false)
			#expect(singular == original)
		}
	}
}

// MARK: - Quaternion Conversion

extension MatrixGenericTests {
	@Suite("Quaternion Conversion")
	struct QuaternionConversion {
	/// Tests that a 3×3 matrix built from a quaternion matches the
	/// quaternion's own rotation matrix.
	///
		@Test("init(withQuaternion:) matches quaternion.matrix")
		func initWithQuaternion() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let q = Quaternion<Double>(
				withAxis: Vector3(1.0, 1.0, 1.0),
				angle: Angle(radians: Double.pi / 4.0)
			)
			let m = Matrix<3, 3, Double>(withQuaternion: q)
			let reference = q.matrix
			for c in 0..<3 {
				for r in 0..<3 {
					#expect(m[c, r].isApproximatelyEqual(to: reference[c][r]))
				}
			}
		}

	/// Tests that converting a matrix back to a quaternion recovers the same
	/// rotation.
	///
		@Test("quaternion round-trip")
		func quaternionRoundTrip() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let q = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: Angle(radians: Double.pi / 2.0)
			)
			let m = Matrix<3, 3, Double>(withQuaternion: q)
			let recovered = m.quaternion

			let v = Vector3<Double>(1.0, 0.0, 0.0)
			let expected = q.rotate(vector: v)
			let actual = recovered.rotate(vector: v)
			#expect(actual[0].isApproximatelyEqual(to: expected[0], absoluteTolerance: 1e-12))
			#expect(actual[1].isApproximatelyEqual(to: expected[1]))
			#expect(actual[2].isApproximatelyEqual(to: expected[2], absoluteTolerance: 1e-12))
		}
	}
}

// MARK: - Affine Transform (4×4)

extension MatrixGenericTests {
	@Suite("Affine Transform")
	struct AffineTransform {
	/// Tests the translation accessor and the withTranslation initializer.
	///
		@Test("translation")
		func translation() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			var m = Matrix<4, 4, Double>(withTranslation: Vector3(1.0, 2.0, 3.0))
			#expect(m.translation == Vector3(1.0, 2.0, 3.0))
			#expect(m.isAffine)

			m.translation = Vector3(4.0, 5.0, 6.0)
			#expect(m.translation == Vector3(4.0, 5.0, 6.0))
		}

	/// Tests the scale accessor for both the scalar and vector initializers.
	///
		@Test("scale")
		func scale() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let uniform = Matrix<4, 4, Double>(withScale: 5.0)
			#expect(uniform.scale[0].isApproximatelyEqual(to: 5.0))
			#expect(uniform.scale[1].isApproximatelyEqual(to: 5.0))
			#expect(uniform.scale[2].isApproximatelyEqual(to: 5.0))

			let nonUniform = Matrix<4, 4, Double>(withScale: Vector3(2.0, 3.0, 4.0))
			#expect(nonUniform.scale[0].isApproximatelyEqual(to: 2.0))
			#expect(nonUniform.scale[1].isApproximatelyEqual(to: 3.0))
			#expect(nonUniform.scale[2].isApproximatelyEqual(to: 4.0))
		}

	/// Tests that the generic matrix built from a rotation matches the
	/// fixed-size Matrix4x4, which is the well-tested reference implementation.
	///
		@Test("withRotation matches Matrix4x4")
		func withRotationMatchesFixed() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let rotation = Vector3<Double>(0.3, -0.4, 0.5)
			for order in [RotationOrder.XYZ, .ZYX, .YXZ] {
				let generic = Matrix<4, 4, Double>(withRotation: rotation, order: order)
				let fixed = Matrix4x4<Double>(withRotation: rotation, order: order)
				for c in 0..<4 {
					for r in 0..<4 {
						#expect(generic[c, r].isApproximatelyEqual(to: fixed[c, r], absoluteTolerance: 1e-12))
					}
				}
			}
		}

	/// Tests that decomposing a rotation matrix back to Euler angles matches
	/// the fixed-size Matrix4x4 reference. This guards against the sign-flip
	/// regression that was fixed in Matrix4x4.toRotation.
	///
		@Test("toRotation matches Matrix4x4")
		func toRotationMatchesFixed() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let rotation = Vector3<Double>(0.3, -0.4, 0.5)
			for order in [RotationOrder.XYZ, .ZYX, .YXZ, .XZY, .YZX, .ZXY] {
				let generic = Matrix<4, 4, Double>(withRotation: rotation, order: order)
				let fixed = Matrix4x4<Double>(withRotation: rotation, order: order)
				let genericAngles = generic.toRotation(order: order)
				let fixedAngles = fixed.toRotation(order: order)
				#expect(genericAngles[0].isApproximatelyEqual(to: fixedAngles[0], absoluteTolerance: 1e-9))
				#expect(genericAngles[1].isApproximatelyEqual(to: fixedAngles[1], absoluteTolerance: 1e-9))
				#expect(genericAngles[2].isApproximatelyEqual(to: fixedAngles[2], absoluteTolerance: 1e-9))
			}
		}

	/// Tests that a rotation matrix round-trips through Euler decomposition
	/// back to the original angles.
	///
		@Test("rotation round-trip")
		func rotationRoundTrip() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			let rotation = Vector3<Double>(0.3, -0.4, 0.5)
			let m = Matrix<4, 4, Double>(withRotation: rotation, order: .XYZ)
			let recovered = m.toRotation(order: .XYZ)
			#expect(recovered[0].isApproximatelyEqual(to: rotation[0], absoluteTolerance: 1e-9))
			#expect(recovered[1].isApproximatelyEqual(to: rotation[1], absoluteTolerance: 1e-9))
			#expect(recovered[2].isApproximatelyEqual(to: rotation[2], absoluteTolerance: 1e-9))
		}
	}
}

// MARK: - Non-Square Matrices

extension MatrixGenericTests {
	@Suite("Non-Square")
	struct NonSquare {
	/// Tests dimensions and element access for a non-square matrix.
	///
		@Test("dimensions and elements")
		func dimensionsAndElements() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			// A matrix with 2 columns and 3 rows.
			var m = Matrix<2, 3, Double>()
			#expect(Matrix<2, 3, Double>.columns == 2)
			#expect(Matrix<2, 3, Double>.rows == 3)

			m[0, 0] = 1.0
			m[1, 2] = 6.0
			#expect(m[0, 0] == 1.0)
			#expect(m[1, 2] == 6.0)
		}

	/// Tests element-wise arithmetic on non-square matrices.
	///
		@Test("element-wise arithmetic")
		func elementWiseArithmetic() async throws {
			guard #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) else { return }
			var a = Matrix<2, 3, Double>()
			var b = Matrix<2, 3, Double>()
			for c in 0..<2 {
				for r in 0..<3 {
					a[c, r] = Double(c * 3 + r)
					b[c, r] = 1.0
				}
			}
			let sum = a + b
			let scaled = a * 2.0
			for c in 0..<2 {
				for r in 0..<3 {
					#expect(sum[c, r].isApproximatelyEqual(to: a[c, r] + 1.0))
					#expect(scaled[c, r].isApproximatelyEqual(to: a[c, r] * 2.0))
				}
			}
		}
	}
}
