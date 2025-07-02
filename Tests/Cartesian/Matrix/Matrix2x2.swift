//
//  Matrix2x2.swift
//  Cartesian
//
//  Created by Matt Cox on 09/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import Foundation
import Testing

@testable import Cartesian

// The simd module (where available) provides additional testing, using it as
// functional benchmark to test against - the results from Cartesian are tested
// against the results from similar functions in the simd library.
//
#if canImport(simd)
import simd
#endif

@Suite("Matrix2x2")
struct Matrix2x2Tests {
/// Tests the default initializer, which is expected to create an empty
/// matrix with zeros everywhere.
///
/// Output:
/// ```swift
/// | 0  0 |
/// | 0  0 |
/// ```
///
	@Test("Initializer")
	func initializer() async throws {
		let matrix: Matrix2x2<Double> = Matrix2x2()
		for x in 0..<2 {
			for y in 0..<2 {
				#expect(matrix[x][y] == .zero)
			}
		}
	}
	
/// Tests the column initializer, which is expected to insert the values
/// provided into the columns.
///
/// Input:
/// ```swift
/// [1.0, 2.0], [3.0, 4.0]
/// ```
///
/// Output:
/// ```swift
/// | 1.0  3.0 |
/// | 2.0  4.0 |
/// ```
///
	@Test("Column Initializer")
	func columnInitializer() async throws {
		let matrix = Matrix2x2(columns:
			Vector2(1.0, 2.0),
			Vector2(3.0, 4.0)
		)

		#expect(matrix[0][0] == 1.0)
		#expect(matrix[0][1] == 2.0)
		#expect(matrix[1][0] == 3.0)
		#expect(matrix[1][1] == 4.0)
	}
	
/// Tests the row initializer, which is expected to insert the values
/// provided into the columns.
///
/// Input:
/// ```swift
/// [1.0, 2.0], [3.0, 4.0]
/// ```
///
/// Output:
/// ```swift
/// | 1.0  2.0 |
/// | 3.0  4.0 |
/// ```
///
	@Test("Row Initializer")
	func rowInitializer() async throws {
		let matrix = Matrix2x2(rows:
			Vector2(1.0, 2.0),
			Vector2(3.0, 4.0)
		)

		#expect(matrix[0][0] == 1.0)
		#expect(matrix[0][1] == 3.0)
		#expect(matrix[1][0] == 2.0)
		#expect(matrix[1][1] == 4.0)
	}
	
/// Tests the array literal initializer, which is expected to create the
/// matrix as it appears visually.
///
/// Input:
/// ```swift
/// [[1.0, 2.0],
///  [3.0, 4.0]]
/// ```
///
/// Output:
/// ```swift
/// | 1.0  2.0 |
/// | 3.0  4.0 |
/// ```
///
	@Test("Array Literal Initializer")
	func arrayLiteralInitializer() async throws {
		let matrix: Matrix2x2 = [
			[1.0, 2.0],
			[3.0, 4.0]
		]

		#expect(matrix[0][0] == 1.0)
		#expect(matrix[0][1] == 3.0)
		#expect(matrix[1][0] == 2.0)
		#expect(matrix[1][1] == 4.0)
	}
	
/// Attempt to encode and decode the matrix as JSON.
///
/// All four values in the matrix should be encoded and decoded correctly.
///
	@Test("Serialization")
	func serialization() async throws {
		let matrix = Matrix2x2(rows:
			Vector2(1.0, 2.0),
			Vector2(3.0, 4.0)
		)
		
		let encoded = try JSONEncoder().encode(matrix)
		let decoded = try JSONDecoder().decode(Matrix2x2<Double>.self, from: encoded)
		
		for x in 0..<2 {
			for y in 0..<2 {
				#expect(matrix[x][y] == decoded[x][y])
			}
		}
	}
	
/// Test if two matrices are equatable.
///
	@Test("Equatable")
	func equatable() async throws {
		let one = Matrix2x2(rows:
			Vector2(1.0, 2.0),
			Vector2(3.0, 4.0)
		)
		
		let two = Matrix2x2(rows:
			Vector2(1.0 + .ulpOfOne, 2.0 - .ulpOfOne),
			Vector2(3.0 + .ulpOfOne, 4.0 - .ulpOfOne)
		)
		
		#expect(one == one)
		#expect(one != two)
	}
}

