//
//  SquareMatrix.swift
//  Cartesian
//
//  Created by Matt Cox on 12/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A matrix with an equal number of rows and columns.
///
/// Such matrices are known as square matrices and are commonly used in 
/// linear algebra for operations like inversion, determinant calculation, 
/// and representing transformations.
///
public protocol SquareMatrix: MatrixProtocol {
/// The adjugate (or classical adjoint) of the matrix, which is the
/// transpose of the cofactor matrix.
///
	var adjugate: Self { get }
	
/// The cofactor of the matrix.
///
/// The cofactor matrix is composed of the signed minors of each element
/// in the original matrix.
/// 
	var cofactor: Self { get }
	
/// The determinant of the matrix.
///
/// The determinant is a scalar value that summarizes certain properties 
/// of the matrix, such as whether it is invertible. A non-zero determinant 
/// indicates that the matrix is invertible, while a zero determinant 
/// indicates that it is singular.
///
	var determinant: Component { get }
	
/// The trace of the matrix.
///
/// The trace is the sum of the elements on the main diagonal of the matrix.
/// It is often used in linear algebra and physics for analyzing properties
/// such as invariants under coordinate transformations.
///
	var trace: Component { get }
	
/// A transposed version of the matrix.
///
/// A transposed matrix is the result of flipping the original matrix across
/// its main diagonal, effectively swapping rows with columns.
///
	var transposed: Self { get }
	
/// Transposes this matrix.
///
/// A transposed matrix is the result of flipping the original matrix across
/// its main diagonal, effectively swapping rows with columns.
///
	mutating func transpose()
}

extension SquareMatrix where Self: MatrixSub {
	public var adjugate: Self {
		cofactor.transposed
	}
}

extension SquareMatrix where Self: MatrixSub, SubMatrix: SquareMatrix {
	public var cofactor: Self {
		var matrix = Self()
		for column in 0..<Self.columns {
			for row in 0..<Self.rows {
				let minor = subMatrix(excludingColumn: column, row: row)
				let sign: Component = ((row + column) % 2 == 0) ? 1 : -1
				matrix[column, row] = sign * minor.determinant
			}
		}
		return matrix
	}
}
