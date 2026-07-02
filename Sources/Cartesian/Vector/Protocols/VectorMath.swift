//
//  VectorMath.swift
//  Cartesian
//
//  Created by Matt Cox on 04/04/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

/// A vector that supports basic mathematical operations.
///
public protocol VectorMath: VectorProtocol {
/// Finds the minimum numerical value in the vector.
///
/// - Returns: The minimum numerical value in the vector.
///
	func min() -> Component

/// Finds the maximum numerical value in the vector.
///
/// - Returns: The maximum numerical value in the vector.
///
	func max() -> Component
	
/// Computes the median average of all values stored within the vector.
///
/// - Returns The median average of all values in the vector.
///
	func average() -> Component
	
/// Computes the sum of all values stored within the vector.
///
/// - Returns: The sum of all values in the vector.
///
	func sum() -> Component
	
/// Adds one vector to another.
///
/// - Parameters:
///   - lhs: The first vector in the addition.
///   - rhs: The second vector in the addition.
///
/// - Returns: A vector containing the result of the addition.
///
	static func + (lhs: Self, rhs: Self) -> Self
	
/// Adds one vector to another, mutating the first vector.
///
/// - Parameters:
///   - lhs: The first vector in the addition. This will be updated with the
///   result of the addition.
///   - rhs: The second vector in the addition.
///
	static func += (lhs: inout Self, rhs: Self)

/// Adds a scalar value to every component in the vector.
///
/// - Parameters:
///   - lhs: The vector in the addition.
///   - rhs: A scalar value to add to every component in the vector.
///
/// - Returns: A vector containing the result of the addition.
///
	static func + (lhs: Self, rhs: Component) -> Self

/// Adds a scalar value to every component in the vector.
///
/// - Parameters:
///   - lhs: A scalar value to add to every component in the vector.
///   - rhs: The vector in the addition.
///
/// - Returns: A vector containing the result of the addition.
///
	static func + (lhs: Component, rhs: Self) -> Self

/// Adds a scalar value to every component in the vector, mutating the
/// vector.
///
/// - Parameters:
///   - lhs: The vector in the addition. This will be updated with the
///   result of the addition.
///   - rhs: A scalar value to add to every component in the vector.
///
	static func += (lhs: inout Self, rhs: Component)

/// Subtracts one vector from another.
///
/// - Parameters:
///   - lhs: The first vector in the subtraction.
///   - rhs: The second vector in the subtraction.
///
/// - Returns: A vector containing the result of the subtraction.
///
	static func - (lhs: Self, rhs: Self) -> Self
	
/// Subtracts one vector from another, mutating the first vector.
///
/// - Parameters:
///   - lhs: The first vector in the subtraction. This will be updated with
///   the result of the subtraction.
///   - rhs: The second vector in the subtraction.
///
	static func -= (lhs: inout Self, rhs: Self)

/// Subtracts a scalar value to every component in the vector.
///
/// - Parameters:
///   - lhs: The vector in the subtraction.
///   - rhs: A scalar value to subtract from every component in the vector.
///
/// - Returns: A vector containing the result of the subtraction.
///
	static func - (lhs: Self, rhs: Component) -> Self

/// Subtracts a scalar value to every component in the vector.
///
/// - Parameters:
///   - lhs: A scalar value to subtract from every component in the vector.
///   - rhs: The vector in the subtraction.
///
/// - Returns: A vector containing the result of the subtraction.
///
	static func - (lhs: Component, rhs: Self) -> Self

/// Subtracts a scalar value to every component in the vector, mutating the
/// vector.
///
/// - Parameters:
///   - lhs: The vector in the subtraction. This will be updated with the
///   result of the subtraction.
///   - rhs: A scalar value to subtract from every component in the vector.
///
	static func -= (lhs: inout Self, rhs: Component)
	
/// Returns the negation of the vector.
///
/// Negating a vectors inverts the sign of each of its components.
///
/// - Parameters:
///   - vector: The vector to negate.
///
/// - Returns: The negated vector.
///
	static prefix func - (vector: Self) -> Self

/// Multiplies one vector with another.
///
/// - Parameters:
///   - lhs: The first vector in the multiplication.
///   - rhs: The second vector in the multiplication.
///
/// - Returns: A vector containing the result of the multiplication.
///
	static func * (lhs: Self, rhs: Self) -> Self

/// Multiplies one vector with another, mutating the first vector.
///
/// - Parameters:
///   - lhs: The first vector in the multiplication. This will be updated
///   with the result of the multiplication.
///   - rhs: The second vector in the multiplication.
///
	static func *= (lhs: inout Self, rhs: Self)

/// Multiplies a vector by a scalar value, returning the scaled vector.
///
/// Each component of the vector is multiplied by the scalar, resulting in a
/// new vector that is scaled uniformly.
///
/// - Parameters:
///   - lhs: The vector to be multiplied.
///   - rhs: The scalar value to multiply by.
///
/// - Returns: A vector containing the result of the multiplication.
///
	static func * (lhs: Self, rhs: Component) -> Self

/// Multiplies a vector by a scalar value, returning the scaled vector.
///
/// Each component of the vector is multiplied by the scalar, resulting in a 
/// new vector that is scaled uniformly.
///
/// - Parameters:
///   - lhs: The scalar value to multiply by.
///   - rhs: The vector to be multiplied.
///
/// - Returns: A vector containing the result of the multiplication.
///
	static func * (lhs: Component, rhs: Self) -> Self
	
/// Multiplies a vector by a scalar value, mutating the vector.
///
/// Each component of the vector is multiplied by the scalar, resulting in a
/// new vector that is scaled uniformly.
///
/// - Parameters:
///   - lhs: The vector to be multiplied. This will be updated with the
///   result of the multiplication.
///   - rhs: The scalar value to multiply by.
///
	static func *= (lhs: inout Self, rhs: Component)

/// Divides one vector by another, returning the divided vector.
///
/// Care should be taken to ensure the _rhs_ vector contains no components
/// equal to zero as division by zero is undefined.
///
/// - Parameters:
///   - lhs: The first vector in the division.
///   - rhs: The second vector in the division.
///
/// - Returns: A vector containing the result of the division.
///
	static func / (lhs: Self, rhs: Self) -> Self
	
/// Divides one vector by another, mutating the first vector.
///
/// Care should be taken to ensure the _rhs_ vector contains no components
/// equal to zero as division by zero is undefined.
///
/// - Parameters:
///   - lhs: The first vector in the division. This will be updated with the
///   result of the division.
///   - rhs: The second vector in the division.
///
	static func /= (lhs: inout Self, rhs: Self)

/// Divides a vector by a scalar value, returning the divided vector.
///
/// Each component of the vector is divided by the scalar, resulting in a
/// new vector that is scaled uniformly.
///
/// - Parameters:
///   - lhs: The vector to be divided.
///   - rhs: The scalar value to divided by.
///
/// - Returns: A vector containing the result of the division.
///
	static func / (lhs: Self, rhs: Component) -> Self

/// Divides a vector by a scalar value, mutating the vector.
///
/// Each component of the vector is divided by the scalar, resulting in a
/// new vector that is scaled uniformly.
///
/// - Parameters:
///   - lhs: The vector to be divided.
///   - rhs: The scalar value to divided by.
///
	static func /= (lhs: inout Self, rhs: Component)
}
