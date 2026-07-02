//
//  Matrix4x4.swift
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

@Suite("Matrix4x4")
struct Matrix4x4Tests {
/// Tests the default initializer, which is expected to create an empty
/// matrix with zeros everywhere.
///
/// Output:
/// ```swift
/// | 0  0  0  0 |
/// | 0  0  0  0 |
/// | 0  0  0  0 |
/// | 0  0  0  0 |
/// ```
///
	@Test("Initializer")
	func initializer() async throws {
		let matrix: Matrix4x4<Double> = Matrix4x4()
		for x in 0..<4 {
			for y in 0..<4 {
				#expect(matrix[x][y] == .zero)
			}
		}
	}

/// Tests the column initializer, which is expected to insert the values
/// provided into the columns.
///
/// Input:
/// ```swift
/// col0=[1,2,3,4], col1=[5,6,7,8], col2=[9,10,11,12], col3=[13,14,15,16]
/// ```
///
/// Output:
/// ```swift
/// |  1   5   9  13 |
/// |  2   6  10  14 |
/// |  3   7  11  15 |
/// |  4   8  12  16 |
/// ```
///
	@Test("Column Initializer")
	func columnInitializer() async throws {
		let matrix = Matrix4x4(columns:
			Vector4(1.0, 2.0, 3.0, 4.0),
			Vector4(5.0, 6.0, 7.0, 8.0),
			Vector4(9.0, 10.0, 11.0, 12.0),
			Vector4(13.0, 14.0, 15.0, 16.0)
		)

		#expect(matrix[0][0] == 1.0)
		#expect(matrix[0][1] == 2.0)
		#expect(matrix[0][2] == 3.0)
		#expect(matrix[0][3] == 4.0)
		#expect(matrix[1][0] == 5.0)
		#expect(matrix[1][1] == 6.0)
		#expect(matrix[1][2] == 7.0)
		#expect(matrix[1][3] == 8.0)
		#expect(matrix[2][0] == 9.0)
		#expect(matrix[2][1] == 10.0)
		#expect(matrix[2][2] == 11.0)
		#expect(matrix[2][3] == 12.0)
		#expect(matrix[3][0] == 13.0)
		#expect(matrix[3][1] == 14.0)
		#expect(matrix[3][2] == 15.0)
		#expect(matrix[3][3] == 16.0)
	}

/// Tests the row initializer, which is expected to treat the provided
/// vectors as rows and transpose into column-major storage.
///
/// Input:
/// ```swift
/// row0=[1,2,3,4], row1=[5,6,7,8], row2=[9,10,11,12], row3=[13,14,15,16]
/// ```
///
/// Output (column-major storage):
/// ```swift
/// col0=[1,5,9,13], col1=[2,6,10,14], col2=[3,7,11,15], col3=[4,8,12,16]
/// ```
///
	@Test("Row Initializer")
	func rowInitializer() async throws {
		let matrix = Matrix4x4(rows:
			Vector4(1.0, 2.0, 3.0, 4.0),
			Vector4(5.0, 6.0, 7.0, 8.0),
			Vector4(9.0, 10.0, 11.0, 12.0),
			Vector4(13.0, 14.0, 15.0, 16.0)
		)

		// Column 0 contains the first element of each row.
		#expect(matrix[0][0] == 1.0)
		#expect(matrix[0][1] == 5.0)
		#expect(matrix[0][2] == 9.0)
		#expect(matrix[0][3] == 13.0)
		// Column 1 contains the second element of each row.
		#expect(matrix[1][0] == 2.0)
		#expect(matrix[1][1] == 6.0)
		#expect(matrix[1][2] == 10.0)
		#expect(matrix[1][3] == 14.0)
		// Column 2 contains the third element of each row.
		#expect(matrix[2][0] == 3.0)
		#expect(matrix[2][1] == 7.0)
		#expect(matrix[2][2] == 11.0)
		#expect(matrix[2][3] == 15.0)
		// Column 3 contains the fourth element of each row.
		#expect(matrix[3][0] == 4.0)
		#expect(matrix[3][1] == 8.0)
		#expect(matrix[3][2] == 12.0)
		#expect(matrix[3][3] == 16.0)
	}

/// Tests the array literal initializer, which is expected to create the
/// matrix as it appears visually (rows), stored in column-major order.
///
/// Input:
/// ```swift
/// [[ 1,  2,  3,  4],
///  [ 5,  6,  7,  8],
///  [ 9, 10, 11, 12],
///  [13, 14, 15, 16]]
/// ```
///
/// Output (column-major storage):
/// ```swift
/// col0=[1,5,9,13], col1=[2,6,10,14], col2=[3,7,11,15], col3=[4,8,12,16]
/// ```
///
	@Test("Array Literal Initializer")
	func arrayLiteralInitializer() async throws {
		let matrix: Matrix4x4 = [
			[1.0,  2.0,  3.0,  4.0],
			[5.0,  6.0,  7.0,  8.0],
			[9.0,  10.0, 11.0, 12.0],
			[13.0, 14.0, 15.0, 16.0],
		]

		#expect(matrix[0][0] == 1.0)
		#expect(matrix[0][1] == 5.0)
		#expect(matrix[0][2] == 9.0)
		#expect(matrix[0][3] == 13.0)
		#expect(matrix[1][0] == 2.0)
		#expect(matrix[1][1] == 6.0)
		#expect(matrix[1][2] == 10.0)
		#expect(matrix[1][3] == 14.0)
		#expect(matrix[2][0] == 3.0)
		#expect(matrix[2][1] == 7.0)
		#expect(matrix[2][2] == 11.0)
		#expect(matrix[2][3] == 15.0)
		#expect(matrix[3][0] == 4.0)
		#expect(matrix[3][1] == 8.0)
		#expect(matrix[3][2] == 12.0)
		#expect(matrix[3][3] == 16.0)
	}

/// Attempt to encode and decode the matrix as JSON.
///
/// All sixteen values in the matrix should be encoded and decoded correctly.
///
	@Test("Serialization")
	func serialization() async throws {
		let matrix = Matrix4x4(rows:
			Vector4(1.0, 2.0, 3.0, 4.0),
			Vector4(5.0, 6.0, 7.0, 8.0),
			Vector4(9.0, 10.0, 11.0, 12.0),
			Vector4(13.0, 14.0, 15.0, 16.0)
		)

		let encoded = try JSONEncoder().encode(matrix)
		let decoded = try JSONDecoder().decode(Matrix4x4<Double>.self, from: encoded)

		for x in 0..<4 {
			for y in 0..<4 {
				#expect(matrix[x][y] == decoded[x][y])
			}
		}
	}

/// Test if two matrices are equatable.
///
	@Test("Equatable")
	func equatable() async throws {
		let one = Matrix4x4(rows:
			Vector4(1.0, 2.0, 3.0, 4.0),
			Vector4(5.0, 6.0, 7.0, 8.0),
			Vector4(9.0, 10.0, 11.0, 12.0),
			Vector4(13.0, 14.0, 15.0, 16.0)
		)

		let two = Matrix4x4(rows:
			Vector4(1.0 + .ulpOfOne, 2.0 - .ulpOfOne, 3.0 + .ulpOfOne, 4.0 - .ulpOfOne),
			Vector4(5.0 + .ulpOfOne, 6.0 - .ulpOfOne, 7.0 + .ulpOfOne, 8.0 - .ulpOfOne),
			Vector4(9.0 + .ulpOfOne, 10.0 - .ulpOfOne, 11.0 + .ulpOfOne, 12.0 - .ulpOfOne),
			Vector4(13.0 + .ulpOfOne, 14.0 - .ulpOfOne, 15.0 + .ulpOfOne, 16.0 - .ulpOfOne)
		)

		#expect(one == one)
		#expect(one != two)
	}
}