extension Matrix2x2Tests {
	@Suite("Identity")
	struct Identity {
	/// Test the `identity` static property to make sure it returns an
	/// identity matrix.
	///
	/// Output:
	/// ```swift
	/// | 1  0 |
	/// | 0  1 |
	/// ```
	///
		@Test("identity")
		func identity() async throws {
			let identity = Matrix2x2<Double>.identity
			for column in 0..<2 {
				for row in 0..<2 {
					#expect(identity[column, row] == (column == row ? 1 : 0))
				}
			}
		}

	/// Test the `isIdentity` function to see if it correctly identifies
	/// matrices that are identity.
	///
	/// ## Test 1
	/// Input:
	/// ```swift
	/// | 0  0 |
	/// | 0  0 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// false
	/// ```
	///
	/// ## Test 2
	/// Input:
	/// ```swift
	/// | 1  0 |
	/// | 0  1 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// true
	/// ```
	///
	/// ## Test 3
	/// Input:
	/// ```swift
	/// | 1+ε   0  |
	/// |  0   1-ε |
	/// ```
	///
	/// Output:
	/// ```swift
	/// false
	/// ```
	///
		@Test("isIdentity")
		func isIdentity() async throws {
			// The default initializer should create an empty matrix, so this is
			// expected to not be identity.
			//
			#expect(Matrix2x2<Double>().isIdentity == false)
			
			// Manually create what we think of as an identity matrix.
			//
			var matrix = Matrix2x2<Double>()
			for column in 0..<2 {
				for row in 0..<2 {
					matrix[column, row] = column == row ? 1 : 0
				}
			}
			#expect(matrix.isIdentity == true)
			
			// Make a minor change to the values in the main diagonal. It should no
			// long be identity.
			//
			for index in 0..<2 {
				matrix[index, index] += ((index % 2) == 0) ? Double.ulpOfOne : -Double.ulpOfOne
			}
			#expect(matrix.isIdentity == false)
		}
		
	/// Test the `toIdentity` function to see if it correctly sets the
	/// matrix to identity.
	///
	/// Input:
	/// ```swift
	/// | 10  20 |
	/// | 30  40 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// | 1  0 |
	/// | 0  1 |
	/// ```
	///
		@Test("toIdentity")
		func toIdentity() async throws {
			var matrix = Matrix2x2(rows:
				Vector2(10.0, 20.0),
				Vector2(30.0, 40.0)
			)
			
			for column in 0..<2 {
				for row in 0..<2 {
					#expect(matrix[column, row] != (column == row ? 1 : 0))
				}
			}
			
			matrix.toIdentity()
			
			for column in 0..<2 {
				for row in 0..<2 {
					#expect(matrix[column, row] == (column == row ? 1 : 0))
				}
			}
		}
	}
}

