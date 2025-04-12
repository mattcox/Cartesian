//
//  QuaternionVectorRotation.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A ``Quaternion`` that can be used to rotate a ``Vector``.
///
/// This type of quaternion represents a rotation in 3D space and can be 
/// applied to a vector to rotate it around an axis.
/// 
public protocol QuaternionVectorRotation: Quaternion {
/// Rotates a vector using the quaternion, returning the rotated result.
///
/// This applies the quaternion’s rotation to the input vector, producing 
/// a new vector that represents the original vector rotated in 3D space.
///
/// - Parameters:
///   - vector: The vector that will be rotated by the quaternion.
///
/// - Returns: A vector storing the result of the rotation.
///
	func rotate<V: Vector3>(vector: V) -> V where V.Component == Component
}
