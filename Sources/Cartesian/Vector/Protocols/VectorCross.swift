//
//  VectorCross.swift
//  Cartesian
//
//  Created by Matt Cox on 04/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

// Cross product operators.
//
infix operator ⨯
infix operator ⨯=

/// A ``Vector`` that can be used to compute a cross product with another
/// vector.
///
public protocol VectorCross: Vector {
/// Computes the cross product of this vector and the provided vector.
///
/// The cross product of two vectors is another vector perpendicular to
/// the two vectors.
///
/// - Parameters:
///   - other: The vector to calculate a cross product against.
///
/// - Returns: A new vector storing the calculated cross product.
///
	func cross(_ other: Self) -> Self
	
/// Computes the cross product of this vector and the provided vector.
///
/// - Parameters:
///   - lhs: The first vector in the cross product.
///   - rhs: The second vector in the cross product.
///
/// - Returns: A vector containing the result of the cross product.
///
	static func ⨯ (lhs: Self, rhs: Self) -> Self

/// Computes the cross product of this vector and the provided vector.
///
/// - Parameters:
///   - lhs: The first vector in the cross product. This will be updated
///   with the result of the cross product.
///   - rhs: The second vector in the cross product.
///
	static func ⨯= (lhs: inout Self, rhs: Self)
}

extension VectorCross {
	public static func ⨯ (lhs: Self, rhs: Self) -> Self {
		lhs.cross(rhs)
	}
}