extension Matrix2x2Tests {
	@Suite("Invertible")
	struct Invertible {
	/// Attempt to invert two matrices; one that can be inverted and another
	/// that cannot be.
	///
	///
	/// ## Test 1
	/// Input:
	/// ```swift
	/// | 3  2 |
	/// | 1  4 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// |  0.4  -0.2 |
	/// | -0.1   0.3 |
	/// ```
	///
	/// ## Test 2
	/// Input:
	/// ```swift
	/// | 2  4 |
	/// | 1  2 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// nil  // This matrix cannot be inverted
	/// ```
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double2x2` type.
	///
		@Test("inverse")
		func inverse() async throws {
			let canInvert = Matrix2x2(columns:
				Vector2(3.0, 1.0),
				Vector2(2.0, 4.0)
			)
			
			let cannotInvert = Matrix2x2(columns:
				Vector2(2.0, 1.0),
				Vector2(4.0, 2.0)
			)
			
			let canInvertInverse = canInvert.inverse
			let cannotInvertInverse = cannotInvert.inverse
			
			#expect(canInvertInverse != nil)
			#expect(canInvertInverse?[0, 0].isApproximatelyEqual(to: 0.4) ?? false)
			#expect(canInvertInverse?[0, 1].isApproximatelyEqual(to: -0.1) ?? false)
			#expect(canInvertInverse?[1, 0].isApproximatelyEqual(to: -0.2) ?? false)
			#expect(canInvertInverse?[1, 1].isApproximatelyEqual(to: 0.3) ?? false)
			
			#expect(cannotInvertInverse == nil)
			
		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let canInvertSIMD = simd_double2x2(
				SIMD2<Double>(3.0, 1.0),
				SIMD2<Double>(2.0, 4.0)
			)
				
			let canInvertSIMDInverse = canInvertSIMD.inverse
			
			for x in 0..<2 {
				for y in 0..<2 {
					#expect(canInvertSIMDInverse[x, y] == canInvertInverse?[x, y])
				}
			}
		#endif
		}
	
	/// Attempt to invert two matrices; one that can be inverted and another
	/// that cannot be.
	///
	///
	/// ## Test 1
	/// Input:
	/// ```swift
	/// | 3  2 |
	/// | 1  4 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// true
	/// ```
	/// ```swift
	/// |  0.4  -0.2 |
	/// | -0.1   0.3 |
	/// ```
	///
	/// ## Test 2
	/// Input:
	/// ```swift
	/// | 2  4 |
	/// | 1  2 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// false
	/// ```
	/// ```swift
	/// | 2  4 |
	/// | 1  2 |
	/// ```
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double2x2` type.
	///
		@Test("invert")
		func invert() async throws {
			var canInvert = Matrix2x2(columns:
				Vector2(3.0, 1.0),
				Vector2(2.0, 4.0)
			)
			
			var cannotInvert = Matrix2x2(columns:
				Vector2(2.0, 1.0),
				Vector2(4.0, 2.0)
			)
			
			#expect(canInvert.invert() == true)
			#expect(cannotInvert.invert() == false)
			
			#expect(canInvert[0, 0].isApproximatelyEqual(to: 0.4))
			#expect(canInvert[0, 1].isApproximatelyEqual(to: -0.1))
			#expect(canInvert[1, 0].isApproximatelyEqual(to: -0.2))
			#expect(canInvert[1, 1].isApproximatelyEqual(to: 0.3))
			
		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			var canInvertSIMD = simd_double2x2(
				SIMD2<Double>(3.0, 1.0),
				SIMD2<Double>(2.0, 4.0)
			)
			canInvertSIMD = canInvertSIMD.inverse
			
			for x in 0..<2 {
				for y in 0..<2 {
					#expect(canInvertSIMD[x, y] == canInvert[x, y])
				}
			}
		#endif
		}
	}
}

extension Matrix2x2Tests {
	@Suite("MatrixMath")
	struct MatrixMath {
	/// Tests adding two matrices together.
	///
	/// Input:
	/// ```swift
	/// | 1  3 | + | 5  7 |
	/// | 2  4 |   | 6  8 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// | 6  10 |
	/// | 8  12 |
	/// ```
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double2x2` type.
	///
		@Test("Addition")
		func addition() async throws {
			let lhs = Matrix2x2(columns:
				Vector2(1.0, 2.0),
				Vector2(3.0, 4.0)
			)
			
			let rhs = Matrix2x2(columns:
				Vector2(5.0, 6.0),
				Vector2(7.0, 8.0)
			)
			
			let result = lhs + rhs
			
			#expect(result[0, 0] == 6.0)
			#expect(result[0, 1] == 8.0)
			#expect(result[1, 0] == 10.0)
			#expect(result[1, 1] == 12.0)
			
		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let lhsSIMD = simd_double2x2(
				SIMD2<Double>(1.0, 2.0),
				SIMD2<Double>(3.0, 4.0)
			)
			
			let rhsSIMD = simd_double2x2(
				SIMD2<Double>(5.0, 6.0),
				SIMD2<Double>(7.0, 8.0)
			)
			
			let resultSIMD = lhsSIMD + rhsSIMD
			
			for x in 0..<2 {
				for y in 0..<2 {
					#expect(result[x, y] == resultSIMD[x, y])
				}
			}
		#endif
		}
		
	/// Tests adding two matrices together, mutating the first matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  3 | + | 5  7 |
	/// | 2  4 |   | 6  8 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// | 6  10 |
	/// | 8  12 |
	/// ```
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double2x2` type.
	///
		@Test("Addition Assignment")
		func additionAssignment() async throws {
			var lhs = Matrix2x2(columns:
				Vector2(1.0, 2.0),
				Vector2(3.0, 4.0)
			)
			
			let rhs = Matrix2x2(columns:
				Vector2(5.0, 6.0),
				Vector2(7.0, 8.0)
			)
			
			lhs += rhs
			
			#expect(lhs[0, 0] == 6.0)
			#expect(lhs[0, 1] == 8.0)
			#expect(lhs[1, 0] == 10.0)
			#expect(lhs[1, 1] == 12.0)
			
		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			var lhsSIMD = simd_double2x2(
				SIMD2<Double>(1.0, 2.0),
				SIMD2<Double>(3.0, 4.0)
			)
			
			let rhsSIMD = simd_double2x2(
				SIMD2<Double>(5.0, 6.0),
				SIMD2<Double>(7.0, 8.0)
			)
			
			lhsSIMD += rhsSIMD
			
			for x in 0..<2 {
				for y in 0..<2 {
					#expect(lhs[x, y] == lhsSIMD[x, y])
				}
			}
		#endif
		}
		
	/// Tests negating a matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  3 |
	/// | 2  4 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// | -1  -3 |
	/// | -2  -4 |
	/// ```
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double2x2` type.
	///
		@Test("Negation")
		func negation() async throws {
			let rhs = Matrix2x2(columns:
				Vector2(1.0, 2.0),
				Vector2(3.0, 4.0)
			)
			
			let result = -rhs
			
			#expect(result[0, 0] == -1.0)
			#expect(result[0, 1] == -2.0)
			#expect(result[1, 0] == -3.0)
			#expect(result[1, 1] == -4.0)
			
		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let rhsSIMD = simd_double2x2(
				SIMD2<Double>(1.0, 2.0),
				SIMD2<Double>(3.0, 4.0)
			)
			
			let resultSIMD = -rhsSIMD
			
			for x in 0..<2 {
				for y in 0..<2 {
					#expect(result[x, y] == resultSIMD[x, y])
				}
			}
		#endif
		}
		
	/// Tests subtracting one matrix from another.
	///
	/// Input:
	/// ```swift
	/// | 4  2 | - | 5  7 |
	/// | 6  8 |   | 3  1 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// | -1  -5 |
	/// |  3   7 |
	/// ```
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double2x2` type.
	///
		@Test("Subtraction")
		func subtraction() async throws {
			let lhs = Matrix2x2(columns:
				Vector2(4.0, 6.0),
				Vector2(2.0, 8.0)
			)

			let rhs = Matrix2x2(columns:
				Vector2(5.0, 3.0),
				Vector2(7.0, 1.0)
			)
			
			let result = lhs - rhs
			
			#expect(result[0, 0] == -1.0)
			#expect(result[0, 1] ==  3.0)
			#expect(result[1, 0] == -5.0)
			#expect(result[1, 1] ==  7.0)
			
		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let lhsSIMD = simd_double2x2(
				SIMD2<Double>(4.0, 6.0),
				SIMD2<Double>(2.0, 8.0)
			)
			
			let rhsSIMD = simd_double2x2(
				SIMD2<Double>(5.0, 3.0),
				SIMD2<Double>(7.0, 1.0)
			)
			
			let resultSIMD = lhsSIMD - rhsSIMD
			
			for x in 0..<2 {
				for y in 0..<2 {
					#expect(result[x, y] == resultSIMD[x, y])
				}
			}
		#endif
		}
		
	/// Tests subtracting one matrix from another, mutating the first matrix.
	///
	/// Input:
	/// ```swift
	/// | 4  2 | - | 5  7 |
	/// | 6  8 |   | 3  1 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// | -1  -5 |
	/// |  3   7 |
	/// ```
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double2x2` type.
	///
		@Test("Subtraction Assignment")
		func subtractionAssignment() async throws {
			var lhs = Matrix2x2(columns:
				Vector2(4.0, 6.0),
				Vector2(2.0, 8.0)
			)
			
			let rhs = Matrix2x2(columns:
				Vector2(5.0, 3.0),
				Vector2(7.0, 1.0)
			)
			
			lhs -= rhs
			
			#expect(lhs[0, 0] == -1.0)
			#expect(lhs[0, 1] ==  3.0)
			#expect(lhs[1, 0] == -5.0)
			#expect(lhs[1, 1] ==  7.0)
			
		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			var lhsSIMD = simd_double2x2(
				SIMD2<Double>(4.0, 6.0),
				SIMD2<Double>(2.0, 8.0)
			)
			
			let rhsSIMD = simd_double2x2(
				SIMD2<Double>(5.0, 3.0),
				SIMD2<Double>(7.0, 1.0)
			)
			
			lhsSIMD -= rhsSIMD
			
			for x in 0..<2 {
				for y in 0..<2 {
					#expect(lhs[x, y] == lhsSIMD[x, y])
				}
			}
		#endif
		}
	
	/// Tests multiplying one matrix by another.
	///
	/// Input:
	/// ```swift
	/// | 4  2 | * | 5  7 |
	/// | 6  8 |   | 3  1 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// | 26  30 |
	/// | 54  50 |
	/// ```
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double2x2` type.
	///
		@Test("Multiplication")
		func multiplication() async throws {
			let lhs = Matrix2x2(columns:
				Vector2(4.0, 6.0),
				Vector2(2.0, 8.0)
			)
			
			let rhs = Matrix2x2(columns:
				Vector2(5.0, 3.0),
				Vector2(7.0, 1.0)
			)
			
			let result = lhs * rhs
			
			#expect(result[0, 0] == 26.0)
			#expect(result[0, 1] == 54.0)
			#expect(result[1, 0] == 30.0)
			#expect(result[1, 1] == 50.0)
			
		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let lhsSIMD = simd_double2x2(
				SIMD2<Double>(4.0, 6.0),
				SIMD2<Double>(2.0, 8.0)
			)
			
			let rhsSIMD = simd_double2x2(
				SIMD2<Double>(5.0, 3.0),
				SIMD2<Double>(7.0, 1.0)
			)
			
			let resultSIMD = lhsSIMD * rhsSIMD
			
			for x in 0..<2 {
				for y in 0..<2 {
					#expect(result[x, y] == resultSIMD[x, y])
				}
			}
		#endif
		}
		
	/// Tests multiplying one matrix by another, mutating the first matrix.
	///
	/// Input:
	/// ```swift
	/// | 4  2 | * | 5  7 |
	/// | 6  8 |   | 3  1 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// | 26  30 |
	/// | 54  50 |
	/// ```
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double2x2` type.
	///
		@Test("Multiplication Assignment")
		func multiplicationAssignment() async throws {
			var lhs = Matrix2x2(columns:
				Vector2(4.0, 6.0),
				Vector2(2.0, 8.0)
			)
			
			let rhs = Matrix2x2(columns:
				Vector2(5.0, 3.0),
				Vector2(7.0, 1.0)
			)
			
			lhs *= rhs
			
			#expect(lhs[0, 0] == 26.0)
			#expect(lhs[0, 1] == 54.0)
			#expect(lhs[1, 0] == 30.0)
			#expect(lhs[1, 1] == 50.0)
			
		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			var lhsSIMD = simd_double2x2(
				SIMD2<Double>(4.0, 6.0),
				SIMD2<Double>(2.0, 8.0)
			)
			
			let rhsSIMD = simd_double2x2(
				SIMD2<Double>(5.0, 3.0),
				SIMD2<Double>(7.0, 1.0)
			)
			
			lhsSIMD *= rhsSIMD
			
			for x in 0..<2 {
				for y in 0..<2 {
					#expect(lhs[x, y] == lhsSIMD[x, y])
				}
			}
		#endif
		}
		
	/// Tests multiplying a matrix by a scalar.
	///
	/// Input:
	/// ```swift
	/// | 1  3 | * 3.0
	/// | 2  4 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// | 3   9 |
	/// | 6  12 |
	/// ```
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double2x2` type.
	///
		@Test("Scalar Multiplication")
		func scalarMultiplication() async throws {
			let matrix = Matrix2x2(columns:
				Vector2(1.0, 2.0),
				Vector2(3.0, 4.0)
			)
			
			let scalar = 3.0
			
			let result1 = matrix * scalar
			let result2 = scalar * matrix
			
			for x in 0..<2 {
				for y in 0..<2 {
					#expect(result1[x, y] == result2[x, y])
				}
			}
			
			#expect(result1[0, 0] == 3.0)
			#expect(result1[0, 1] == 6.0)
			#expect(result1[1, 0] == 9.0)
			#expect(result1[1, 1] == 12.0)
			
		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let matrixSIMD = simd_double2x2(
				SIMD2<Double>(1.0, 2.0),
				SIMD2<Double>(3.0, 4.0)
			)
			
			let resultSIMD1 = matrixSIMD * scalar
			let resultSIMD2 = scalar * matrixSIMD
			
			for x in 0..<2 {
				for y in 0..<2 {
					#expect(resultSIMD1[x, y] == resultSIMD2[x, y])
					#expect(result1[x, y] == resultSIMD1[x, y])
				}
			}
		#endif
		}
		
	/// Tests multiplying a matrix by a scalar, mutating the matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  3 | * 3.0
	/// | 2  4 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// | 3   9 |
	/// | 6  12 |
	/// ```
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double2x2` type.
	///
		@Test("Scalar Multiplication Assignment")
		func scalarMultiplicationAssignment() async throws {
			var lhs = Matrix2x2(columns:
				Vector2(1.0, 2.0),
				Vector2(3.0, 4.0)
			)
			
			let rhs = 3.0
			
			lhs *= rhs
			
			#expect(lhs[0, 0] == 3.0)
			#expect(lhs[0, 1] == 6.0)
			#expect(lhs[1, 0] == 9.0)
			#expect(lhs[1, 1] == 12.0)
			
		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			var lhsSIMD = simd_double2x2(
				SIMD2<Double>(1.0, 2.0),
				SIMD2<Double>(3.0, 4.0)
			)
			
			lhsSIMD *= rhs
			
			for x in 0..<2 {
				for y in 0..<2 {
					#expect(lhs[x, y] == lhsSIMD[x, y])
				}
			}
		#endif
		}
	}
}

extension Matrix2x2Tests {
	/// Tests multiplying a vector by a matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  3 | * [5, 6]
	/// | 2  4 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// [23, 34]
	/// ```
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double2x2` type.
	///
	@Suite("MatrixVectorMath")
	struct MatrixVectorMath {
		@Test("Vector Multiplication")
		func multiplication() async throws {
			let lhs = Matrix2x2(columns:
				Vector2(1.0, 2.0),
				Vector2(3.0, 4.0)
			)
			
			let rhs = Vector2(5.0, 6.0)
			
			let result = lhs * rhs
			
			#expect(result[0] == 23.0)
			#expect(result[1] == 34.0)
			
		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let lhsSIMD = simd_double2x2(
				SIMD2<Double>(1.0, 2.0),
				SIMD2<Double>(3.0, 4.0)
			)
			
			let rhsSIMD = simd_double2(5.0, 6.0)
			
			let resultSIMD = lhsSIMD * rhsSIMD
			
			#expect(result[0] == resultSIMD[0])
			#expect(result[1] == resultSIMD[1])
		#endif
		}
	}
}

extension Matrix2x2Tests {
	@Suite("SquareMatrix")
	struct SquareMatrix {
	/// Tests getting the adjugate matrix of the matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  3 |
	/// | 2  4 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// |  4  -2 |
	/// | -3   1 |
	/// ```
	///
		@Test("adjugate")
		func adjugate() async throws {
			let matrix = Matrix2x2(columns:
				Vector2(1.0, 2.0),
				Vector2(3.0, 4.0)
			)

			let adjugate = matrix.adjugate
			
			#expect(adjugate[0, 0] ==  4.0)
			#expect(adjugate[0, 1] == -3.0)
			#expect(adjugate[1, 0] == -2.0)
			#expect(adjugate[1, 1] ==  1.0)
		}
		