extension Matrix4x4Tests {
	@Suite("Identity")
	struct Identity {
	/// Test the `identity` static property to make sure it returns a correct
	/// 4×4 identity matrix.
	///
	/// Output:
	/// ```swift
	/// | 1  0  0  0 |
	/// | 0  1  0  0 |
	/// | 0  0  1  0 |
	/// | 0  0  0  1 |
	/// ```
	///
		@Test("identity")
		func identity() async throws {
			let identity = Matrix4x4<Double>.identity
			for column in 0..<4 {
				for row in 0..<4 {
					#expect(identity[column, row] == (column == row ? 1 : 0))
				}
			}
		}

	/// Test the `isIdentity` function on a zero matrix (not identity).
	///
	/// Input:
	/// ```swift
	/// | 0  0  0  0 |
	/// | 0  0  0  0 |
	/// | 0  0  0  0 |
	/// | 0  0  0  0 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// false
	/// ```
	///
		@Test("isIdentity #1")
		func isIdentity_1() async throws {
			// The default initializer should create an empty matrix, so this is
			// expected to not be identity.
			//
			#expect(Matrix4x4<Double>().isIdentity == false)
		}

	/// Test the `isIdentity` function on a manually-constructed identity matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  0  0  0 |
	/// | 0  1  0  0 |
	/// | 0  0  1  0 |
	/// | 0  0  0  1 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// true
	/// ```
	///
		@Test("isIdentity #2")
		func isIdentity_2() async throws {
			// Manually create what we think of as an identity matrix.
			//
			var matrix = Matrix4x4<Double>()
			for column in 0..<4 {
				for row in 0..<4 {
					matrix[column, row] = column == row ? 1 : 0
				}
			}
			#expect(matrix.isIdentity == true)
		}

	/// Test the `isIdentity` function on a perturbed identity matrix.
	///
	/// Input:
	/// ```swift
	/// | 1+ε   0    0    0  |
	/// |  0   1-ε   0    0  |
	/// |  0    0   1+ε   0  |
	/// |  0    0    0   1-ε |
	/// ```
	///
	/// Output:
	/// ```swift
	/// false
	/// ```
	///
		@Test("isIdentity #3")
		func isIdentity_3() async throws {
			// Make a minor change to the values in the main diagonal of an
			// identity matrix. It should no longer be identity.
			//
			var matrix = Matrix4x4<Double>.identity
			for index in 0..<4 {
				matrix[index, index] += ((index % 2) == 0) ? Double.ulpOfOne : -Double.ulpOfOne
			}
			#expect(matrix.isIdentity == false)
		}

	/// Test the `toIdentity` function to see if it correctly sets the
	/// matrix to identity.
	///
	/// Input:
	/// ```swift
	/// |  1   2   3   4 |
	/// |  5   6   7   8 |
	/// |  9  10  11  12 |
	/// | 13  14  15  16 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// | 1  0  0  0 |
	/// | 0  1  0  0 |
	/// | 0  0  1  0 |
	/// | 0  0  0  1 |
	/// ```
	///
		@Test("toIdentity")
		func toIdentity() async throws {
			var matrix = Matrix4x4(rows:
				Vector4(2.0, 3.0, 4.0, 5.0),
				Vector4(6.0, 7.0, 8.0, 9.0),
				Vector4(10.0, 11.0, 12.0, 13.0),
				Vector4(14.0, 15.0, 16.0, 17.0)
			)

			for column in 0..<4 {
				for row in 0..<4 {
					#expect(matrix[column, row] != (column == row ? 1 : 0))
				}
			}

			matrix.toIdentity()

			for column in 0..<4 {
				for row in 0..<4 {
					#expect(matrix[column, row] == (column == row ? 1 : 0))
				}
			}
		}
	}
}

extension Matrix4x4Tests {
	@Suite("Invertible")
	struct Invertible {
	/// Attempt to invert a known invertible 4×4 matrix.
	///
	/// Input:
	/// ```swift
	/// |  3  -3   4   0 |
	/// |  2   1  -1   0 |
	/// |  0   1   3   0 |
	/// |  0   0   0   1 |
	/// ```
	///
	/// The result is verified by checking that (inverse × original) ≈ identity.
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double4x4` type.
	///
		@Test("inverse #1")
		func inverse_1() async throws {
			let matrix = Matrix4x4(rows:
				Vector4( 3.0, -3.0,  4.0, 0.0),
				Vector4( 2.0,  1.0, -1.0, 0.0),
				Vector4( 0.0,  1.0,  3.0, 0.0),
				Vector4( 0.0,  0.0,  0.0, 1.0)
			)

			let matrixInverse = matrix.inverse

			#expect(matrixInverse != nil)

			// Verify inverse × original ≈ identity
			if let inv = matrixInverse {
				let product = inv * matrix
				for column in 0..<4 {
					for row in 0..<4 {
						let expected: Double = column == row ? 1.0 : 0.0
						#expect(product[column, row].isApproximatelyEqual(to: expected, absoluteTolerance: 1e-12))
					}
				}
			}

		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let matrixSIMD = simd_double4x4(rows: [
				SIMD4<Double>( 3.0, -3.0,  4.0, 0.0),
				SIMD4<Double>( 2.0,  1.0, -1.0, 0.0),
				SIMD4<Double>( 0.0,  1.0,  3.0, 0.0),
				SIMD4<Double>( 0.0,  0.0,  0.0, 1.0)
			])
			let matrixSIMDInverse = matrixSIMD.inverse

			for x in 0..<4 {
				for y in 0..<4 {
					#expect(matrixSIMDInverse[x, y] == matrixInverse?[x, y])
				}
			}
		#endif
		}

	/// Attempt to invert a singular (non-invertible) 4×4 matrix.
	///
	/// Input:
	/// ```swift
	/// |  1   2   3   4 |
	/// |  2   4   6   8 |
	/// |  3   6   9  12 |
	/// |  4   8  12  16 |
	/// ```
	///
	/// All rows are multiples of [1, 2, 3, 4] so the determinant is zero.
	///
	/// Output:
	/// ```swift
	/// nil  // This matrix cannot be inverted
	/// ```
	///
		@Test("inverse #2")
		func inverse_2() async throws {
			let matrix = Matrix4x4(rows:
				Vector4(1.0,  2.0,  3.0,  4.0),
				Vector4(2.0,  4.0,  6.0,  8.0),
				Vector4(3.0,  6.0,  9.0, 12.0),
				Vector4(4.0,  8.0, 12.0, 16.0)
			)

			#expect(matrix.inverse == nil)
		}

	/// Attempt to invert a matrix using the mutating `invert()` method.
	///
	/// On success the matrix is updated in place and `true` is returned.
	/// The result is verified against simd where available.
	///
		@Test("invert #1")
		func invert_1() async throws {
			var matrix = Matrix4x4(rows:
				Vector4( 3.0, -3.0,  4.0, 0.0),
				Vector4( 2.0,  1.0, -1.0, 0.0),
				Vector4( 0.0,  1.0,  3.0, 0.0),
				Vector4( 0.0,  0.0,  0.0, 1.0)
			)

			let original = matrix
			#expect(matrix.invert() == true)

			// Verify result × original ≈ identity
			let product = matrix * original
			for column in 0..<4 {
				for row in 0..<4 {
					let expected: Double = column == row ? 1.0 : 0.0
					#expect(product[column, row].isApproximatelyEqual(to: expected, absoluteTolerance: 1e-12))
				}
			}

		#if canImport(simd)
			var matrixSIMD = simd_double4x4(rows: [
				SIMD4<Double>( 3.0, -3.0,  4.0, 0.0),
				SIMD4<Double>( 2.0,  1.0, -1.0, 0.0),
				SIMD4<Double>( 0.0,  1.0,  3.0, 0.0),
				SIMD4<Double>( 0.0,  0.0,  0.0, 1.0)
			])
			matrixSIMD = matrixSIMD.inverse

			for x in 0..<4 {
				for y in 0..<4 {
					#expect(matrixSIMD[x, y].isApproximatelyEqual(to: matrix[x, y]))
				}
			}
		#endif
		}

