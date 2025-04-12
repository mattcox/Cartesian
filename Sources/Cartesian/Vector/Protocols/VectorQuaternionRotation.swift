//
//  VectorQuaternionRotation.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A ``Vector`` that can be rotated by a ``Quaternion``.
///
/// This allows the vector to undergo a 3D rotational transformation defined 
/// by a quaternion, preserving direction and orientation without suffering 
/// from gimbal lock.
///
public protocol VectorQuaternionRotation: Vector3 {
/// Rotates the vector using the given quaternion and returns the result.
///
/// Applies the quaternion’s rotation to the vector in 3D space, producing
/// a new vector that represents the rotated direction or position.
///
/// - Parameters:
///   - quaternion: The quaternion to rotate the vector by.
///
/// - Returns: A new vector representing the rotated result.
///
	func rotated<T>(by quaternion: T) -> Self where T: QuaternionVectorRotation, T.Component == Component
	
/// Rotates the vector by a quaternion, mutating the vector.
///
/// Applies the quaternion’s rotation to the vector in 3D space, updating
/// its components to reflect the rotated direction or position.
///
/// - Parameters:
///   - quaternion: The quaternion that the vector be rotated by.
///
	mutating func rotate<T>(by quaternion: T) where T: QuaternionVectorRotation, T.Component == Component
}
