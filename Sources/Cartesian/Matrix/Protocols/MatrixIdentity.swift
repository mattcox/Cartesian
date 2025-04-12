//
//  MatrixIdentity.swift
//  Cartesian
//
//  Created by Matt Cox on 09/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A ``Matrix`` that can be set to identity.
///
/// An identity matrix is a matrix with 1 in the main diagonal, and 0 everywhere
/// else. It acts as the multiplicative identity in matrix operations, leaving
/// other matrices unchanged when multiplied.
///
/// ```
/// [[1, 0, 0],
///  [0, 1, 0],
///  [0, 0, 1]]
/// ```
///
public protocol MatrixIdentity: Matrix {
/// Creates an identity matrix.
///
/// An identity matrix is a matrix with 1 in the main diagonal, and 0
/// everywhere else. It acts as the multiplicative identity in matrix
/// operations, leaving other matrices unchanged when multiplied.
///
/// ```
/// [[1, 0, 0],
///  [0, 1, 0],
///  [0, 0, 1]]
/// ```
///
	static var identity: Self { get }
	
/// Returns true if the matrix is identity.
///
/// An identity matrix is a matrix with 1 in the main diagonal, and 0
/// everywhere else. It acts as the multiplicative identity in matrix
/// operations, leaving other matrices unchanged when multiplied.
///
/// ```
/// [[1, 0, 0],
///  [0, 1, 0],
///  [0, 0, 1]]
/// ```
///
	var isIdentity: Bool { get }
	
/// Sets the matrix to identity.
///
/// An identity matrix is a matrix with 1 in the main diagonal, and 0
/// everywhere else. It acts as the multiplicative identity in matrix
/// operations, leaving other matrices unchanged when multiplied.
///
/// ```
/// [[1, 0, 0],
///  [0, 1, 0],
///  [0, 0, 1]]
/// ```
///
	mutating func toIdentity()
}