	/// Attempt to invert a singular matrix using the mutating `invert()` method.
	///
	/// On failure the matrix should be unchanged and `false` is returned.
	///
		@Test("invert #2")
		func invert_2() async throws {
			var matrix = Matrix4x4(rows:
				Vector4(1.0,  2.0,  3.0,  4.0),
				Vector4(2.0,  4.0,  6.0,  8.0),
				Vector4(3.0,  6.0,  9.0, 12.0),
				Vector4(4.0,  8.0, 12.0, 16.0)
			)

			#expect(matrix.invert() == false)

			// Matrix should be unchanged.
			#expect(matrix[0, 0].isApproximatelyEqual(to: 1.0))
			#expect(matrix[0, 1].isApproximatelyEqual(to: 2.0))
			#expect(matrix[1, 0].isApproximatelyEqual(to: 2.0))
			#expect(matrix[1, 1].isApproximatelyEqual(to: 4.0))
		}

	/// Verify the affine fast-path: an affine matrix (bottom row = [0,0,0,1])
	/// is detected by `isAffine` and inverted via the 3×3 sub-matrix path.
	/// The product of the inverse and original should be ≈ identity.
	///
		@Test("inverse affine fast-path")
		func inverseAffineFastPath() async throws {
			// Scale(2,3,4) + Translation(5,6,7) — affine, bottom row [0,0,0,1].
			let matrix = Matrix4x4(rows:
				Vector4(2.0, 0.0, 0.0, 5.0),
				Vector4(0.0, 3.0, 0.0, 6.0),
				Vector4(0.0, 0.0, 4.0, 7.0),
				Vector4(0.0, 0.0, 0.0, 1.0)
			)

			#expect(matrix.isAffine == true)

			let matrixInverse = matrix.inverse

			#expect(matrixInverse != nil)

			if let inv = matrixInverse {
				let product = inv * matrix
				for column in 0..<4 {
					for row in 0..<4 {
						let expected: Double = column == row ? 1.0 : 0.0
						#expect(product[column, row].isApproximatelyEqual(to: expected))
					}
				}
			}
		}
	}
}

extension Matrix4x4Tests {
	@Suite("MatrixMath")
	struct MatrixMath {
	/// Tests adding two matrices together.
	///
	/// Input:
	/// ```swift
	/// | 1   2   3   4 | + | 17  18  19  20 |
	/// | 5   6   7   8 |   | 21  22  23  24 |
	/// | 9  10  11  12 |   | 25  26  27  28 |
	/// |13  14  15  16 |   | 29  30  31  32 |
	/// ```
	///
	/// Output: component-wise sum.
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double4x4` type.
	///
		@Test("Addition")
		func addition() async throws {
			let lhs = Matrix4x4(columns:
				Vector4( 1.0,  5.0,  9.0, 13.0),
				Vector4( 2.0,  6.0, 10.0, 14.0),
				Vector4( 3.0,  7.0, 11.0, 15.0),
				Vector4( 4.0,  8.0, 12.0, 16.0)
			)

			let rhs = Matrix4x4(columns:
				Vector4(17.0, 21.0, 25.0, 29.0),
				Vector4(18.0, 22.0, 26.0, 30.0),
				Vector4(19.0, 23.0, 27.0, 31.0),
				Vector4(20.0, 24.0, 28.0, 32.0)
			)

			let result = lhs + rhs

			// Spot-check a selection of entries.
			#expect(result[0, 0] == 18.0)
			#expect(result[0, 1] == 26.0)
			#expect(result[0, 2] == 34.0)
			#expect(result[0, 3] == 42.0)
			#expect(result[3, 0] == 24.0)
			#expect(result[3, 3] == 48.0)

		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let lhsSIMD = simd_double4x4(
				SIMD4<Double>( 1.0,  5.0,  9.0, 13.0),
				SIMD4<Double>( 2.0,  6.0, 10.0, 14.0),
				SIMD4<Double>( 3.0,  7.0, 11.0, 15.0),
				SIMD4<Double>( 4.0,  8.0, 12.0, 16.0)
			)

			let rhsSIMD = simd_double4x4(
				SIMD4<Double>(17.0, 21.0, 25.0, 29.0),
				SIMD4<Double>(18.0, 22.0, 26.0, 30.0),
				SIMD4<Double>(19.0, 23.0, 27.0, 31.0),
				SIMD4<Double>(20.0, 24.0, 28.0, 32.0)
			)

			let resultSIMD = lhsSIMD + rhsSIMD

			for x in 0..<4 {
				for y in 0..<4 {
					#expect(result[x, y] == resultSIMD[x, y])
				}
			}
		#endif
		}

	/// Tests adding two matrices together, mutating the first matrix.
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double4x4` type.
	///
		@Test("Addition Assignment")
		func additionAssignment() async throws {
			var lhs = Matrix4x4(columns:
				Vector4( 1.0,  5.0,  9.0, 13.0),
				Vector4( 2.0,  6.0, 10.0, 14.0),
				Vector4( 3.0,  7.0, 11.0, 15.0),
				Vector4( 4.0,  8.0, 12.0, 16.0)
			)

			let rhs = Matrix4x4(columns:
				Vector4(17.0, 21.0, 25.0, 29.0),
				Vector4(18.0, 22.0, 26.0, 30.0),
				Vector4(19.0, 23.0, 27.0, 31.0),
				Vector4(20.0, 24.0, 28.0, 32.0)
			)

			lhs += rhs

			#expect(lhs[0, 0] == 18.0)
			#expect(lhs[0, 1] == 26.0)
			#expect(lhs[0, 2] == 34.0)
			#expect(lhs[0, 3] == 42.0)
			#expect(lhs[3, 0] == 24.0)
			#expect(lhs[3, 3] == 48.0)

		#if canImport(simd)
			var lhsSIMD = simd_double4x4(
				SIMD4<Double>( 1.0,  5.0,  9.0, 13.0),
				SIMD4<Double>( 2.0,  6.0, 10.0, 14.0),
				SIMD4<Double>( 3.0,  7.0, 11.0, 15.0),
				SIMD4<Double>( 4.0,  8.0, 12.0, 16.0)
			)

			let rhsSIMD = simd_double4x4(
				SIMD4<Double>(17.0, 21.0, 25.0, 29.0),
				SIMD4<Double>(18.0, 22.0, 26.0, 30.0),
				SIMD4<Double>(19.0, 23.0, 27.0, 31.0),
				SIMD4<Double>(20.0, 24.0, 28.0, 32.0)
			)

			lhsSIMD += rhsSIMD

			for x in 0..<4 {
				for y in 0..<4 {
					#expect(lhs[x, y] == lhsSIMD[x, y])
				}
			}
		#endif
		}

