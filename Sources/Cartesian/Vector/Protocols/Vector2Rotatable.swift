//
//  Vector2Rotatable.swift
//  Cartesian
//
//  Created by Matt Cox on 04/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import Units

/// A ``Vector`` that can be rotated by an angle.
///
public protocol Vector2Rotatable: Vector2 {
/// The scalar storing the angle information.
///
	associatedtype AngleRepresentation: BinaryFloatingPoint

/// Rotates the vector by the given angle and returns the result.
///
/// Applies a rotational transformation to the vector using the specified
/// angle.
///
/// - Parameters:
///   - angle: The angle by which to rotate the vector.
///
/// - Returns: A new vector representing the rotated result.
///
	func rotated(by angle: Angle<AngleRepresentation>) -> Self
	
/// Rotates the vector by the given angle, mutating the vector.
///
/// Applies a rotational transformation to the vector using the specified
/// angle.
///
/// - Parameters:
///   - angle: The angle by which to rotate the vector.
///
	mutating func rotate(by angle: Angle<AngleRepresentation>)
}