	/// Tests getting the cofactor matrix of the matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  3 |
	/// | 2  4 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// |  4  -3 |
	/// | -2   1 |
	/// ```
	///
		@Test("cofactor")
		func cofactor() async throws {
			let matrix = Matrix2x2(columns:
				Vector2(1.0, 2.0),
				Vector2(3.0, 4.0)
			)

			let cofactor = matrix.cofactor
			
			#expect(cofactor[0, 0] ==  4.0)
			#expect(cofactor[0, 1] == -2.0)
			#expect(cofactor[1, 0] == -3.0)
			#expect(cofactor[1, 1] ==  1.0)
		}
	
	/// Tests getting the determinant of the matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  3 |
	/// | 2  4 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// -2.0
	/// ```
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double2x2` type.
	///
		@Test("determinant")
		func determinant() async throws {
			let matrix = Matrix2x2(columns:
				Vector2(1.0, 2.0),
				Vector2(3.0, 4.0)
			)
			
			let determinant = matrix.determinant
			
			#expect(determinant == -2.0)
			
		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let matrixSIMD = simd_double2x2(
				SIMD2<Double>(1.0, 2.0),
				SIMD2<Double>(3.0, 4.0)
			)
			let determinantSIMD = matrixSIMD.determinant
			
			#expect(determinant == determinantSIMD)
		#endif
		}
	
	/// Tests calculating the trace of the matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  3 |
	/// | 2  4 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// 5.0
	/// ```
	///
		@Test("trace")
		func trace() async throws {
			let matrix = Matrix2x2(columns:
				Vector2(1.0, 2.0),
				Vector2(3.0, 4.0)
			)
			
			#expect(matrix.trace == 5)
		}
		
