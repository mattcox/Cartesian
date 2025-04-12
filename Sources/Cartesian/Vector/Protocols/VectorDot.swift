//
//  VectorDot.swift
//  Cartesian
//
//  Created by Matt Cox on 04/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

// Dot product operator.
//
infix operator ∙

/// A ``Vector`` that can be used to compute a dot product with another
/// vector.
///
public protocol VectorDot: Vector {
/// The result type of the dot product.
///
	associatedtype Dot: Numeric

/// Computes the dot product of this vector and the provided vector.
///
/// The dot product of two vectors is a scalar value encoding the cosine of
/// the angle between the two vectors. If the source vectors are
/// non-normalized, the resulting angle will be multiplied by the magnitude
/// of the source vectors.
///
/// - Parameters:
///   - other: The vector to calculate a dot product against.
///
/// - Returns: A value containing the result of the dot product.
///
	func dot(_ other: Self) -> Dot
	
/// Computes the dot product of this vector and the provided vector.
///
/// The dot product of two vectors is a scalar value encoding the cosine of
/// the angle between the two vectors. If the source vectors are
/// non-normalized, the resulting angle will be multiplied by the magnitude
/// of the source vectors.
///
/// - Parameters:
///   - lhs: The first vector in the dot product.
///   - rhs: The second vector in the dot product.
///
/// - Returns: A value containing the result of the dot product.
///
	static func ∙ (lhs: Self, rhs: Self) -> Dot
}

extension VectorDot {
	public static func ∙ (lhs: Self, rhs: Self) -> Dot {
		lhs.dot(rhs)
	}
}
