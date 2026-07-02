//
//  Matrix3x3.swift
//  Cartesian
//
//  Created by Matt Cox on 02/05/2025.
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

@Suite("Matrix3x3")
struct Matrix3x3Tests {
/// Tests the default initializer, which is expected to create an empty
/// matrix with zeros everywhere.
///
/// Output:
/// ```swift
/// | 0  0  0 |
/// | 0  0  0 |
/// | 0  0  0 |
/// ```
///
	@Test("Initializer")
	func initializer() async throws {
		let matrix: Matrix3x3<Double> = Matrix3x3()
		for x in 0..<3 {
			for y in 0..<3 {
				#expect(matrix[x][y] == .zero)
			}
		}
	}
	
/// Tests the column initializer, which is expected to insert the values
/// provided into the columns.
///
/// Input:
/// ```swift
/// [1.0, 2.0, 3.0], [4.0, 5.0, 6.0]
/// ```
///
/// Output:
/// ```swift
/// | 1.0  4.0  7.0 |
/// | 2.0  5.0  8.0 |
/// | 3.0  6.0  9.0 |
/// ```
///
	@Test("Column Initializer")
	func columnInitializer() async throws {
		let matrix = Matrix3x3(columns:
			Vector3(1.0, 2.0, 3.0),
			Vector3(4.0, 5.0, 6.0),
			Vector3(7.0, 8.0, 9.0)
		)

		#expect(matrix[0][0] == 1.0)
		#expect(matrix[0][1] == 2.0)
		#expect(matrix[0][2] == 3.0)
		#expect(matrix[1][0] == 4.0)
		#expect(matrix[1][1] == 5.0)
		#expect(matrix[1][2] == 6.0)
		#expect(matrix[2][0] == 7.0)
		#expect(matrix[2][1] == 8.0)
		#expect(matrix[2][2] == 9.0)
	}
	
/// Tests the row initializer, which is expected to insert the values
/// provided into the columns.
///
/// Input:
/// ```swift
/// [1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]
/// ```
///
/// Output:
/// ```swift
/// | 1.0  2.0  3.0 |
/// | 4.0  5.0  6.0 |
/// | 7.0  8.0  9.0 |
/// ```
///
	@Test("Row Initializer")
	func rowInitializer() async throws {
		let matrix = Matrix3x3(rows:
			Vector3(1.0, 2.0, 3.0),
			Vector3(4.0, 5.0, 6.0),
			Vector3(7.0, 8.0, 9.0),
		)

		#expect(matrix[0][0] == 1.0)
		#expect(matrix[0][1] == 4.0)
		#expect(matrix[0][2] == 7.0)
		#expect(matrix[1][0] == 2.0)
		#expect(matrix[1][1] == 5.0)
		#expect(matrix[1][2] == 8.0)
		#expect(matrix[2][0] == 3.0)
		#expect(matrix[2][1] == 6.0)
		#expect(matrix[2][2] == 9.0)
	}
	
/// Tests the array literal initializer, which is expected to create the
/// matrix as it appears visually.
///
/// Input:
/// ```swift
/// [[1.0, 2.0, 3.0],
///  [4.0, 5.0, 6.0],
///  [7.0, 8.0, 9.0]]
/// ```
///
/// Output:
/// ```swift
/// [[1.0, 2.0, 3.0],
///  [4.0, 5.0, 6.0],
///  [7.0, 8.0, 9.0]]
/// ```
///
	@Test("Array Literal Initializer")
	func arrayLiteralInitializer() async throws {
		let matrix: Matrix3x3 = [
			[1.0, 2.0, 3.0],
			[4.0, 5.0, 6.0],
			[7.0, 8.0, 9.0],
		]

		#expect(matrix[0][0] == 1.0)
		#expect(matrix[0][1] == 4.0)
		#expect(matrix[0][2] == 7.0)
		#expect(matrix[1][0] == 2.0)
		#expect(matrix[1][1] == 5.0)
		#expect(matrix[1][2] == 8.0)
		#expect(matrix[2][0] == 3.0)
		#expect(matrix[2][1] == 6.0)
		#expect(matrix[2][2] == 9.0)
	}
	
/// Attempt to encode and decode the matrix as JSON.
///
/// All four values in the matrix should be encoded and decoded correctly.
///
	@Test("Serialization")
	func serialization() async throws {
		let matrix = Matrix3x3(rows:
			Vector3(1.0, 2.0, 3.0),
			Vector3(4.0, 5.0, 6.0),
			Vector3(7.0, 8.0, 9.0)
		)
		
		let encoded = try JSONEncoder().encode(matrix)
		let decoded = try JSONDecoder().decode(Matrix3x3<Double>.self, from: encoded)
		
		for x in 0..<3 {
			for y in 0..<3 {
				#expect(matrix[x][y] == decoded[x][y])
			}
		}
	}
	
/// Test if two matrices are equatable.
///
	@Test("Equatable")
	func equatable() async throws {
		let one = Matrix3x3(rows:
			Vector3(1.0, 2.0, 3.0),
			Vector3(4.0, 5.0, 6.0),
			Vector3(7.0, 8.0, 9.0)
		)
		
		let two = Matrix3x3(rows:
			Vector3(1.0 + .ulpOfOne, 2.0 - .ulpOfOne, 3.0 + .ulpOfOne),
			Vector3(4.0 - .ulpOfOne, 5.0 + .ulpOfOne, 6.0 - .ulpOfOne),
			Vector3(7.0 + .ulpOfOne, 8.0 - .ulpOfOne, 9.0 + .ulpOfOne)
		)
		
		#expect(one == one)
		#expect(one != two)
	}
}

extension Matrix3x3Tests {
	@Suite("Identity")
	struct Identity {
	/// Test the `identity` static property to make sure it returns an
	/// identity matrix.
	///
	/// Output:
	/// ```swift
	/// | 1  0  0 |
	/// | 0  1  0 |
	/// | 0  0  1 |
	/// ```
	///
		@Test("identity")
		func identity() async throws {
			let identity = Matrix3x3<Double>.identity
			for column in 0..<3 {
				for row in 0..<3 {
					#expect(identity[column, row] == (column == row ? 1 : 0))
				}
			}
		}

	/// Test the `isIdentity` function to see if it correctly identifies
	/// matrices that are identity.
	///
	/// Input:
	/// ```swift
	/// | 0  0  0 |
	/// | 0  0  0 |
	/// | 0  0  0 |
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
			#expect(Matrix3x3<Double>().isIdentity == false)
		}
		
	/// Test the `isIdentity` function to see if it correctly identifies
	/// matrices that are identity.
	///
	/// Input:
	/// ```swift
	/// | 1  0  0 |
	/// | 0  1  0 |
	/// | 0  0  1 |
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
			var matrix = Matrix3x3<Double>()
			for column in 0..<3 {
				for row in 0..<3 {
					matrix[column, row] = column == row ? 1 : 0
				}
			}
			#expect(matrix.isIdentity == true)
		}
	
	/// Test the `isIdentity` function to see if it correctly identifies
	/// matrices that are identity.
	///
	/// Input:
	/// ```swift
	/// | 1+ε   0    0  |
	/// |  0   1-ε   0  |
	/// |  0    0   1-ε |
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
			var matrix = Matrix3x3<Double>.identity
			for index in 0..<3 {
				matrix[index, index] += ((index % 2) == 0) ? Double.ulpOfOne : -Double.ulpOfOne
			}
			#expect(matrix.isIdentity == false)
		}
		
	/// Test the `toIdentity` function to see if it correctly sets the
	/// matrix to identity.
	///
	/// Input:
	/// ```swift
	/// | 10  20  30 |
	/// | 40  50  60 |
	/// | 70  80  90 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// | 1  0  0 |
	/// | 0  1  0 |
	/// | 0  0  1 |
	/// ```
	///
		@Test("toIdentity")
		func toIdentity() async throws {
			var matrix = Matrix3x3(rows:
				Vector3(10.0, 20.0, 30.0),
				Vector3(40.0, 50.0, 60.0),
				Vector3(70.0, 80.0, 90.0)
			)
			
			for column in 0..<3 {
				for row in 0..<3 {
					#expect(matrix[column, row] != (column == row ? 1 : 0))
				}
			}
			
			matrix.toIdentity()
			
			for column in 0..<3 {
				for row in 0..<3 {
					#expect(matrix[column, row] == (column == row ? 1 : 0))
				}
			}
		}
	}
}