	/// Tests negating a matrix.
	///
	/// Every component of the result should equal the negation of the
	/// corresponding component in the input.
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double4x4` type.
	///
		@Test("Negation")
		func negation() async throws {
			let rhs = Matrix4x4(columns:
				Vector4( 1.0,  5.0,  9.0, 13.0),
				Vector4( 2.0,  6.0, 10.0, 14.0),
				Vector4( 3.0,  7.0, 11.0, 15.0),
				Vector4( 4.0,  8.0, 12.0, 16.0)
			)

			let result = -rhs

			for x in 0..<4 {
				for y in 0..<4 {
					#expect(result[x, y] == -rhs[x, y])
				}
			}

		#if canImport(simd)
			let rhsSIMD = simd_double4x4(
				SIMD4<Double>( 1.0,  5.0,  9.0, 13.0),
				SIMD4<Double>( 2.0,  6.0, 10.0, 14.0),
				SIMD4<Double>( 3.0,  7.0, 11.0, 15.0),
				SIMD4<Double>( 4.0,  8.0, 12.0, 16.0)
			)

			let resultSIMD = -rhsSIMD

			for x in 0..<4 {
				for y in 0..<4 {
					#expect(result[x, y] == resultSIMD[x, y])
				}
			}
		#endif
		}

	/// Tests subtracting one matrix from another.
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double4x4` type.
	///
		@Test("Subtraction")
		func subtraction() async throws {
			let lhs = Matrix4x4(columns:
				Vector4(17.0, 21.0, 25.0, 29.0),
				Vector4(18.0, 22.0, 26.0, 30.0),
				Vector4(19.0, 23.0, 27.0, 31.0),
				Vector4(20.0, 24.0, 28.0, 32.0)
			)

			let rhs = Matrix4x4(columns:
				Vector4( 1.0,  5.0,  9.0, 13.0),
				Vector4( 2.0,  6.0, 10.0, 14.0),
				Vector4( 3.0,  7.0, 11.0, 15.0),
				Vector4( 4.0,  8.0, 12.0, 16.0)
			)

			let result = lhs - rhs

			for x in 0..<4 {
				for y in 0..<4 {
					#expect(result[x, y] == lhs[x, y] - rhs[x, y])
				}
			}

		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let lhsSIMD = simd_double4x4(
				SIMD4<Double>(17.0, 21.0, 25.0, 29.0),
				SIMD4<Double>(18.0, 22.0, 26.0, 30.0),
				SIMD4<Double>(19.0, 23.0, 27.0, 31.0),
				SIMD4<Double>(20.0, 24.0, 28.0, 32.0)
			)

			let rhsSIMD = simd_double4x4(
				SIMD4<Double>( 1.0,  5.0,  9.0, 13.0),
				SIMD4<Double>( 2.0,  6.0, 10.0, 14.0),
				SIMD4<Double>( 3.0,  7.0, 11.0, 15.0),
				SIMD4<Double>( 4.0,  8.0, 12.0, 16.0)
			)

			let resultSIMD = lhsSIMD - rhsSIMD

			for x in 0..<4 {
				for y in 0..<4 {
					#expect(result[x, y] == resultSIMD[x, y])
				}
			}
		#endif
		}

	/// Tests subtracting one matrix from another, mutating the first matrix.
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double4x4` type.
	///
		@Test("Subtraction Assignment")
		func subtractionAssignment() async throws {
			var lhs = Matrix4x4(columns:
				Vector4(17.0, 21.0, 25.0, 29.0),
				Vector4(18.0, 22.0, 26.0, 30.0),
				Vector4(19.0, 23.0, 27.0, 31.0),
				Vector4(20.0, 24.0, 28.0, 32.0)
			)

			let rhs = Matrix4x4(columns:
				Vector4( 1.0,  5.0,  9.0, 13.0),
				Vector4( 2.0,  6.0, 10.0, 14.0),
				Vector4( 3.0,  7.0, 11.0, 15.0),
				Vector4( 4.0,  8.0, 12.0, 16.0)
			)

			let expected = lhs - rhs
			lhs -= rhs

			for x in 0..<4 {
				for y in 0..<4 {
					#expect(lhs[x, y] == expected[x, y])
				}
			}

		#if canImport(simd)
			var lhsSIMD = simd_double4x4(
				SIMD4<Double>(17.0, 21.0, 25.0, 29.0),
				SIMD4<Double>(18.0, 22.0, 26.0, 30.0),
				SIMD4<Double>(19.0, 23.0, 27.0, 31.0),
				SIMD4<Double>(20.0, 24.0, 28.0, 32.0)
			)

			let rhsSIMD = simd_double4x4(
				SIMD4<Double>( 1.0,  5.0,  9.0, 13.0),
				SIMD4<Double>( 2.0,  6.0, 10.0, 14.0),
				SIMD4<Double>( 3.0,  7.0, 11.0, 15.0),
				SIMD4<Double>( 4.0,  8.0, 12.0, 16.0)
			)

			lhsSIMD -= rhsSIMD

			for x in 0..<4 {
				for y in 0..<4 {
					#expect(lhs[x, y] == lhsSIMD[x, y])
				}
			}
		#endif
		}

	/// Tests multiplying two matrices together.
	///
	/// Uses the property that M * I = M to verify correctness, and compares
	/// against simd for general multiplication where available.
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double4x4` type.
	///
		@Test("Multiplication")
		func multiplication() async throws {
			let lhs = Matrix4x4(columns:
				Vector4( 1.0,  5.0,  9.0, 13.0),
				Vector4( 2.0,  6.0, 10.0, 14.0),
				Vector4( 3.0,  7.0, 11.0, 15.0),
				Vector4( 4.0,  8.0, 12.0, 16.0)
			)

			let rhs = Matrix4x4(columns:
				Vector4(17.0, 21.0, 25.0, 29.0),
				Vector4(18.0, 22.0, 26.0, 30.0),
				Vector4(19.0, 23.0, 27.0, 31.0),
				Vector4(20.0, 24.0, 28.0, 32.0)
			)

			let result = lhs * rhs

		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let lhsSIMD = simd_double4x4(
				SIMD4<Double>( 1.0,  5.0,  9.0, 13.0),
				SIMD4<Double>( 2.0,  6.0, 10.0, 14.0),
				SIMD4<Double>( 3.0,  7.0, 11.0, 15.0),
				SIMD4<Double>( 4.0,  8.0, 12.0, 16.0)
			)

			let rhsSIMD = simd_double4x4(
				SIMD4<Double>(17.0, 21.0, 25.0, 29.0),
				SIMD4<Double>(18.0, 22.0, 26.0, 30.0),
				SIMD4<Double>(19.0, 23.0, 27.0, 31.0),
				SIMD4<Double>(20.0, 24.0, 28.0, 32.0)
			)

			let resultSIMD = lhsSIMD * rhsSIMD

			for x in 0..<4 {
				for y in 0..<4 {
					#expect(result[x, y].isApproximatelyEqual(to: resultSIMD[x, y]))
				}
			}
		#else
			// Verify M * I = M
			let identityProduct = lhs * Matrix4x4<Double>.identity
			for x in 0..<4 {
				for y in 0..<4 {
					#expect(identityProduct[x, y] == lhs[x, y])
				}
			}
			let _ = result
		#endif
		}

