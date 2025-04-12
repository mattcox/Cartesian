//
//  SquareMatrix.swift
//  Cartesian
//
//  Created by Matt Cox on 12/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A ``Matrix`` with an equal number of rows and columns.
///
/// Such matrices are known as square matrices and are commonly used in 
/// linear algebra for operations like inversion, determinant calculation, 
/// and representing transformations.
///
public protocol SquareMatrix: Invertible, MatrixIdentity {
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
}