extension Matrix3x3Tests {
	@Suite("Invertible")
	struct Invertible {
	/// Attempt to invert a matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  2  3 |
	/// | 0  1  4 |
	/// | 5  6  0 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// | -24.0   18.0   5.0 |
	/// |  20.0  -18.0  -4.0 |
	/// | -5.0    4.0    1.0 |
	/// ```
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double3x3` type.
	///
		@Test("inverse #1")
		func inverse_1() async throws {
			let matrix = Matrix3x3(columns:
				Vector3(1.0, 0.0, 5.0),
				Vector3(2.0, 1.0, 6.0),
				Vector3(3.0, 4.0, 0.0)
			)
			
			let matrixInverse = matrix.inverse
			
			#expect(matrixInverse != nil)
			#expect(matrixInverse?[0, 0].isApproximatelyEqual(to: -24.0) ?? false)
			#expect(matrixInverse?[0, 1].isApproximatelyEqual(to: 20.0) ?? false)
			#expect(matrixInverse?[0, 2].isApproximatelyEqual(to: -5.0) ?? false)
			#expect(matrixInverse?[1, 0].isApproximatelyEqual(to: 18.0) ?? false)
			#expect(matrixInverse?[1, 1].isApproximatelyEqual(to: -15.0) ?? false)
			#expect(matrixInverse?[1, 2].isApproximatelyEqual(to: 4.0) ?? false)
			#expect(matrixInverse?[2, 0].isApproximatelyEqual(to: 5.0) ?? false)
			#expect(matrixInverse?[2, 1].isApproximatelyEqual(to: -4.0) ?? false)
			#expect(matrixInverse?[2, 2].isApproximatelyEqual(to: 1.0) ?? false)
			
		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let matrixSIMD = simd_double3x3(
				SIMD3<Double>(1.0, 0.0, 5.0),
				SIMD3<Double>(2.0, 1.0, 6.0),
				SIMD3<Double>(3.0, 4.0, 0.0)
			)
			let matrixSIMDInverse = matrixSIMD.inverse
			
			for x in 0..<3 {
				for y in 0..<3 {
					#expect(matrixSIMDInverse[x, y] == matrixInverse?[x, y])
				}
			}
		#endif
		}
	
	/// Attempt to invert a matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  2  3 |
	/// | 2  4  6 |
	/// | 3  6  9 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// nil  // This matrix cannot be inverted
	/// ```
	///
		@Test("inverse #2")
		func inverse_2() async throws {
			let matrix = Matrix3x3(columns:
				Vector3(1.0, 2.0, 3.0),
				Vector3(2.0, 4.0, 6.0),
				Vector3(3.0, 6.0, 9.0)
			)
			
			#expect(matrix.inverse == nil)
		}
	
	/// Attempt to invert a matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  2  3 |
	/// | 0  1  4 |
	/// | 5  6  0 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// true
	/// ```
	/// ```swift
	/// | -24.0   18.0   5.0 |
	/// |  20.0  -18.0  -4.0 |
	/// | -5.0    4.0    1.0 |
	/// ```
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double3x3` type.
	///
		@Test("invert #1")
		func invert_1() async throws {
			var matrix = Matrix3x3(columns:
				Vector3(1.0, 0.0, 5.0),
				Vector3(2.0, 1.0, 6.0),
				Vector3(3.0, 4.0, 0.0)
			)
			
			#expect(matrix.invert() == true)
			
			#expect(matrix[0, 0].isApproximatelyEqual(to: -24.0))
			#expect(matrix[0, 1].isApproximatelyEqual(to: 20.0))
			#expect(matrix[0, 2].isApproximatelyEqual(to: -5.0))
			#expect(matrix[1, 0].isApproximatelyEqual(to: 18.0))
			#expect(matrix[1, 1].isApproximatelyEqual(to: -15.0))
			#expect(matrix[1, 2].isApproximatelyEqual(to: 4.0))
			#expect(matrix[2, 0].isApproximatelyEqual(to: 5.0))
			#expect(matrix[2, 1].isApproximatelyEqual(to: -4.0))
			#expect(matrix[2, 2].isApproximatelyEqual(to: 1.0))
			
		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			var matrixSIMD = simd_double3x3(
				SIMD3<Double>(1.0, 0.0, 5.0),
				SIMD3<Double>(2.0, 1.0, 6.0),
				SIMD3<Double>(3.0, 4.0, 0.0)
			)
			matrixSIMD = matrixSIMD.inverse
			
			for x in 0..<3 {
				for y in 0..<3 {
					#expect(matrixSIMD[x, y] == matrix[x, y])
				}
			}
		#endif
		}
		
	/// Attempt to invert a matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  2  3 |
	/// | 2  4  6 |
	/// | 3  6  9 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// false
	/// ```
	/// ```swift
	/// | 1  2  3 |
	/// | 2  4  6 |
	/// | 3  6  9 |
	/// ```
	///
		@Test("invert #2")
		func invert_2() async throws {
			var matrix = Matrix3x3(columns:
				Vector3(1.0, 2.0, 3.0),
				Vector3(2.0, 4.0, 6.0),
				Vector3(3.0, 6.0, 9.0)
			)
			
			#expect(matrix.invert() == false)
			
			#expect(matrix[0, 0].isApproximatelyEqual(to: 1.0))
			#expect(matrix[0, 1].isApproximatelyEqual(to: 2.0))
			#expect(matrix[0, 2].isApproximatelyEqual(to: 3.0))
			#expect(matrix[1, 0].isApproximatelyEqual(to: 2.0))
			#expect(matrix[1, 1].isApproximatelyEqual(to: 4.0))
			#expect(matrix[1, 2].isApproximatelyEqual(to: 6.0))
			#expect(matrix[2, 0].isApproximatelyEqual(to: 3.0))
			#expect(matrix[2, 1].isApproximatelyEqual(to: 6.0))
			#expect(matrix[2, 2].isApproximatelyEqual(to: 9.0))
		}
	}
}

extension Matrix3x3Tests {
	@Suite("MatrixLinearTransform")
	struct MatrixLinearTransform {
	/// Get the scale stored in an empty transform matrix.
	///
	/// As the matrix is empty, the scale should be zero.
	///
	/// Input:
	/// ```swift
	/// | 0  0  0 |
	/// | 0  0  0 |
	/// | 0  0  0 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// [0, 0, 0]
	/// ```
	///
		@Test("scale #1")
		func scale_1() async throws {
			#expect(Matrix3x3<Double>().scale == .zero)
		}
		
	/// Get the scale stored in an identity transform matrix.
	///
	/// As it is identity, the scale should be 1.0.
	///
	/// Input:
	/// ```swift
	/// | 1  0  0 |
	/// | 0  1  0 |
	/// | 0  0  1 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// [1, 1, 1]
	/// ```
	///
		@Test("scale #2")
		func scale_2() async throws {
			#expect(Matrix3x3<Double>.identity.scale == Vector3<Double>(repeating: 1.0))
		}
		
	/// Get the scale stored in a transform matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  2  3 |
	/// | 4  5  6 |
	/// | 7  8  9 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// [8.124..., 9.644..., 11.225...]
	/// ```
	///
		@Test("scale #3")
		func scale_3() async throws {
			let matrix = Matrix3x3(columns:
				Vector3(1.0, 4.0, 7.0),
				Vector3(2.0, 5.0, 8.0),
				Vector3(3.0, 6.0, 9.0)
			)
			
			let scale = matrix.scale
			
			#expect(scale[0].isApproximatelyEqual(to: 8.12403840463596))
			#expect(scale[1].isApproximatelyEqual(to: 9.643650760992955))
			#expect(scale[2].isApproximatelyEqual(to: 11.224972160321824))
		}
		
	/// Get the scale stored in a transform matrix.
	///
	/// Input:
	/// ```swift
	/// |  1  -2   3 |
	/// |  4  -5   6 |
	/// |  7  -8   9 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// [8.124..., 9.644..., 11.225...]
	/// ```
	///
		@Test("scale #4")
		func scale_4() async throws {
			let matrix = Matrix3x3(columns:
				Vector3( 1.0,  4.0,  7.0),
				Vector3(-2.0, -5.0, -8.0),
				Vector3( 3.0,  6.0,  9.0)
			)
			
			let scale = matrix.scale
			
			#expect(scale[0].isApproximatelyEqual(to: 8.12403840463596))
			#expect(scale[1].isApproximatelyEqual(to: 9.643650760992955))
			#expect(scale[2].isApproximatelyEqual(to: 11.224972160321824))
		}
		
