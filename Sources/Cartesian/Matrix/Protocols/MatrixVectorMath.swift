//
//  MatrixVectorMath.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A ``Matrix`` that can be used to transform a ``Vector``.
///
/// This type of matrix applies linear transformations such as translation, 
/// rotation, scaling, or shearing to vectors in space.
/// 
public protocol MatrixVectorMath: Matrix {
/// The vector that can be multiplied by the matrix.
///
	associatedtype VectorRepresentation: Vector

/// Multiplies a matrix with a vector, producing a transformed vector.
///
/// This operation applies the matrix’s transformation—such as scaling,
/// rotation, or translation to the input vector. For example, if the matrix
/// encodes a uniform scale of `2.0`, and the input vector has an X
/// component of `1.0`, the resulting vector will have an X component of
/// `2.0`.
///
/// - Parameters:
///   - lhs: The transformation matrix.
///   - rhs: The vector to be transformed.
///
/// - Returns: A new vector containing the result of the transformation.
///
	static func * (lhs: Self, rhs: VectorRepresentation) -> VectorRepresentation

/// Multiplies a matrix with a vector, producing a transformed vector.
///
/// This operation applies the matrix’s transformation—such as scaling,
/// rotation, or translation to the input vector. For example, if the matrix
/// encodes a uniform scale of `2.0`, and the input vector has an X
/// component of `1.0`, the resulting vector will have an X component of
/// `2.0`.
///
/// - Parameters:
///   - lhs: The vector to be transformed.
///   - rhs: The transformation matrix.
///
/// - Returns: A new vector containing the result of the transformation.
///
	static func * (lhs: VectorRepresentation, rhs: Self) -> VectorRepresentation
}