	/// Tests multiplying two matrices together, mutating the first matrix.
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double4x4` type.
	///
		@Test("Multiplication Assignment")
		func multiplicationAssignment() async throws {
			var lhs = Matrix4x4(columns:
				Vector4( 1.0,  5.0,  9.0, 13.0),
				Vector4( 2.0,  6.0, 10.0, 14.0),
				Vector4( 3.0,  7.0, 11.0, 15.0),
				Vector4( 4.0,  8.0, 12.0, 16.0)
			)

			let rhs = Matrix4x4(columns:
				Vector4(17.0, 21.0, 25.0, 29.0),
				Vector4(18.0, 22.0, 26.0, 30.0),
				Vector4(19.0, 23.0, 27.0, 31.0),
				Vector4(20.0, 24.0, 28.0, 32.0)
			)

			let expected = lhs * rhs
			lhs *= rhs

			for x in 0..<4 {
				for y in 0..<4 {
					#expect(lhs[x, y] == expected[x, y])
				}
			}

		#if canImport(simd)
			var lhsSIMD = simd_double4x4(
				SIMD4<Double>( 1.0,  5.0,  9.0, 13.0),
				SIMD4<Double>( 2.0,  6.0, 10.0, 14.0),
				SIMD4<Double>( 3.0,  7.0, 11.0, 15.0),
				SIMD4<Double>( 4.0,  8.0, 12.0, 16.0)
			)

			let rhsSIMD = simd_double4x4(
				SIMD4<Double>(17.0, 21.0, 25.0, 29.0),
				SIMD4<Double>(18.0, 22.0, 26.0, 30.0),
				SIMD4<Double>(19.0, 23.0, 27.0, 31.0),
				SIMD4<Double>(20.0, 24.0, 28.0, 32.0)
			)

			lhsSIMD *= rhsSIMD

			for x in 0..<4 {
				for y in 0..<4 {
					#expect(lhs[x, y].isApproximatelyEqual(to: lhsSIMD[x, y]))
				}
			}
		#endif
		}

	/// Tests multiplying a matrix by a scalar (both orderings).
	///
	/// `matrix * scalar` and `scalar * matrix` should give the same result,
	/// and each component should be the original component multiplied by the
	/// scalar.
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double4x4` type.
	///
		@Test("Scalar Multiplication")
		func scalarMultiplication() async throws {
			let matrix = Matrix4x4(columns:
				Vector4( 1.0,  5.0,  9.0, 13.0),
				Vector4( 2.0,  6.0, 10.0, 14.0),
				Vector4( 3.0,  7.0, 11.0, 15.0),
				Vector4( 4.0,  8.0, 12.0, 16.0)
			)

			let scalar = 2.0

			let result1 = matrix * scalar
			let result2 = scalar * matrix

			for x in 0..<4 {
				for y in 0..<4 {
					#expect(result1[x, y] == result2[x, y])
					#expect(result1[x, y] == matrix[x, y] * scalar)
				}
			}

		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let matrixSIMD = simd_double4x4(
				SIMD4<Double>( 1.0,  5.0,  9.0, 13.0),
				SIMD4<Double>( 2.0,  6.0, 10.0, 14.0),
				SIMD4<Double>( 3.0,  7.0, 11.0, 15.0),
				SIMD4<Double>( 4.0,  8.0, 12.0, 16.0)
			)

			let resultSIMD1 = matrixSIMD * scalar
			let resultSIMD2 = scalar * matrixSIMD

			for x in 0..<4 {
				for y in 0..<4 {
					#expect(resultSIMD1[x, y] == resultSIMD2[x, y])
					#expect(result1[x, y] == resultSIMD1[x, y])
				}
			}
		#endif
		}

	/// Tests multiplying a matrix by a scalar, mutating the matrix.
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double4x4` type.
	///
		@Test("Scalar Multiplication Assignment")
		func scalarMultiplicationAssignment() async throws {
			var lhs = Matrix4x4(columns:
				Vector4( 1.0,  5.0,  9.0, 13.0),
				Vector4( 2.0,  6.0, 10.0, 14.0),
				Vector4( 3.0,  7.0, 11.0, 15.0),
				Vector4( 4.0,  8.0, 12.0, 16.0)
			)

			let rhs = 2.0
			let expected = lhs * rhs
			lhs *= rhs

			for x in 0..<4 {
				for y in 0..<4 {
					#expect(lhs[x, y] == expected[x, y])
				}
			}

		#if canImport(simd)
			var lhsSIMD = simd_double4x4(
				SIMD4<Double>( 1.0,  5.0,  9.0, 13.0),
				SIMD4<Double>( 2.0,  6.0, 10.0, 14.0),
				SIMD4<Double>( 3.0,  7.0, 11.0, 15.0),
				SIMD4<Double>( 4.0,  8.0, 12.0, 16.0)
			)

			lhsSIMD *= rhs

			for x in 0..<4 {
				for y in 0..<4 {
					#expect(lhs[x, y] == lhsSIMD[x, y])
				}
			}
		#endif
		}
	}
}

extension Matrix4x4Tests {
	@Suite("MatrixVectorMath")
	struct MatrixVectorMath {
	/// Tests multiplying a diagonal 4×4 scale matrix by a Vector4.
	///
	/// Input:
	/// ```swift
	/// | 1  0  0  0 |   | 10 |   | 10  |
	/// | 0  2  0  0 | × | 20 | = | 40  |
	/// | 0  0  3  0 |   | 30 |   | 90  |
	/// | 0  0  0  4 |   | 40 |   | 160 |
	/// ```
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double4x4` type.
	///
		@Test("Vector Multiplication")
		func multiplication() async throws {
			// Diagonal scale matrix: each component is multiplied by 1, 2, 3, 4.
			let matrix = Matrix4x4(columns:
				Vector4(1.0, 0.0, 0.0, 0.0),
				Vector4(0.0, 2.0, 0.0, 0.0),
				Vector4(0.0, 0.0, 3.0, 0.0),
				Vector4(0.0, 0.0, 0.0, 4.0)
			)

			let vector = Vector4(10.0, 20.0, 30.0, 40.0)

			let result = matrix * vector

			#expect(result[0].isApproximatelyEqual(to: 10.0))
			#expect(result[1].isApproximatelyEqual(to: 40.0))
			#expect(result[2].isApproximatelyEqual(to: 90.0))
			#expect(result[3].isApproximatelyEqual(to: 160.0))

		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let matrixSIMD = simd_double4x4(
				SIMD4<Double>(1.0, 0.0, 0.0, 0.0),
				SIMD4<Double>(0.0, 2.0, 0.0, 0.0),
				SIMD4<Double>(0.0, 0.0, 3.0, 0.0),
				SIMD4<Double>(0.0, 0.0, 0.0, 4.0)
			)

			let vectorSIMD = SIMD4<Double>(10.0, 20.0, 30.0, 40.0)
			let resultSIMD = matrixSIMD * vectorSIMD

			#expect(result[0] == resultSIMD[0])
			#expect(result[1] == resultSIMD[1])
			#expect(result[2] == resultSIMD[2])
			#expect(result[3] == resultSIMD[3])
		#endif
		}

	/// Tests multiplying a general 4×4 matrix by a Vector4.
	///
	/// Multiplying by the unit vector [1,0,0,0] selects column 0 of the matrix.
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double4x4` type.
	///
		@Test("Vector Multiplication #2")
		func multiplication2() async throws {
			let matrix = Matrix4x4(columns:
				Vector4(1.0, 2.0, 3.0, 4.0),
				Vector4(5.0, 6.0, 7.0, 8.0),
				Vector4(9.0, 10.0, 11.0, 12.0),
				Vector4(13.0, 14.0, 15.0, 16.0)
			)

			// M * e0 selects column 0.
			let vector = Vector4(1.0, 0.0, 0.0, 0.0)
			let result = matrix * vector

			#expect(result[0].isApproximatelyEqual(to: 1.0))
			#expect(result[1].isApproximatelyEqual(to: 2.0))
			#expect(result[2].isApproximatelyEqual(to: 3.0))
			#expect(result[3].isApproximatelyEqual(to: 4.0))

		#if canImport(simd)
			let matrixSIMD = simd_double4x4(
				SIMD4<Double>(1.0, 2.0, 3.0, 4.0),
				SIMD4<Double>(5.0, 6.0, 7.0, 8.0),
				SIMD4<Double>(9.0, 10.0, 11.0, 12.0),
				SIMD4<Double>(13.0, 14.0, 15.0, 16.0)
			)

			let vectorSIMD = SIMD4<Double>(1.0, 0.0, 0.0, 0.0)
			let resultSIMD = matrixSIMD * vectorSIMD

			for i in 0..<4 {
				#expect(result[i] == resultSIMD[i])
			}
		#endif
		}
	}
}

