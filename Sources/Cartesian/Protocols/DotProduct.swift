//
//  VectorDot.swift
//  Cartesian
//
//  Created by Matt Cox on 04/04/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

// Dot product operator.
//
infix operator ∙

/// A type can be used to compute a dot product with another of this type.
///
public protocol DotProduct {
/// The result type of the dot product.
///
	associatedtype Dot

/// Computes the dot product of this object and the provided object.
///
/// - Parameters:
///   - other: The object to calculate a dot product against.
///
/// - Returns: The result of the dot product.
///
	func dot(_ other: Self) -> Dot
	
/// Computes the dot product of this object and the provided object.
///
/// - Parameters:
///   - lhs: The first object in the dot product.
///   - rhs: The second object in the dot product.
///
/// - Returns: The result of the dot product.
///
	static func ∙ (lhs: Self, rhs: Self) -> Dot
}

extension DotProduct {
	public static func ∙ (lhs: Self, rhs: Self) -> Dot {
		lhs.dot(rhs)
	}
}
