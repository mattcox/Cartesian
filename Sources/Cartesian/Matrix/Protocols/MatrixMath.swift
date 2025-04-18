//
//  MatrixMath.swift
//  Cartesian
//
//  Created by Matt Cox on 18/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A matrix that supports basic mathematical operations.
///
public protocol MatrixMath: MatrixProtocol {	
/// Adds one matrix to another.
///
/// - Parameters:
///   - lhs: The first matrix in the addition.
///   - rhs: The second matrix in the addition.
///
/// - Returns: A matrix containing the result of the addition.
///
	static func + (lhs: Self, rhs: Self) -> Self
	
/// Adds one matrix to another, mutating the first matrix.
///
/// - Parameters:
///   - lhs: The first matrix in the addition. This will be updated with the
///   result of the addition.
///   - rhs: The second matrix in the addition.
///
	static func += (lhs: inout Self, rhs: Self)
	
/// Returns a matrix with all components negated.
///
/// - Parameters:
///   - rhs: The matrix to negate.
///
/// - Returns: The negated matrix.
///
	static prefix func - (rhs: Self) -> Self
	
/// Subtracts one matrix from another.
///
/// - Parameters:
///   - lhs: The matrix to subtract from.
///   - rhs: The matrix to subtract.
///
/// - Returns: A matrix containing the result of the subtraction.
///
	static func - (lhs: Self, rhs: Self) -> Self
	
/// Subtracts one matrix from another, mutating the first matrix.
///
/// - Parameters:
///   - lhs: The first matrix in the subtraction. This will be updated with
///   the result of the subtraction.
///   - rhs: The second matrix in the subtraction.
///
	static func -= (lhs: inout Self, rhs: Self)
	
/// Multiplies one matrix with another.
///
/// - Parameters:
///   - lhs: The first matrix in the multiplication.
///   - rhs: The second matrix in the multiplication.
///
/// - Returns: A matrix containing the result of the multiplication.
///
	static func * (lhs: Self, rhs: Self) -> Self
	
/// Multiplies one matrix with another, mutating the first matrix.
///
/// - Parameters:
///   - lhs: The first matrix in the multiplication. This will be updated
///   with the result of the multiplication.
///   - rhs: The second matrix in the multiplication.
///
	static func *= (lhs: inout Self, rhs: Self)
	
/// Multiplies a matrix by a scalar value, returning a matrix.
///
/// - Parameters:
///   - lhs: The scalar value to multiply by.
///   - rhs: The matrix to be multiplied.
///
/// - Returns: A matrix containing the result of the multiplication.
///
	static func * (lhs: Component, rhs: Self) -> Self

/// Multiplies a matrix by a scalar value, returning a matrix.
///
/// - Parameters:
///   - lhs: The matrix to be multiplied.
///   - rhs: The scalar value to multiply by.
///
/// - Returns: A matrix containing the result of the multiplication.
///
	static func * (lhs: Self, rhs: Component) -> Self

/// Multiplies a matrix by a scalar value, mutating the matrix.
///
/// - Parameters:
///   - lhs: The matrix to be multiplied. This will be updated with the
///   result of the multiplication.
///   - rhs: The scalar value to multiply by.
///
	static func *= (lhs: inout Self, rhs: Component)
}