extension Matrix4x4Tests {
	@Suite("SquareMatrix")
	struct SquareMatrix {
	/// Tests getting the determinant of a diagonal 4×4 matrix.
	///
	/// Input: diagonal matrix with entries [2, 3, 5, 7].
	/// Output: 2 × 3 × 5 × 7 = 210.
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double4x4` type.
	///
		@Test("determinant #1")
		func determinant_1() async throws {
			// Diagonal matrix: det = product of diagonal entries = 2*3*5*7 = 210.
			let matrix = Matrix4x4(columns:
				Vector4(2.0, 0.0, 0.0, 0.0),
				Vector4(0.0, 3.0, 0.0, 0.0),
				Vector4(0.0, 0.0, 5.0, 0.0),
				Vector4(0.0, 0.0, 0.0, 7.0)
			)

			#expect(matrix.determinant.isApproximatelyEqual(to: 210.0))

		#if canImport(simd)
			let matrixSIMD = simd_double4x4(
				SIMD4<Double>(2.0, 0.0, 0.0, 0.0),
				SIMD4<Double>(0.0, 3.0, 0.0, 0.0),
				SIMD4<Double>(0.0, 0.0, 5.0, 0.0),
				SIMD4<Double>(0.0, 0.0, 0.0, 7.0)
			)

			#expect(matrix.determinant.isApproximatelyEqual(to: matrixSIMD.determinant))
		#endif
		}

	/// Tests that the determinant of the identity matrix is 1.
	///
		@Test("determinant #2")
		func determinant_2() async throws {
			#expect(Matrix4x4<Double>.identity.determinant.isApproximatelyEqual(to: 1.0))
		}

	/// Tests calculating the trace of the matrix.
	///
	/// Input: diagonal matrix with entries [1, 2, 3, 4].
	/// Output: 1 + 2 + 3 + 4 = 10.
	///
		@Test("trace")
		func trace() async throws {
			let matrix = Matrix4x4(columns:
				Vector4(1.0, 0.0, 0.0, 0.0),
				Vector4(0.0, 2.0, 0.0, 0.0),
				Vector4(0.0, 0.0, 3.0, 0.0),
				Vector4(0.0, 0.0, 0.0, 4.0)
			)

			#expect(matrix.trace.isApproximatelyEqual(to: 10.0))
		}

	/// Tests transposing the matrix (non-mutating).
	///
	/// Transposing swaps rows and columns: result[column, row] = original[row, column].
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double4x4` type.
	///
		@Test("transposed")
		func transposed() async throws {
			// Initialize via rows so the visual layout matches what we assert.
			let matrix = Matrix4x4(rows:
				Vector4( 1.0,  2.0,  3.0,  4.0),
				Vector4( 5.0,  6.0,  7.0,  8.0),
				Vector4( 9.0, 10.0, 11.0, 12.0),
				Vector4(13.0, 14.0, 15.0, 16.0)
			)

			let result = matrix.transposed

			for column in 0..<4 {
				for row in 0..<4 {
					#expect(result[column, row] == matrix[row, column])
				}
			}

		#if canImport(simd)
			let matrixSIMD = simd_double4x4(rows: [
				SIMD4<Double>( 1.0,  2.0,  3.0,  4.0),
				SIMD4<Double>( 5.0,  6.0,  7.0,  8.0),
				SIMD4<Double>( 9.0, 10.0, 11.0, 12.0),
				SIMD4<Double>(13.0, 14.0, 15.0, 16.0)
			])

			let resultSIMD = matrixSIMD.transpose

			for x in 0..<4 {
				for y in 0..<4 {
					#expect(result[x, y] == resultSIMD[x, y])
				}
			}
		#endif
		}