	/// Set the scale stored in a transform matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  2  3 |
	/// | 4  5  6 |
	/// | 7  8  9 |
	///
	/// [2, 2, 2]
	/// ```
	///
	/// Output:
	/// ```swift
	/// |  2   4   6 |
	/// |  8  10  12 |
	/// | 14  16  18 |
	/// ```
	///
		@Test("scale #5")
		func scale_5() async throws {
			var matrix = Matrix3x3(columns:
				Vector3(1.0, 4.0, 7.0),
				Vector3(2.0, 5.0, 8.0),
				Vector3(3.0, 6.0, 9.0)
			)
			
			matrix.scale = Vector3(2.0, 2.0, 2.0)
			
			#expect(matrix[0, 0].isApproximatelyEqual(to: 0.24618298195866545))
			#expect(matrix[0, 1].isApproximatelyEqual(to: 0.9847319278346618))
			#expect(matrix[0, 2].isApproximatelyEqual(to: 1.7232808737106582))
			#expect(matrix[1, 0].isApproximatelyEqual(to: 0.4147806778921701))
			#expect(matrix[1, 1].isApproximatelyEqual(to: 1.0369516947304254))
			#expect(matrix[1, 2].isApproximatelyEqual(to: 1.6591227115686804))
			#expect(matrix[2, 0].isApproximatelyEqual(to: 0.5345224838248488))
			#expect(matrix[2, 1].isApproximatelyEqual(to: 1.0690449676496976))
			#expect(matrix[2, 2].isApproximatelyEqual(to: 1.6035674514745464))
		}
		
	/// Set the scale stored in a transform matrix.
	///
	/// Input:
	/// ```swift
	/// |  1  -2   3 |
	/// |  4  -5   6 |
	/// |  7  -8   9 |
	///
	/// [-5, 25, 0]
	/// ```
	///
	/// Output:
	/// ```swift
	/// |  -5   -50  0 |
	/// | -20  -125  0 |
	/// | -35  -200  0 |
	/// ```
	///
		@Test("scale #6")
		func scale_6() async throws {
			var matrix = Matrix3x3(columns:
				Vector3( 1.0,  4.0,  7.0),
				Vector3(-2.0, -5.0, -8.0),
				Vector3( 3.0,  6.0,  9.0)
			)
			
			matrix.scale = Vector3(-5.0, 25.0, 0.0)
			
			#expect(matrix[0, 0].isApproximatelyEqual(to: -0.6154574548966636))
			#expect(matrix[0, 1].isApproximatelyEqual(to: -2.4618298195866544))
			#expect(matrix[0, 2].isApproximatelyEqual(to: -4.308202184276645))
			#expect(matrix[1, 0].isApproximatelyEqual(to: -5.184758473652126))
			#expect(matrix[1, 1].isApproximatelyEqual(to: -12.961896184130318))
			#expect(matrix[1, 2].isApproximatelyEqual(to: -20.739033894608504))
			#expect(matrix[2, 0].isApproximatelyEqual(to: 0.0))
			#expect(matrix[2, 1].isApproximatelyEqual(to: 0.0))
			#expect(matrix[2, 2].isApproximatelyEqual(to: 0.0))
		}
		
	/// Initialize a matrix from rotational angles, using an XYZ rotation
	/// order.
	///
	/// Input:
	/// ```swift
	/// [18°, 720°, -90°]
	/// ```
	///
	/// Output:
	/// ```swift
	/// | -0.000...   1.000...   0.000... |
	/// | -0.951...  -0.000...  -0.309... |
	/// | -0.309...  -0.000...   0.951... |
	/// ```
	///
		@Test("Rotation Initializer (XYZ)")
		func withRotationInitializer_XYZ() async throws {
			let rotation: Rotation<SIMD3<Double>> = [
				.degrees(18.0),
				.degrees(720.0),
				.degrees(-90.0)
			]
			
			let matrix = Matrix3x3(withRotation: rotation, order: .XYZ)

			#expect(matrix[0, 0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[0, 1].isApproximatelyEqual(to: -0.9510565162951535))
			#expect(matrix[0, 2].isApproximatelyEqual(to: -0.3090169943749474))
			#expect(matrix[1, 0].isApproximatelyEqual(to: 1.0))
			#expect(matrix[1, 1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[1, 2].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[2, 0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[2, 1].isApproximatelyEqual(to: -0.3090169943749474))
			#expect(matrix[2, 2].isApproximatelyEqual(to: 0.9510565162951535))
		}
		
	/// Initialize a matrix from rotational angles, using an XZY rotation
	/// order.
	///
	/// Input:
	/// ```swift
	/// [18°, 720°, -90°]
	/// ```
	///
	/// Output:
	/// ```swift
	/// | -0.000...   1.000...   0.000... |
	/// | -0.951...  -0.000...  -0.309... |
	/// | -0.309...  -0.000...   0.951... |
	/// ```
	///
		@Test("Rotation Initializer (XZY)")
		func withRotationInitializer_XZY() async throws {
			let rotation: Rotation<SIMD3<Double>> = [
				.degrees(18.0),
				.degrees(720.0),
				.degrees(-90.0)
			]
			
			let matrix = Matrix3x3(withRotation: rotation, order: .XZY)

			#expect(matrix[0, 0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[0, 1].isApproximatelyEqual(to: -0.9510565162951535))
			#expect(matrix[0, 2].isApproximatelyEqual(to: -0.3090169943749474))
			#expect(matrix[1, 0].isApproximatelyEqual(to: 1.0))
			#expect(matrix[1, 1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[1, 2].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[2, 0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[2, 1].isApproximatelyEqual(to: -0.3090169943749474))
			#expect(matrix[2, 2].isApproximatelyEqual(to: 0.9510565162951535))
		}
		
	/// Initialize a matrix from rotational angles, using an YXZ rotation
	/// order.
	///
	/// Input:
	/// ```swift
	/// [18°, 720°, -90°]
	/// ```
	///
	/// Output:
	/// ```swift
	/// | -0.000...   1.000...   0.000... |
	/// | -0.951...  -0.000...  -0.309... |
	/// | -0.309...  -0.000...   0.951... |
	/// ```
	///
		@Test("Rotation Initializer (YXZ)")
		func withRotationInitializer_YXZ() async throws {
			let rotation: Rotation<SIMD3<Double>> = [
				.degrees(18.0),
				.degrees(720.0),
				.degrees(-90.0)
			]
			
			let matrix = Matrix3x3(withRotation: rotation, order: .YXZ)

			#expect(matrix[0, 0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[0, 1].isApproximatelyEqual(to: -0.9510565162951535))
			#expect(matrix[0, 2].isApproximatelyEqual(to: -0.3090169943749474))
			#expect(matrix[1, 0].isApproximatelyEqual(to: 1.0))
			#expect(matrix[1, 1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[1, 2].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[2, 0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[2, 1].isApproximatelyEqual(to: -0.3090169943749474))
			#expect(matrix[2, 2].isApproximatelyEqual(to: 0.9510565162951535))
		}
		

	/// Initialize a matrix from rotational angles, using an YZX rotation
	/// order.
	///
	/// Input:
	/// ```swift
	/// [18°, 720°, -90°]
	/// ```
	///
	/// Output:
	/// ```swift
	/// | -0.000...   0.951...  -0.309... |
	/// | -1.000...  -0.000...   0.000... |
	/// |  0.000...   0.309...   0.951... |
	/// ```
	///
		@Test("Rotation Initializer (YZX)")
		func withRotationInitializer_YZX() async throws {
			let rotation: Rotation<SIMD3<Double>> = [
				.degrees(18.0),
				.degrees(720.0),
				.degrees(-90.0)
			]
			
			let matrix = Matrix3x3(withRotation: rotation, order: .YZX)

			#expect(matrix[0, 0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[0, 1].isApproximatelyEqual(to: -1.0))
			#expect(matrix[0, 2].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[1, 0].isApproximatelyEqual(to: 0.9510565162951535))
			#expect(matrix[1, 1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[1, 2].isApproximatelyEqual(to: 0.3090169943749474))
			#expect(matrix[2, 0].isApproximatelyEqual(to: -0.3090169943749474))
			#expect(matrix[2, 1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[2, 2].isApproximatelyEqual(to: 0.9510565162951535))
		}
		
