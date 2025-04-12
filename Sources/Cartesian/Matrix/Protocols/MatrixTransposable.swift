//
//  MatrixTransposable.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A ``Matrix`` that can be transposed.
///
/// A transposed matrix is the result of flipping the original matrix across its 
/// main diagonal, effectively swapping rows with columns.
///
public protocol MatrixTransposable: Matrix {
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