	/// Tests transposing the matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  3 |
	/// | 2  4 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// | 1  2 |
	/// | 3  4 |
	/// ```
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double2x2` type.
	///
		@Test("transposed")
		func transposed() async throws {
			let matrix = Matrix2x2(columns:
				Vector2(1.0, 2.0),
				Vector2(3.0, 4.0)
			)

			let result = matrix.transposed
			
			#expect(result[0, 0] == 1.0)
			#expect(result[0, 1] == 3.0)
			#expect(result[1, 0] == 2.0)
			#expect(result[1, 1] == 4.0)
			
		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let matrixSIMD = simd_double2x2(
				SIMD2<Double>(1.0, 2.0),
				SIMD2<Double>(3.0, 4.0)
			)
			
			let resultSIMD = matrixSIMD.transpose
			
			for x in 0..<2 {
				for y in 0..<2 {
					#expect(result[x, y] == resultSIMD[x, y])
				}
			}
		#endif
		}
		
	/// Tests transposing the matrix, mutating the matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  3 |
	/// | 2  4 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// | 1  2 |
	/// | 3  4 |
	/// ```
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double2x2` type.
	///
		@Test("transpose")
		func transpose() async throws {
			var matrix = Matrix2x2(columns:
				Vector2(1.0, 2.0),
				Vector2(3.0, 4.0)
			)

			matrix.transpose()
			
			#expect(matrix[0, 0] == 1.0)
			#expect(matrix[0, 1] == 3.0)
			#expect(matrix[1, 0] == 2.0)
			#expect(matrix[1, 1] == 4.0)
			
		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			var matrixSIMD = simd_double2x2(
				SIMD2<Double>(1.0, 2.0),
				SIMD2<Double>(3.0, 4.0)
			)

			matrixSIMD = matrixSIMD.transpose
			
			for x in 0..<2 {
				for y in 0..<2 {
					#expect(matrix[x, y] == matrixSIMD[x, y])
				}
			}
		#endif
		}
	}
}