	/// Initialize a matrix from rotational angles, using an ZXY rotation
	/// order.
	///
	/// Input:
	/// ```swift
	/// [18°, 720°, -90°]
	/// ```
	///
	/// Output:
	/// ```swift
	/// | -0.000...   0.951...  -0.309... |
	/// | -1.000...  -0.000...   0.000... |
	/// |  0.000...   0.309...   0.951... |
	/// ```
	///
		@Test("Rotation Initializer (ZXY)")
		func withRotationInitializer_ZXY() async throws {
			let rotation: Rotation<SIMD3<Double>> = [
				.degrees(18.0),
				.degrees(720.0),
				.degrees(-90.0)
			]
			
			let matrix = Matrix3x3(withRotation: rotation, order: .ZXY)

			#expect(matrix[0, 0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[0, 1].isApproximatelyEqual(to: -1.0))
			#expect(matrix[0, 2].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[1, 0].isApproximatelyEqual(to: 0.9510565162951535))
			#expect(matrix[1, 1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[1, 2].isApproximatelyEqual(to: 0.3090169943749474))
			#expect(matrix[2, 0].isApproximatelyEqual(to: -0.3090169943749474))
			#expect(matrix[2, 1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[2, 2].isApproximatelyEqual(to: 0.9510565162951535))
		}
		
	/// Initialize a matrix from rotational angles, using an ZXY rotation
	/// order.
	///
	/// Input:
	/// ```swift
	/// [18°, 720°, -90°]
	/// ```
	///
	/// Output:
	/// ```swift
	/// | -0.000...   0.951...  -0.309... |
	/// | -1.000...  -0.000...   0.000... |
	/// |  0.000...   0.309...   0.951... |
	/// ```
	///
		@Test("Rotation Initializer (ZYX)")
		func withRotationInitializer_ZYX() async throws {
			let rotation: Rotation<SIMD3<Double>> = [
				.degrees(18.0),
				.degrees(720.0),
				.degrees(-90.0)
			]
			
			let matrix = Matrix3x3(withRotation: rotation, order: .ZYX)

			#expect(matrix[0, 0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[0, 1].isApproximatelyEqual(to: -1.0))
			#expect(matrix[0, 2].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[1, 0].isApproximatelyEqual(to: 0.9510565162951535))
			#expect(matrix[1, 1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[1, 2].isApproximatelyEqual(to: 0.3090169943749474))
			#expect(matrix[2, 0].isApproximatelyEqual(to: -0.3090169943749474))
			#expect(matrix[2, 1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[2, 2].isApproximatelyEqual(to: 0.9510565162951535))
		}

	///Create a transform matrix from a uniform scale.
	///
	/// Input:
	/// ```swift
	/// 0
	/// ```
	///
	/// Output:
	/// ```swift
	/// | 0  0  0 |
	/// | 0  0  0 |
	/// | 0  0  0 |
	/// ```
	///
		@Test("Uniform Scale Initializer #1")
		func withUniformScaleInitializer_1() async throws {
			let matrix = Matrix3x3(withScale: 0.0)
			for x in 0..<3 {
				for y in 0..<3 {
					#expect(matrix[x, y].isApproximatelyEqual(to: 0.0))
				}
			}
		}
		
	///Create a transform matrix from a uniform scale.
	///
	/// Input:
	/// ```swift
	/// 1
	/// ```
	///
	/// Output:
	/// ```swift
	/// | 1  0  0 |
	/// | 0  1  0 |
	/// | 0  0  1 |
	/// ```
	///
		@Test("Uniform Scale Initializer #2")
		func withUniformScaleInitializer_2() async throws {
			let matrix = Matrix3x3(withScale: 1.0)
			for x in 0..<3 {
				for y in 0..<3 {
					if x == y {
						#expect(matrix[x, y].isApproximatelyEqual(to: 1.0))
					}
					else {
						#expect(matrix[x, y].isApproximatelyEqual(to: 0.0))
					}
				}
			}
		}
		
	///Create a transform matrix from a uniform scale.
	///
	/// Input:
	/// ```swift
	/// -3.25
	/// ```
	///
	/// Output:
	/// ```swift
	/// | -3.25      0      0 |
	/// |     0  -3.25      0 |
	/// |     0      0  -3.25 |
	/// ```
	///
		@Test("Uniform Scale Initializer #3")
		func withUniformScaleInitializer_3() async throws {
			let matrix = Matrix3x3(withScale: -3.25)
			for x in 0..<3 {
				for y in 0..<3 {
					if x == y {
						#expect(matrix[x, y].isApproximatelyEqual(to: -3.25))
					}
					else {
						#expect(matrix[x, y].isApproximatelyEqual(to: 0.0))
					}
				}
			}
		}
		
	///Create a transform matrix from a vector scale.
	///
	/// Input:
	/// ```swift
	/// [1, 2, 3]
	/// ```
	///
	/// Output:
	/// ```swift
	/// | 1  0  0 |
	/// | 0  2  0 |
	/// | 0  0  3 |
	/// ```
	///
		@Test("Scale Initializer #1")
		func withScaleInitializer_1() async throws {
			let matrix = Matrix3x3(withScale: Vector3(1, 2, 3))
			for x in 0..<3 {
				for y in 0..<3 {
					if x == y {
						if x == 0 {
							#expect(matrix[x, y].isApproximatelyEqual(to: 1.0))
						}
						else if x == 1 {
							#expect(matrix[x, y].isApproximatelyEqual(to: 2.0))
						}
						else {
							#expect(matrix[x, y].isApproximatelyEqual(to: 3.0))
						}
					}
					else {
						#expect(matrix[x, y].isApproximatelyEqual(to: 0.0))
					}
				}
			}
		}
		
	///Create a transform matrix from a vector scale.
	///
	/// Input:
	/// ```swift
	/// [-4, 5.67, -8.9]
	/// ```
	///
	/// Output:
	/// ```swift
	/// | -4     0     0 |
	/// |  0  5.67     0 |
	/// |  0     0  -8.9 |
	/// ```
	///
		@Test("Scale Initializer #2")
		func withScaleInitializer_2() async throws {
			let matrix = Matrix3x3(withScale: Vector3(-4, 5.67, -8.9))
			for x in 0..<3 {
				for y in 0..<3 {
					if x == y {
						if x == 0 {
							#expect(matrix[x, y].isApproximatelyEqual(to: -4))
						}
						else if x == 1 {
							#expect(matrix[x, y].isApproximatelyEqual(to: 5.67))
						}
						else {
							#expect(matrix[x, y].isApproximatelyEqual(to: -8.9))
						}
					}
					else {
						#expect(matrix[x, y].isApproximatelyEqual(to: 0.0))
					}
				}
			}
		}
		
		func randomAngles(in angles: [Double]) -> Rotation<SIMD3<Double>> {
			var set = Set<[Double].Index>()
			while set.count < 3 {
				set.insert(angles.indices.randomElement()!)
			}
			let indices: [[Double].Index] = set.map { $0 }
			return Rotation<SIMD3>([
				.degrees(angles[indices[0]]),
				.degrees(angles[indices[1]]),
				.degrees(angles[indices[2]])
			])
		}
		
	/// Test generator!!!
	///
		@Test("Generator")
		func generateSomeTests() async throws {
			let randomAngles: [Double] = [
				45.0,
				19.0,
				27.0,
				345.0,
				192.0,
				-60.0,
				-19.0,
				-27.0,
				0.0,
				47.0,
				3.0
			]
		
			let orders: [RotationOrder] = [
				.XYZ,
				.XZY,
				.YXZ,
				.YZX,
				.ZXY,
				.ZYX
			]

			for order in orders {
				let rotation = Rotation.degrees(SIMD3<Double>(192.0, 27.0, -60.0))
				let matrix = Matrix3x3(withRotation: rotation, order: order)
				
				let input = rotation.degrees
				let output = matrix.toRotation(order: order).degrees
				
				let string = """
				/// Converts a matrix containing both rotation and scale into the
				/// individual rotation angles.
				///
				/// Input:
				/// ```swift
				/// \(matrix.description)
				/// ```
				///
				/// Output:
				/// ```swift
				/// [\(rotation[0].degrees)°, \(rotation[1].degrees)°, \(rotation[2].degrees)°]
				/// ```
				///
				@Test("toRotation (\(order.description)")
				func toRotation_\(order.description)() async throws {
					let matrix = Matrix3x3(columns:
						Vector3(\(matrix[0,0]), \(matrix[0,1]), \(matrix[0,2])),
						Vector3(\(matrix[1,0]), \(matrix[1,1]), \(matrix[1,2])),
						Vector3(\(matrix[2,0]), \(matrix[2,1]), \(matrix[2,2]))
					)
					
					let rotation = matrix.toRotation(order: .\(order.description)).degrees
					
					#expect(rotation[0].isApproximatelyEqual(to: \(rotation[0].degrees)))
					#expect(rotation[1].isApproximatelyEqual(to: \(rotation[1].degrees)))
					#expect(rotation[2].isApproximatelyEqual(to: \(rotation[2].degrees)))
				}
				"""
				
				print(string)
				print("\n")
			}
		}
		