	/// Tests transposing the matrix in place (mutating).
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double4x4` type.
	///
		@Test("transpose")
		func transpose() async throws {
			var matrix = Matrix4x4(rows:
				Vector4( 1.0,  2.0,  3.0,  4.0),
				Vector4( 5.0,  6.0,  7.0,  8.0),
				Vector4( 9.0, 10.0, 11.0, 12.0),
				Vector4(13.0, 14.0, 15.0, 16.0)
			)

			let original = matrix
			matrix.transpose()

			for column in 0..<4 {
				for row in 0..<4 {
					#expect(matrix[column, row] == original[row, column])
				}
			}

		#if canImport(simd)
			var matrixSIMD = simd_double4x4(rows: [
				SIMD4<Double>( 1.0,  2.0,  3.0,  4.0),
				SIMD4<Double>( 5.0,  6.0,  7.0,  8.0),
				SIMD4<Double>( 9.0, 10.0, 11.0, 12.0),
				SIMD4<Double>(13.0, 14.0, 15.0, 16.0)
			])

			matrixSIMD = matrixSIMD.transpose

			for x in 0..<4 {
				for y in 0..<4 {
					#expect(matrix[x, y] == matrixSIMD[x, y])
				}
			}
		#endif
		}
	}
}

extension Matrix4x4Tests {
	@Suite("MatrixAffineTransform")
	struct MatrixAffineTransform {
	/// Test that the identity matrix is recognized as affine.
	///
	/// An affine matrix has bottom row [0, 0, 0, 1].
	///
		@Test("isAffine #1")
		func isAffine_1() async throws {
			#expect(Matrix4x4<Double>.identity.isAffine == true)
		}

	/// Test that a scale + translation matrix is recognized as affine.
	///
		@Test("isAffine #2")
		func isAffine_2() async throws {
			// Scale(2,3,4) + Translation(5,6,7) — affine, bottom row [0,0,0,1].
			let matrix = Matrix4x4(rows:
				Vector4(2.0, 0.0, 0.0, 5.0),
				Vector4(0.0, 3.0, 0.0, 6.0),
				Vector4(0.0, 0.0, 4.0, 7.0),
				Vector4(0.0, 0.0, 0.0, 1.0)
			)
			#expect(matrix.isAffine == true)
		}

	/// Test that perturbing a bottom-row element causes isAffine to return false.
	///
		@Test("isAffine #3")
		func isAffine_3() async throws {
			var matrix = Matrix4x4<Double>.identity
			// Perturb the [row 3, col 0] entry so the bottom row is no longer [0,0,0,1].
			matrix[0, 3] = 0.5
			#expect(matrix.isAffine == false)
		}

	/// Test that the scale getter on the identity matrix returns (1, 1, 1).
	///
		@Test("scale getter #1")
		func scaleGetter_1() async throws {
			let scale = Matrix4x4<Double>.identity.scale
			#expect(scale[0].isApproximatelyEqual(to: 1.0))
			#expect(scale[1].isApproximatelyEqual(to: 1.0))
			#expect(scale[2].isApproximatelyEqual(to: 1.0))
		}

	/// Test that the scale getter returns the correct per-axis scale lengths
	/// from a scaling matrix.
	///
	/// Input: init(withScale: Vector3(3, 5, 7))
	/// Output: scale = (3, 5, 7)
	///
		@Test("scale getter #2")
		func scaleGetter_2() async throws {
			let matrix = Matrix4x4<Double>(withScale: Vector3(3.0, 5.0, 7.0))
			let scale = matrix.scale
			#expect(scale[0].isApproximatelyEqual(to: 3.0))
			#expect(scale[1].isApproximatelyEqual(to: 5.0))
			#expect(scale[2].isApproximatelyEqual(to: 7.0))
		}

	/// Test that the scale setter rescales the direction vectors without
	/// changing their orientation.
	///
	/// Starting from the identity matrix (scale 1,1,1), set scale to (2,3,4)
	/// and verify the scale reads back correctly.
	///
		@Test("scale setter")
		func scaleSetter() async throws {
			var matrix = Matrix4x4<Double>.identity
			matrix.scale = Vector3(2.0, 3.0, 4.0)
			let scale = matrix.scale
			#expect(scale[0].isApproximatelyEqual(to: 2.0))
			#expect(scale[1].isApproximatelyEqual(to: 3.0))
			#expect(scale[2].isApproximatelyEqual(to: 4.0))
		}

	/// Test that the translation getter on the identity matrix returns zero.
	///
		@Test("translation getter #1")
		func translationGetter_1() async throws {
			let translation = Matrix4x4<Double>.identity.translation
			#expect(translation[0].isApproximatelyEqual(to: 0.0))
			#expect(translation[1].isApproximatelyEqual(to: 0.0))
			#expect(translation[2].isApproximatelyEqual(to: 0.0))
		}

	/// Test that the translation getter and setter round-trip correctly.
	///
		@Test("translation getter/setter")
		func translationGetterSetter() async throws {
			var matrix = Matrix4x4<Double>.identity
			matrix.translation = Vector3(5.0, -3.0, 7.5)
			let translation = matrix.translation
			#expect(translation[0].isApproximatelyEqual(to: 5.0))
			#expect(translation[1].isApproximatelyEqual(to: -3.0))
			#expect(translation[2].isApproximatelyEqual(to: 7.5))
		}

	/// Initialize a 4×4 matrix from a 90° Z rotation with XYZ order and
	/// verify the key rotational entries.
	///
	/// A 90° rotation around Z maps X→Y, Y→−X, Z→Z.
	///
		@Test("Rotation Initializer (XYZ)")
		func withRotationInitializer_XYZ() async throws {
			// Matrix4x4.Rotation is Vector3<Component> storing radians.
			let rotation = Vector3<Double>(0.0, 0.0, Double.pi / 2)

			let matrix = Matrix4x4<Double>(withRotation: rotation, order: .XYZ)

			// Column 0 should be (≈0, ≈1, 0) — the transformed X axis.
			#expect(matrix[0, 0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[0, 1].isApproximatelyEqual(to: 1.0))
			#expect(matrix[0, 2].isApproximatelyEqual(to: 0.0))
			// Column 1 should be (≈-1, ≈0, 0) — the transformed Y axis.
			#expect(matrix[1, 0].isApproximatelyEqual(to: -1.0))
			#expect(matrix[1, 1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[1, 2].isApproximatelyEqual(to: 0.0))
			// Column 2 should be (0, 0, 1) — Z is unchanged.
			#expect(matrix[2, 2].isApproximatelyEqual(to: 1.0))
			// Bottom-right corner must be 1.
			#expect(matrix[3, 3].isApproximatelyEqual(to: 1.0))
		}

	/// Initialize a 4×4 matrix from a 90° Z rotation with XZY order.
	///
		@Test("Rotation Initializer (XZY)")
		func withRotationInitializer_XZY() async throws {
			let rotation = Vector3<Double>(0.0, 0.0, Double.pi / 2)

			let matrix = Matrix4x4<Double>(withRotation: rotation, order: .XZY)

			// 90° around Z is the same regardless of order when the other angles are 0.
			#expect(matrix[0, 0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[0, 1].isApproximatelyEqual(to: 1.0))
			#expect(matrix[1, 0].isApproximatelyEqual(to: -1.0))
			#expect(matrix[1, 1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[2, 2].isApproximatelyEqual(to: 1.0))
			#expect(matrix[3, 3].isApproximatelyEqual(to: 1.0))
		}

	/// Initialize a 4×4 matrix from a 90° Z rotation with YXZ order.
	///
		@Test("Rotation Initializer (YXZ)")
		func withRotationInitializer_YXZ() async throws {
			let rotation = Vector3<Double>(0.0, 0.0, Double.pi / 2)

			let matrix = Matrix4x4<Double>(withRotation: rotation, order: .YXZ)

			#expect(matrix[0, 0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[0, 1].isApproximatelyEqual(to: 1.0))
			#expect(matrix[1, 0].isApproximatelyEqual(to: -1.0))
			#expect(matrix[1, 1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[2, 2].isApproximatelyEqual(to: 1.0))
			#expect(matrix[3, 3].isApproximatelyEqual(to: 1.0))
		}

	/// Initialize a 4×4 matrix from a 90° Z rotation with YZX order.
	///
		@Test("Rotation Initializer (YZX)")
		func withRotationInitializer_YZX() async throws {
			let rotation = Vector3<Double>(0.0, 0.0, Double.pi / 2)

			let matrix = Matrix4x4<Double>(withRotation: rotation, order: .YZX)

			#expect(matrix[0, 0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[0, 1].isApproximatelyEqual(to: 1.0))
			#expect(matrix[1, 0].isApproximatelyEqual(to: -1.0))
			#expect(matrix[1, 1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[2, 2].isApproximatelyEqual(to: 1.0))
			#expect(matrix[3, 3].isApproximatelyEqual(to: 1.0))
		}

	/// Initialize a 4×4 matrix from a 90° Z rotation with ZXY order.
	///
		@Test("Rotation Initializer (ZXY)")
		func withRotationInitializer_ZXY() async throws {
			let rotation = Vector3<Double>(0.0, 0.0, Double.pi / 2)

			let matrix = Matrix4x4<Double>(withRotation: rotation, order: .ZXY)

			#expect(matrix[0, 0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[0, 1].isApproximatelyEqual(to: 1.0))
			#expect(matrix[1, 0].isApproximatelyEqual(to: -1.0))
			#expect(matrix[1, 1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[2, 2].isApproximatelyEqual(to: 1.0))
			#expect(matrix[3, 3].isApproximatelyEqual(to: 1.0))
		}

	/// Initialize a 4×4 matrix from a 90° Z rotation with ZYX order.
	///
		@Test("Rotation Initializer (ZYX)")
		func withRotationInitializer_ZYX() async throws {
			let rotation = Vector3<Double>(0.0, 0.0, Double.pi / 2)

			let matrix = Matrix4x4<Double>(withRotation: rotation, order: .ZYX)

			#expect(matrix[0, 0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[0, 1].isApproximatelyEqual(to: 1.0))
			#expect(matrix[1, 0].isApproximatelyEqual(to: -1.0))
			#expect(matrix[1, 1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[2, 2].isApproximatelyEqual(to: 1.0))
			#expect(matrix[3, 3].isApproximatelyEqual(to: 1.0))
		}

	/// Test toRotation round-trip: build a matrix from known Euler angles (in
	/// radians) and verify that extracting them back gives the same values.
	///
		@Test("toRotation round-trip (XYZ)")
		func toRotationRoundTrip_XYZ() async throws {
			let input = Vector3<Double>(
				30.0 * Double.pi / 180.0,
				45.0 * Double.pi / 180.0,
				60.0 * Double.pi / 180.0
			)

			let matrix = Matrix4x4<Double>(withRotation: input, order: .XYZ)
			let output = matrix.toRotation(order: .XYZ)

			#expect(output[0].isApproximatelyEqual(to: input[0]))
			#expect(output[1].isApproximatelyEqual(to: input[1]))
			#expect(output[2].isApproximatelyEqual(to: input[2]))
		}

	/// Round-trip for XZY order. Middle axis is Z; keep |rz| well below 90°.
	///
		@Test("toRotation round-trip (XZY)")
		func toRotationRoundTrip_XZY() async throws {
			let input = Vector3<Double>(
				-20.0 * Double.pi / 180.0,
				50.0 * Double.pi / 180.0,
				35.0 * Double.pi / 180.0
			)
			let matrix = Matrix4x4<Double>(withRotation: input, order: .XZY)
			let output = matrix.toRotation(order: .XZY)
			#expect(output[0].isApproximatelyEqual(to: input[0]))
			#expect(output[1].isApproximatelyEqual(to: input[1]))
			#expect(output[2].isApproximatelyEqual(to: input[2]))
		}

	/// Round-trip for YXZ order. Middle axis is X; keep |rx| well below 90°.
	///
		@Test("toRotation round-trip (YXZ)")
		func toRotationRoundTrip_YXZ() async throws {
			let input = Vector3<Double>(
				40.0 * Double.pi / 180.0,
				-30.0 * Double.pi / 180.0,
				20.0 * Double.pi / 180.0
			)
			let matrix = Matrix4x4<Double>(withRotation: input, order: .YXZ)
			let output = matrix.toRotation(order: .YXZ)
			#expect(output[0].isApproximatelyEqual(to: input[0]))
			#expect(output[1].isApproximatelyEqual(to: input[1]))
			#expect(output[2].isApproximatelyEqual(to: input[2]))
		}

	/// Round-trip for YZX order. Middle axis is Z; keep |rz| well below 90°.
	///
		@Test("toRotation round-trip (YZX)")
		func toRotationRoundTrip_YZX() async throws {
			let input = Vector3<Double>(
				15.0 * Double.pi / 180.0,
				45.0 * Double.pi / 180.0,
				-25.0 * Double.pi / 180.0
			)
			let matrix = Matrix4x4<Double>(withRotation: input, order: .YZX)
			let output = matrix.toRotation(order: .YZX)
			#expect(output[0].isApproximatelyEqual(to: input[0]))
			#expect(output[1].isApproximatelyEqual(to: input[1]))
			#expect(output[2].isApproximatelyEqual(to: input[2]))
		}

	/// Round-trip for ZXY order. Middle axis is X; keep |rx| well below 90°.
	///
		@Test("toRotation round-trip (ZXY)")
		func toRotationRoundTrip_ZXY() async throws {
			let input = Vector3<Double>(
				-35.0 * Double.pi / 180.0,
				20.0 * Double.pi / 180.0,
				55.0 * Double.pi / 180.0
			)
			let matrix = Matrix4x4<Double>(withRotation: input, order: .ZXY)
			let output = matrix.toRotation(order: .ZXY)
			#expect(output[0].isApproximatelyEqual(to: input[0]))
			#expect(output[1].isApproximatelyEqual(to: input[1]))
			#expect(output[2].isApproximatelyEqual(to: input[2]))
		}

	/// Round-trip for ZYX order. Middle axis is Y; keep |ry| well below 90°.
	///
		@Test("toRotation round-trip (ZYX)")
		func toRotationRoundTrip_ZYX() async throws {
			let input = Vector3<Double>(
				25.0 * Double.pi / 180.0,
				-15.0 * Double.pi / 180.0,
				60.0 * Double.pi / 180.0
			)
			let matrix = Matrix4x4<Double>(withRotation: input, order: .ZYX)
			let output = matrix.toRotation(order: .ZYX)
			#expect(output[0].isApproximatelyEqual(to: input[0]))
			#expect(output[1].isApproximatelyEqual(to: input[1]))
			#expect(output[2].isApproximatelyEqual(to: input[2]))
		}

	/// Create a 4×4 matrix from a uniform scale and verify the diagonal.
	///
		@Test("Uniform Scale Initializer #1")
		func withUniformScaleInitializer_1() async throws {
			let matrix = Matrix4x4<Double>(withScale: 3.0)
			for x in 0..<3 {
				for y in 0..<3 {
					if x == y {
						#expect(matrix[x, y].isApproximatelyEqual(to: 3.0))
					}
					else {
						#expect(matrix[x, y].isApproximatelyEqual(to: 0.0))
					}
				}
			}
			// The w/w entry must remain 1 (identity row for homogeneous coords).
			#expect(matrix[3, 3].isApproximatelyEqual(to: 1.0))
		}

	/// Create a 4×4 matrix from a per-axis scale vector and verify the diagonal.
	///
		@Test("Scale Initializer #1")
		func withScaleInitializer_1() async throws {
			let matrix = Matrix4x4<Double>(withScale: Vector3(2.0, 4.0, 8.0))
			#expect(matrix[0, 0].isApproximatelyEqual(to: 2.0))
			#expect(matrix[1, 1].isApproximatelyEqual(to: 4.0))
			#expect(matrix[2, 2].isApproximatelyEqual(to: 8.0))
			#expect(matrix[3, 3].isApproximatelyEqual(to: 1.0))
			// Off-diagonal entries in the 3×3 block must be zero.
			#expect(matrix[0, 1].isApproximatelyEqual(to: 0.0))
			#expect(matrix[1, 0].isApproximatelyEqual(to: 0.0))
		}

	/// Create a 4×4 matrix from a translation vector and verify column 3.
	///
		@Test("Translation Initializer")
		func withTranslationInitializer() async throws {
			let matrix = Matrix4x4<Double>(withTranslation: Vector3(10.0, 20.0, 30.0))
			// The 3×3 upper-left block is identity.
			for x in 0..<3 {
				for y in 0..<3 {
					#expect(matrix[x, y].isApproximatelyEqual(to: x == y ? 1.0 : 0.0))
				}
			}
			// Column 3 holds the translation.
			#expect(matrix[3, 0].isApproximatelyEqual(to: 10.0))
			#expect(matrix[3, 1].isApproximatelyEqual(to: 20.0))
			#expect(matrix[3, 2].isApproximatelyEqual(to: 30.0))
			#expect(matrix[3, 3].isApproximatelyEqual(to: 1.0))
		}
	}
}

extension Matrix4x4Tests {
	@Suite("QuaternionConvertible")
	struct QuaternionConvertible {
	/// Initialize a 4×4 matrix from a quaternion representing a 90° rotation
	/// around the Z axis and verify the rotational entries.
	///
	/// A 90° rotation around Z maps X→Y, Y→−X, Z→Z.
	///
		@Test("init(withQuaternion:)")
		func initWithQuaternion() async throws {
			let quaternion = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: .degrees(90.0)
			)

			let matrix = Matrix4x4(withQuaternion: quaternion)

			// Column 0 = transformed X axis = (≈0, ≈1, 0, 0)
			#expect(matrix[0, 0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[0, 1].isApproximatelyEqual(to: 1.0))
			#expect(matrix[0, 2].isApproximatelyEqual(to: 0.0))
			#expect(matrix[0, 3].isApproximatelyEqual(to: 0.0))
			// Column 1 = transformed Y axis = (≈-1, ≈0, 0, 0)
			#expect(matrix[1, 0].isApproximatelyEqual(to: -1.0))
			#expect(matrix[1, 1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[1, 2].isApproximatelyEqual(to: 0.0))
			#expect(matrix[1, 3].isApproximatelyEqual(to: 0.0))
			// Column 2 = Z axis unchanged
			#expect(matrix[2, 2].isApproximatelyEqual(to: 1.0))
			// Homogeneous row/col
			#expect(matrix[3, 3].isApproximatelyEqual(to: 1.0))
		}

	/// Test the quaternion getter: convert a rotation matrix to a quaternion
	/// and back to a matrix; the 3×3 rotational block must be approximately
	/// equal to the original.
	///
		@Test("quaternion round-trip")
		func quaternionRoundTrip() async throws {
			let original = Matrix4x4<Double>(withRotation:
				Vector3<Double>(30.0 * .pi / 180.0, 45.0 * .pi / 180.0, 60.0 * .pi / 180.0),
				order: .XYZ
			)

			let quaternion = original.quaternion
			let reconstructed = Matrix4x4<Double>(withQuaternion: quaternion)

			// The 3×3 rotational block should be approximately equal.
			for column in 0..<3 {
				for row in 0..<3 {
					#expect(reconstructed[column, row].isApproximatelyEqual(to: original[column, row]))
				}
			}
		}
	}
}
