//
//  QuaternionMath.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A ``Quaternion`` that supports basic mathematical operations.
///
public protocol QuaternionMath: Quaternion {
/// Adds one quaternion to another.
///
/// - Parameters:
///   - lhs: The first quaternion in the addition.
///   - rhs: The second quaternion in the addition.
///
/// - Returns: A quaternion containing the result of the addition.
///
	static func + (lhs: Self, rhs: Self) -> Self
	
/// Adds one quaternion to aother, mutating the first quaternion.
///
/// - Parameters:
///   - lhs: The first quaternion in the addition. This will be updated with
///   the result of the addition.
///   - rhs: The second quaternion in the addition.
///
	static func += (lhs: inout Self, rhs: Self)
	
/// Returns the negation of the quaternion.
///
/// Negating a quaternion inverts the sign of each of its components. For
/// unit quaternions representing rotation, the negated quaternion
/// represents the same rotation.
///
/// - Parameters:
///   - quaternion: The quaternion to negate.
///
/// - Returns: The negated quaternion.
///
	static prefix func - (quaternion: Self) -> Self

/// Subtracts one quaternion from another.
///
/// - Parameters:
///   - lhs: The quaternion to subtract from.
///   - rhs: The quaternion to subtract.
///
/// - Returns: A quaternion containing the result of the subtraction.
///
	static func - (lhs: Self, rhs: Self) -> Self
	
/// Subtracts one quaternion from another, mutating the first quaternion.
///
/// - Parameters:
///   - lhs: The first quaternion in the subtraction. This will be updated
///   with the result of the subtraction.
///   - rhs: The second quaternion in the subtraction.
///
	static func -= (lhs: inout Self, rhs: Self)

/// Multiplies one quaternion with another.
///
/// - Parameters:
///   - lhs: The first quaternion in the multiplication.
///   - rhs: The second quaternion in the multiplication.
///
/// - Returns: A quaternion containing the result of the multiplication.
///
	static func * (lhs: Self, rhs: Self) -> Self

/// Multiplies one quaternion with another, mutating the first quaternion.
///
/// - Parameters:
///   - lhs: The first quaternion in the multiplication. This will be
///   updated with the result of the multiplication.
///   - rhs: The second quaternion in the multiplication.
///
	static func *= (lhs: inout Self, rhs: Self)

/// Multiplies a quaternion by a scalar value, returning a quaternion.
///
/// - Parameters:
///   - lhs: The scalar value to multiply by.
///   - rhs: The quaternion to be multiplied.
///
/// - Returns: A quaternion containing the result of the multiplication.
///
	static func * (lhs: Component, rhs: Self) -> Self

/// Multiplies a quaternion by a scalar value, returning a quaternion.
///
/// - Parameters:
///   - lhs: The quaternion to be multiplied.
///   - rhs: The scalar value to multiply by.
///
/// - Returns: A quaternion containing the result of the multiplication.
///
	static func * (lhs: Self, rhs: Component) -> Self
	
/// Multiplies a quaternion by a scalar value, mutating the quaternion.
///
/// - Parameters:
///   - lhs: The quaternion to be multiplied. This will be updated with
///   the result of the multiplication.
///   - rhs: The scalar value to multiply by.
///
	static func *= (lhs: inout Self, rhs: Component)
}