		@Test("fromRotation")
		func fromRotation() async throws {
			let rotation: Units.Rotation<SIMD3<Double>> = [
				.degrees(-192),
				.degrees(187),
				.degrees(-36)
			]
			
			print(rotation.normalized.degrees)
			
			for order in RotationOrder.allCases {
				print(order.description)
				print("--------------------")
				let matrix: Matrix3x3<Double> = Matrix3x3(withRotation: rotation, order: order)
				print(matrix.toRotation(order: order).normalized.degrees)
				print("")
			}
		}

	/// Round-trip: build a matrix from XYZ Euler angles and recover them with
	/// toRotation. Angles are chosen well away from gimbal lock (|ry| << 90°).
	///
		@Test("fromRotation (XYZ)")
		func fromRotation_XYZ() async throws {
			let input: Rotation<SIMD3<Double>> = [
				.degrees(30.0),
				.degrees(25.0),
				.degrees(-45.0)
			]
			let matrix = Matrix3x3<Double>(withRotation: input, order: .XYZ)
			let output = matrix.toRotation(order: .XYZ)
			#expect(output[0].degrees.isApproximatelyEqual(to: input[0].degrees))
			#expect(output[1].degrees.isApproximatelyEqual(to: input[1].degrees))
			#expect(output[2].degrees.isApproximatelyEqual(to: input[2].degrees))
		}

	/// Round-trip: build a matrix from XZY Euler angles and recover them with
	/// toRotation. Angles are chosen well away from gimbal lock (|rz| << 90°).
	///
		@Test("fromRotation (XZY)")
		func fromRotation_XZY() async throws {
			let input: Rotation<SIMD3<Double>> = [
				.degrees(-20.0),
				.degrees(50.0),
				.degrees(35.0)
			]
			let matrix = Matrix3x3<Double>(withRotation: input, order: .XZY)
			let output = matrix.toRotation(order: .XZY)
			#expect(output[0].degrees.isApproximatelyEqual(to: input[0].degrees))
			#expect(output[1].degrees.isApproximatelyEqual(to: input[1].degrees))
			#expect(output[2].degrees.isApproximatelyEqual(to: input[2].degrees))
		}

	/// Round-trip: build a matrix from YXZ Euler angles and recover them with
	/// toRotation. Angles are chosen well away from gimbal lock (|rx| << 90°).
	///
		@Test("fromRotation (YXZ)")
		func fromRotation_YXZ() async throws {
			let input: Rotation<SIMD3<Double>> = [
				.degrees(40.0),
				.degrees(-30.0),
				.degrees(20.0)
			]
			let matrix = Matrix3x3<Double>(withRotation: input, order: .YXZ)
			let output = matrix.toRotation(order: .YXZ)
			#expect(output[0].degrees.isApproximatelyEqual(to: input[0].degrees))
			#expect(output[1].degrees.isApproximatelyEqual(to: input[1].degrees))
			#expect(output[2].degrees.isApproximatelyEqual(to: input[2].degrees))
		}

	/// Round-trip: build a matrix from YZX Euler angles and recover them with
	/// toRotation. Angles are chosen well away from gimbal lock (|rz| << 90°).
	///
		@Test("fromRotation (YZX)")
		func fromRotation_YZX() async throws {
			let input: Rotation<SIMD3<Double>> = [
				.degrees(15.0),
				.degrees(45.0),
				.degrees(-25.0)
			]
			let matrix = Matrix3x3<Double>(withRotation: input, order: .YZX)
			let output = matrix.toRotation(order: .YZX)
			#expect(output[0].degrees.isApproximatelyEqual(to: input[0].degrees))
			#expect(output[1].degrees.isApproximatelyEqual(to: input[1].degrees))
			#expect(output[2].degrees.isApproximatelyEqual(to: input[2].degrees))
		}

	/// Round-trip: build a matrix from ZXY Euler angles and recover them with
	/// toRotation. Angles are chosen well away from gimbal lock (|rx| << 90°).
	///
		@Test("fromRotation (ZXY)")
		func fromRotation_ZXY() async throws {
			let input: Rotation<SIMD3<Double>> = [
				.degrees(-35.0),
				.degrees(20.0),
				.degrees(55.0)
			]
			let matrix = Matrix3x3<Double>(withRotation: input, order: .ZXY)
			let output = matrix.toRotation(order: .ZXY)
			#expect(output[0].degrees.isApproximatelyEqual(to: input[0].degrees))
			#expect(output[1].degrees.isApproximatelyEqual(to: input[1].degrees))
			#expect(output[2].degrees.isApproximatelyEqual(to: input[2].degrees))
		}

	/// Round-trip: build a matrix from ZYX Euler angles and recover them with
	/// toRotation. Angles are chosen well away from gimbal lock (|ry| << 90°).
	///
		@Test("fromRotation (ZYX)")
		func fromRotation_ZYX() async throws {
			let input: Rotation<SIMD3<Double>> = [
				.degrees(25.0),
				.degrees(-15.0),
				.degrees(60.0)
			]
			let matrix = Matrix3x3<Double>(withRotation: input, order: .ZYX)
			let output = matrix.toRotation(order: .ZYX)
			#expect(output[0].degrees.isApproximatelyEqual(to: input[0].degrees))
			#expect(output[1].degrees.isApproximatelyEqual(to: input[1].degrees))
			#expect(output[2].degrees.isApproximatelyEqual(to: input[2].degrees))
		}
	}
}

