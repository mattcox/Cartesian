//
//  CrossProduct.swift
//  Cartesian
//
//  Created by Matt Cox on 04/04/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

// Cross product operators.
//
infix operator ⨯
infix operator ⨯=

/// A type can be used to form a cross product with another of this type.
///
public protocol CrossProduct {
/// The result type of the cross product.
///
	associatedtype Cross

/// Computes the cross product of this object and the provided object.
///
/// - Parameters:
///   - other: The object to calculate a cross product against.
///
/// - Returns: The result of the cross product.
///
	func cross(_ other: Self) -> Cross
	
/// Computes the cross product of this object and the provided object.
///
/// - Parameters:
///   - lhs: The first object in the cross product.
///   - rhs: The second object in the cross product.
///
/// - Returns: The result of the cross product.
///
	static func ⨯ (lhs: Self, rhs: Self) -> Cross
}

extension CrossProduct {
	public static func ⨯ (lhs: Self, rhs: Self) -> Cross {
		lhs.cross(rhs)
	}
}