extension Matrix3x3Tests {
	@Suite("MatrixMath")
	struct MatrixMath {
	/// Tests adding two matrices together.
	///
	/// Input:
	/// ```swift
	/// | 1  4  7 | + | 10  40  70 |
	/// | 2  5  8 |   | 20  50  80 |
	/// | 3  6  9 |   | 30  60  90 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// | 11  44  77 |
	/// | 22  55  88 |
	/// | 33  66  99 |
	/// ```
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double3x3` type.
	///
		@Test("Addition")
		func addition() async throws {
			let lhs = Matrix3x3(columns:
				Vector3(1.0, 2.0, 3.0),
				Vector3(4.0, 5.0, 6.0),
				Vector3(7.0, 8.0, 9.0)
			)

			let rhs = Matrix3x3(columns:
				Vector3(10.0, 20.0, 30.0),
				Vector3(40.0, 50.0, 60.0),
				Vector3(70.0, 80.0, 90.0)
			)

			let result = lhs + rhs

			#expect(result[0, 0] == 11.0)
			#expect(result[0, 1] == 22.0)
			#expect(result[0, 2] == 33.0)
			#expect(result[1, 0] == 44.0)
			#expect(result[1, 1] == 55.0)
			#expect(result[1, 2] == 66.0)
			#expect(result[2, 0] == 77.0)
			#expect(result[2, 1] == 88.0)
			#expect(result[2, 2] == 99.0)

		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let lhsSIMD = simd_double3x3(
				SIMD3<Double>(1.0, 2.0, 3.0),
				SIMD3<Double>(4.0, 5.0, 6.0),
				SIMD3<Double>(7.0, 8.0, 9.0)
			)

			let rhsSIMD = simd_double3x3(
				SIMD3<Double>(10.0, 20.0, 30.0),
				SIMD3<Double>(40.0, 50.0, 60.0),
				SIMD3<Double>(70.0, 80.0, 90.0)
			)

			let resultSIMD = lhsSIMD + rhsSIMD

			for x in 0..<3 {
				for y in 0..<3 {
					#expect(result[x, y] == resultSIMD[x, y])
				}
			}
		#endif
		}

	/// Tests adding two matrices together, mutating the first matrix.
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double3x3` type.
	///
		@Test("Addition Assignment")
		func additionAssignment() async throws {
			var lhs = Matrix3x3(columns:
				Vector3(1.0, 2.0, 3.0),
				Vector3(4.0, 5.0, 6.0),
				Vector3(7.0, 8.0, 9.0)
			)

			let rhs = Matrix3x3(columns:
				Vector3(10.0, 20.0, 30.0),
				Vector3(40.0, 50.0, 60.0),
				Vector3(70.0, 80.0, 90.0)
			)

			lhs += rhs

			#expect(lhs[0, 0] == 11.0)
			#expect(lhs[0, 1] == 22.0)
			#expect(lhs[0, 2] == 33.0)
			#expect(lhs[1, 0] == 44.0)
			#expect(lhs[1, 1] == 55.0)
			#expect(lhs[1, 2] == 66.0)
			#expect(lhs[2, 0] == 77.0)
			#expect(lhs[2, 1] == 88.0)
			#expect(lhs[2, 2] == 99.0)

		#if canImport(simd)
			var lhsSIMD = simd_double3x3(
				SIMD3<Double>(1.0, 2.0, 3.0),
				SIMD3<Double>(4.0, 5.0, 6.0),
				SIMD3<Double>(7.0, 8.0, 9.0)
			)

			let rhsSIMD = simd_double3x3(
				SIMD3<Double>(10.0, 20.0, 30.0),
				SIMD3<Double>(40.0, 50.0, 60.0),
				SIMD3<Double>(70.0, 80.0, 90.0)
			)

			lhsSIMD += rhsSIMD

			for x in 0..<3 {
				for y in 0..<3 {
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
	///   compared against the `simd_double3x3` type.
	///
		@Test("Negation")
		func negation() async throws {
			let rhs = Matrix3x3(columns:
				Vector3(1.0, 2.0, 3.0),
				Vector3(4.0, 5.0, 6.0),
				Vector3(7.0, 8.0, 9.0)
			)

			let result = -rhs

			for x in 0..<3 {
				for y in 0..<3 {
					#expect(result[x, y] == -rhs[x, y])
				}
			}

		#if canImport(simd)
			let rhsSIMD = simd_double3x3(
				SIMD3<Double>(1.0, 2.0, 3.0),
				SIMD3<Double>(4.0, 5.0, 6.0),
				SIMD3<Double>(7.0, 8.0, 9.0)
			)

			let resultSIMD = -rhsSIMD

			for x in 0..<3 {
				for y in 0..<3 {
					#expect(result[x, y] == resultSIMD[x, y])
				}
			}
		#endif
		}

	/// Tests subtracting one matrix from another.
	///
	/// Input:
	/// ```swift
	/// | 10  40  70 | - | 1  4  7 |
	/// | 20  50  80 |   | 2  5  8 |
	/// | 30  60  90 |   | 3  6  9 |
	/// ```
	///
	/// Output:
	/// ```swift
	/// |  9  36  63 |
	/// | 18  45  72 |
	/// | 27  54  81 |
	/// ```
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double3x3` type.
	///
		@Test("Subtraction")
		func subtraction() async throws {
			let lhs = Matrix3x3(columns:
				Vector3(10.0, 20.0, 30.0),
				Vector3(40.0, 50.0, 60.0),
				Vector3(70.0, 80.0, 90.0)
			)

			let rhs = Matrix3x3(columns:
				Vector3(1.0, 2.0, 3.0),
				Vector3(4.0, 5.0, 6.0),
				Vector3(7.0, 8.0, 9.0)
			)

			let result = lhs - rhs

			#expect(result[0, 0] == 9.0)
			#expect(result[0, 1] == 18.0)
			#expect(result[0, 2] == 27.0)
			#expect(result[1, 0] == 36.0)
			#expect(result[1, 1] == 45.0)
			#expect(result[1, 2] == 54.0)
			#expect(result[2, 0] == 63.0)
			#expect(result[2, 1] == 72.0)
			#expect(result[2, 2] == 81.0)

		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let lhsSIMD = simd_double3x3(
				SIMD3<Double>(10.0, 20.0, 30.0),
				SIMD3<Double>(40.0, 50.0, 60.0),
				SIMD3<Double>(70.0, 80.0, 90.0)
			)

			let rhsSIMD = simd_double3x3(
				SIMD3<Double>(1.0, 2.0, 3.0),
				SIMD3<Double>(4.0, 5.0, 6.0),
				SIMD3<Double>(7.0, 8.0, 9.0)
			)

			let resultSIMD = lhsSIMD - rhsSIMD

			for x in 0..<3 {
				for y in 0..<3 {
					#expect(result[x, y] == resultSIMD[x, y])
				}
			}
		#endif
		}

	/// Tests subtracting one matrix from another, mutating the first matrix.
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double3x3` type.
	///
		@Test("Subtraction Assignment")
		func subtractionAssignment() async throws {
			var lhs = Matrix3x3(columns:
				Vector3(10.0, 20.0, 30.0),
				Vector3(40.0, 50.0, 60.0),
				Vector3(70.0, 80.0, 90.0)
			)

			let rhs = Matrix3x3(columns:
				Vector3(1.0, 2.0, 3.0),
				Vector3(4.0, 5.0, 6.0),
				Vector3(7.0, 8.0, 9.0)
			)

			let expected = lhs - rhs
			lhs -= rhs

			for x in 0..<3 {
				for y in 0..<3 {
					#expect(lhs[x, y] == expected[x, y])
				}
			}

		#if canImport(simd)
			var lhsSIMD = simd_double3x3(
				SIMD3<Double>(10.0, 20.0, 30.0),
				SIMD3<Double>(40.0, 50.0, 60.0),
				SIMD3<Double>(70.0, 80.0, 90.0)
			)

			let rhsSIMD = simd_double3x3(
				SIMD3<Double>(1.0, 2.0, 3.0),
				SIMD3<Double>(4.0, 5.0, 6.0),
				SIMD3<Double>(7.0, 8.0, 9.0)
			)

			lhsSIMD -= rhsSIMD

			for x in 0..<3 {
				for y in 0..<3 {
					#expect(lhs[x, y] == lhsSIMD[x, y])
				}
			}
		#endif
		}

	/// Tests multiplying two 3×3 matrices together.
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double3x3` type.
	///
		@Test("Multiplication")
		func multiplication() async throws {
			let lhs = Matrix3x3(columns:
				Vector3(1.0, 2.0, 3.0),
				Vector3(4.0, 5.0, 6.0),
				Vector3(7.0, 8.0, 9.0)
			)

			let rhs = Matrix3x3(columns:
				Vector3(9.0, 8.0, 7.0),
				Vector3(6.0, 5.0, 4.0),
				Vector3(3.0, 2.0, 1.0)
			)

			let result = lhs * rhs

		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let lhsSIMD = simd_double3x3(
				SIMD3<Double>(1.0, 2.0, 3.0),
				SIMD3<Double>(4.0, 5.0, 6.0),
				SIMD3<Double>(7.0, 8.0, 9.0)
			)

			let rhsSIMD = simd_double3x3(
				SIMD3<Double>(9.0, 8.0, 7.0),
				SIMD3<Double>(6.0, 5.0, 4.0),
				SIMD3<Double>(3.0, 2.0, 1.0)
			)

			let resultSIMD = lhsSIMD * rhsSIMD

			for x in 0..<3 {
				for y in 0..<3 {
					#expect(result[x, y].isApproximatelyEqual(to: resultSIMD[x, y]))
				}
			}
		#else
			// Verify M * I = M on platforms without simd.
			let identityProduct = lhs * Matrix3x3<Double>.identity
			for x in 0..<3 {
				for y in 0..<3 {
					#expect(identityProduct[x, y] == lhs[x, y])
				}
			}
			let _ = result
		#endif
		}

	/// Tests multiplying two 3×3 matrices together, mutating the first matrix.
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double3x3` type.
	///
		@Test("Multiplication Assignment")
		func multiplicationAssignment() async throws {
			var lhs = Matrix3x3(columns:
				Vector3(1.0, 2.0, 3.0),
				Vector3(4.0, 5.0, 6.0),
				Vector3(7.0, 8.0, 9.0)
			)

			let rhs = Matrix3x3(columns:
				Vector3(9.0, 8.0, 7.0),
				Vector3(6.0, 5.0, 4.0),
				Vector3(3.0, 2.0, 1.0)
			)

			let expected = lhs * rhs
			lhs *= rhs

			for x in 0..<3 {
				for y in 0..<3 {
					#expect(lhs[x, y] == expected[x, y])
				}
			}

		#if canImport(simd)
			var lhsSIMD = simd_double3x3(
				SIMD3<Double>(1.0, 2.0, 3.0),
				SIMD3<Double>(4.0, 5.0, 6.0),
				SIMD3<Double>(7.0, 8.0, 9.0)
			)

			let rhsSIMD = simd_double3x3(
				SIMD3<Double>(9.0, 8.0, 7.0),
				SIMD3<Double>(6.0, 5.0, 4.0),
				SIMD3<Double>(3.0, 2.0, 1.0)
			)

			lhsSIMD *= rhsSIMD

			for x in 0..<3 {
				for y in 0..<3 {
					#expect(lhs[x, y].isApproximatelyEqual(to: lhsSIMD[x, y]))
				}
			}
		#endif
		}

	/// Tests multiplying a 3×3 matrix by a scalar (both orderings).
	///
	/// Input:
	/// ```swift
	/// | 1  4  7 |
	/// | 2  5  8 |  * 3.0
	/// | 3  6  9 |
	/// ```
	///
	/// Output: every component is multiplied by 3.
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double3x3` type.
	///
		@Test("Scalar Multiplication")
		func scalarMultiplication() async throws {
			let matrix = Matrix3x3(columns:
				Vector3(1.0, 2.0, 3.0),
				Vector3(4.0, 5.0, 6.0),
				Vector3(7.0, 8.0, 9.0)
			)

			let scalar = 3.0

			let result1 = matrix * scalar
			let result2 = scalar * matrix

			for x in 0..<3 {
				for y in 0..<3 {
					#expect(result1[x, y] == result2[x, y])
					#expect(result1[x, y] == matrix[x, y] * scalar)
				}
			}

		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let matrixSIMD = simd_double3x3(
				SIMD3<Double>(1.0, 2.0, 3.0),
				SIMD3<Double>(4.0, 5.0, 6.0),
				SIMD3<Double>(7.0, 8.0, 9.0)
			)

			let resultSIMD1 = matrixSIMD * scalar
			let resultSIMD2 = scalar * matrixSIMD

			for x in 0..<3 {
				for y in 0..<3 {
					#expect(resultSIMD1[x, y] == resultSIMD2[x, y])
					#expect(result1[x, y] == resultSIMD1[x, y])
				}
			}
		#endif
		}

	/// Tests multiplying a 3×3 matrix by a scalar, mutating the matrix.
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double3x3` type.
	///
		@Test("Scalar Multiplication Assignment")
		func scalarMultiplicationAssignment() async throws {
			var lhs = Matrix3x3(columns:
				Vector3(1.0, 2.0, 3.0),
				Vector3(4.0, 5.0, 6.0),
				Vector3(7.0, 8.0, 9.0)
			)

			let rhs = 3.0
			let expected = lhs * rhs
			lhs *= rhs

			for x in 0..<3 {
				for y in 0..<3 {
					#expect(lhs[x, y] == expected[x, y])
				}
			}

		#if canImport(simd)
			var lhsSIMD = simd_double3x3(
				SIMD3<Double>(1.0, 2.0, 3.0),
				SIMD3<Double>(4.0, 5.0, 6.0),
				SIMD3<Double>(7.0, 8.0, 9.0)
			)

			lhsSIMD *= rhs

			for x in 0..<3 {
				for y in 0..<3 {
					#expect(lhs[x, y] == lhsSIMD[x, y])
				}
			}
		#endif
		}
	}
}

extension Matrix3x3Tests {
	@Suite("MatrixSub")
	struct MatrixSub {

	}
}

extension Matrix3x3Tests {
	@Suite("MatrixVectorMath")
	struct MatrixVectorMath {
	/// Tests multiplying a 3×3 matrix by a Vector3.
	///
	/// Input:
	/// ```swift
	/// | 1  4  7 |   | 1 |   | 30 |
	/// | 2  5  8 | × | 2 | = | 36 |
	/// | 3  6  9 |   | 3 |   | 42 |
	/// ```
	///
	/// Calculation (column-major):
	///   result[0] = 1*1 + 4*2 + 7*3 = 1 + 8 + 21 = 30
	///   result[1] = 2*1 + 5*2 + 8*3 = 2 + 10 + 24 = 36
	///   result[2] = 3*1 + 6*2 + 9*3 = 3 + 12 + 27 = 42
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double3x3` type.
	///
		@Test("Vector Multiplication")
		func multiplication() async throws {
			let lhs = Matrix3x3(columns:
				Vector3(1.0, 2.0, 3.0),
				Vector3(4.0, 5.0, 6.0),
				Vector3(7.0, 8.0, 9.0)
			)

			let rhs = Vector3(1.0, 2.0, 3.0)

			let result = lhs * rhs

			#expect(result[0].isApproximatelyEqual(to: 30.0))
			#expect(result[1].isApproximatelyEqual(to: 36.0))
			#expect(result[2].isApproximatelyEqual(to: 42.0))

		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let lhsSIMD = simd_double3x3(
				SIMD3<Double>(1.0, 2.0, 3.0),
				SIMD3<Double>(4.0, 5.0, 6.0),
				SIMD3<Double>(7.0, 8.0, 9.0)
			)

			let rhsSIMD = SIMD3<Double>(1.0, 2.0, 3.0)
			let resultSIMD = lhsSIMD * rhsSIMD

			#expect(result[0] == resultSIMD[0])
			#expect(result[1] == resultSIMD[1])
			#expect(result[2] == resultSIMD[2])
		#endif
		}

	/// Tests multiplying a 3×3 matrix by the unit basis vector [1,0,0].
	///
	/// Multiplying by e0 = [1,0,0] selects column 0 of the matrix.
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double3x3` type.
	///
		@Test("Vector Multiplication #2")
		func multiplication2() async throws {
			let lhs = Matrix3x3(columns:
				Vector3(1.0, 2.0, 3.0),
				Vector3(4.0, 5.0, 6.0),
				Vector3(7.0, 8.0, 9.0)
			)

			// M * e0 selects column 0.
			let rhs = Vector3(1.0, 0.0, 0.0)
			let result = lhs * rhs

			#expect(result[0].isApproximatelyEqual(to: 1.0))
			#expect(result[1].isApproximatelyEqual(to: 2.0))
			#expect(result[2].isApproximatelyEqual(to: 3.0))

		#if canImport(simd)
			let lhsSIMD = simd_double3x3(
				SIMD3<Double>(1.0, 2.0, 3.0),
				SIMD3<Double>(4.0, 5.0, 6.0),
				SIMD3<Double>(7.0, 8.0, 9.0)
			)

			let rhsSIMD = SIMD3<Double>(1.0, 0.0, 0.0)
			let resultSIMD = lhsSIMD * rhsSIMD

			for i in 0..<3 {
				#expect(result[i] == resultSIMD[i])
			}
		#endif
		}
	}
}

extension Matrix3x3Tests {
	@Suite("QuaternionConvertible")
	struct QuaternionConvertible {
	/// Initialize a 3×3 matrix from a quaternion representing a 90° rotation
	/// around the Z axis and verify the rotational entries.
	///
	/// A 90° rotation around Z maps X→Y, Y→−X, Z→Z, which means:
	///   col0 = (≈0, ≈1, 0)
	///   col1 = (≈-1, ≈0, 0)
	///   col2 = (0, 0, 1)
	///
		@Test("init(withQuaternion:)")
		func initWithQuaternion() async throws {
			let quaternion = Quaternion<Double>(
				withAxis: Vector3(0.0, 0.0, 1.0),
				angle: .degrees(90.0)
			)

			let matrix = Matrix3x3(withQuaternion: quaternion)

			// Column 0 = transformed X axis = (≈0, ≈1, 0)
			#expect(matrix[0, 0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[0, 1].isApproximatelyEqual(to: 1.0))
			#expect(matrix[0, 2].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			// Column 1 = transformed Y axis = (≈-1, ≈0, 0)
			#expect(matrix[1, 0].isApproximatelyEqual(to: -1.0))
			#expect(matrix[1, 1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[1, 2].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			// Column 2 = Z axis unchanged
			#expect(matrix[2, 0].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[2, 1].isApproximatelyEqual(to: 0.0, absoluteTolerance: 1e-12))
			#expect(matrix[2, 2].isApproximatelyEqual(to: 1.0))
		}

	/// Test the quaternion getter: convert a rotation matrix to a quaternion
	/// and back to a matrix; the resulting 3×3 matrix should be approximately
	/// equal to the original.
	///
		@Test("quaternion round-trip")
		func quaternionRoundTrip() async throws {
			let original = Matrix3x3<Double>(withRotation:
				[.degrees(30.0), .degrees(45.0), .degrees(60.0)] as Units.Rotation<SIMD3<Double>>,
				order: .XYZ
			)

			let quaternion = original.quaternion
			let reconstructed = Matrix3x3(withQuaternion: quaternion)

			for column in 0..<3 {
				for row in 0..<3 {
					#expect(reconstructed[column, row].isApproximatelyEqual(to: original[column, row]))
				}
			}
		}

	/// Test that the identity quaternion converts to an identity rotation matrix.
	///
		@Test("identity quaternion")
		func identityQuaternion() async throws {
			let quaternion = Quaternion<Double>.identity
			let matrix = Matrix3x3(withQuaternion: quaternion)
			#expect(matrix.isIdentity)
		}
	}
}

extension Matrix3x3Tests {
	@Suite("SquareMatrix")
	struct SquareMatrix {
	/// Tests getting the adjugate matrix of a 3×3 matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  2  3 |
	/// | 0  1  4 |
	/// | 5  6  0 |
	/// ```
	///
	/// The adjugate is the transpose of the cofactor matrix.
	///
		@Test("adjugate")
		func adjugate() async throws {
			// Stored column-major: col0=(1,0,5), col1=(2,1,6), col2=(3,4,0)
			let matrix = Matrix3x3(columns:
				Vector3(1.0, 0.0, 5.0),
				Vector3(2.0, 1.0, 6.0),
				Vector3(3.0, 4.0, 0.0)
			)

			let adjugate = matrix.adjugate

			// adj = (1/det) * M^-1 * det = cofactor^T
			// We verify adj * matrix ≈ det * I
			let det = matrix.determinant
			let product = adjugate * matrix

			for column in 0..<3 {
				for row in 0..<3 {
					let expected = det * (column == row ? 1.0 : 0.0)
					#expect(product[column, row].isApproximatelyEqual(to: expected))
				}
			}
		}

	/// Tests getting the cofactor matrix of a 3×3 matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  2  3 |
	/// | 0  1  4 |
	/// | 5  6  0 |
	/// ```
	///
	/// The cofactor C[i,j] = (-1)^(i+j) * minor(i,j).
	///
		@Test("cofactor")
		func cofactor() async throws {
			let matrix = Matrix3x3(columns:
				Vector3(1.0, 0.0, 5.0),
				Vector3(2.0, 1.0, 6.0),
				Vector3(3.0, 4.0, 0.0)
			)

			let cofactor = matrix.cofactor

			// Verify cofactor^T = adjugate and adjugate * matrix = det * I
			let adj = cofactor.transposed
			let det = matrix.determinant
			let product = adj * matrix

			for column in 0..<3 {
				for row in 0..<3 {
					let expected = det * (column == row ? 1.0 : 0.0)
					#expect(product[column, row].isApproximatelyEqual(to: expected))
				}
			}
		}

	/// Tests the determinant of a singular 3×3 matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  2  3 |
	/// | 4  5  6 |
	/// | 7  8  9 |
	/// ```
	///
	/// Output: 0 (rows are linearly dependent)
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double3x3` type.
	///
		@Test("determinant #1")
		func determinant_1() async throws {
			// Rows are [1,2,3], [4,5,6], [7,8,9] — third row = 2*row2 - row1,
			// so the determinant is zero.
			let matrix = Matrix3x3(columns:
				Vector3(1.0, 4.0, 7.0),
				Vector3(2.0, 5.0, 8.0),
				Vector3(3.0, 6.0, 9.0)
			)

			#expect(matrix.determinant.isApproximatelyEqual(to: 0.0))

		#if canImport(simd)
			let matrixSIMD = simd_double3x3(
				SIMD3<Double>(1.0, 4.0, 7.0),
				SIMD3<Double>(2.0, 5.0, 8.0),
				SIMD3<Double>(3.0, 6.0, 9.0)
			)

			#expect(matrix.determinant.isApproximatelyEqual(to: matrixSIMD.determinant))
		#endif
		}

	/// Tests the determinant of an invertible 3×3 matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  2  3 |
	/// | 0  1  4 |
	/// | 5  6  0 |
	/// ```
	///
	/// Output: det = 1*(1*0 - 4*6) - 2*(0*0 - 4*5) + 3*(0*6 - 1*5)
	///             = 1*(-24) - 2*(-20) + 3*(-5)
	///             = -24 + 40 - 15 = 1
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double3x3` type.
	///
		@Test("determinant #2")
		func determinant_2() async throws {
			let matrix = Matrix3x3(columns:
				Vector3(1.0, 0.0, 5.0),
				Vector3(2.0, 1.0, 6.0),
				Vector3(3.0, 4.0, 0.0)
			)

			#expect(matrix.determinant.isApproximatelyEqual(to: 1.0))

		#if canImport(simd)
			let matrixSIMD = simd_double3x3(
				SIMD3<Double>(1.0, 0.0, 5.0),
				SIMD3<Double>(2.0, 1.0, 6.0),
				SIMD3<Double>(3.0, 4.0, 0.0)
			)

			#expect(matrix.determinant.isApproximatelyEqual(to: matrixSIMD.determinant))
		#endif
		}

	/// Tests that the determinant of the identity matrix is 1.
	///
		@Test("determinant #3")
		func determinant_3() async throws {
			#expect(Matrix3x3<Double>.identity.determinant.isApproximatelyEqual(to: 1.0))
		}

	/// Tests calculating the trace of a 3×3 matrix.
	///
	/// Input:
	/// ```swift
	/// | 1  4  7 |
	/// | 2  5  8 |
	/// | 3  6  9 |
	/// ```
	///
	/// Output: 1 + 5 + 9 = 15
	///
		@Test("trace")
		func trace() async throws {
			let matrix = Matrix3x3(columns:
				Vector3(1.0, 2.0, 3.0),
				Vector3(4.0, 5.0, 6.0),
				Vector3(7.0, 8.0, 9.0)
			)

			#expect(matrix.trace == 15.0)
		}

	/// Tests transposing a 3×3 matrix (non-mutating).
	///
	/// Input (column-major: col0=[1,2,3], col1=[4,5,6], col2=[7,8,9]):
	/// ```swift
	/// | 1  4  7 |
	/// | 2  5  8 |
	/// | 3  6  9 |
	/// ```
	///
	/// Output: result[column, row] = original[row, column]
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double3x3` type.
	///
		@Test("transposed")
		func transposed() async throws {
			let matrix = Matrix3x3(columns:
				Vector3(1.0, 2.0, 3.0),
				Vector3(4.0, 5.0, 6.0),
				Vector3(7.0, 8.0, 9.0)
			)

			let result = matrix.transposed

			for column in 0..<3 {
				for row in 0..<3 {
					#expect(result[column, row] == matrix[row, column])
				}
			}

		#if canImport(simd)
			// Test the same functionality on a simd matrix and compare the
			// result.
			//
			let matrixSIMD = simd_double3x3(
				SIMD3<Double>(1.0, 2.0, 3.0),
				SIMD3<Double>(4.0, 5.0, 6.0),
				SIMD3<Double>(7.0, 8.0, 9.0)
			)

			let resultSIMD = matrixSIMD.transpose

			for x in 0..<3 {
				for y in 0..<3 {
					#expect(result[x, y] == resultSIMD[x, y])
				}
			}
		#endif
		}

	/// Tests transposing a 3×3 matrix in place (mutating).
	///
	/// - Note:
	///   On platforms where the simd library is available, the results are
	///   compared against the `simd_double3x3` type.
	///
		@Test("transpose")
		func transpose() async throws {
			var matrix = Matrix3x3(columns:
				Vector3(1.0, 2.0, 3.0),
				Vector3(4.0, 5.0, 6.0),
				Vector3(7.0, 8.0, 9.0)
			)

			let original = matrix
			matrix.transpose()

			for column in 0..<3 {
				for row in 0..<3 {
					#expect(matrix[column, row] == original[row, column])
				}
			}

		#if canImport(simd)
			var matrixSIMD = simd_double3x3(
				SIMD3<Double>(1.0, 2.0, 3.0),
				SIMD3<Double>(4.0, 5.0, 6.0),
				SIMD3<Double>(7.0, 8.0, 9.0)
			)

			matrixSIMD = matrixSIMD.transpose

			for x in 0..<3 {
				for y in 0..<3 {
					#expect(matrix[x, y] == matrixSIMD[x, y])
				}
			}
		#endif
		}
	}
}
