//
//  Vector3Rotatable.swift
//  Cartesian
//
//  Created by Matt Cox on 04/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import Units

/// A ``Vector`` that can be rotated by an angle.
///
public protocol Vector3Rotatable: Vector3 {
/// The scalar storing the angle information.
///
	associatedtype AngleRepresentation: BinaryFloatingPoint

/// Rotates the vector by three Euler angles in X, Y and Z, and returns
/// the result.
///
/// The specified rotation order determines the sequence in which the
/// individual rotations are applied in space, typically relative to a
/// gimbal.
///
/// - Parameters:
///   - x: The angle by which to rotate the vector in the X axis.
///   - y: The angle by which to rotate the vector in the Y axis.
///   - z: The angle by which to rotate the vector in the Z axis.
///   - order: The order to apply the rotations.
///
/// - Returns: A new vector representing the rotated result.
///
	func rotated(x: Angle<AngleRepresentation>, y: Angle<AngleRepresentation>, z: Angle<AngleRepresentation>, order: RotationOrder) -> Self
	
/// Rotates the vector by a vector storing Euler angles in X, Y and Z, and
/// returns the result.
///
/// The specified rotation order determines the sequence in which the
/// individual rotations are applied in space, typically relative to a
/// gimbal.
///
/// - Parameters:
///   - rotation: The rotation by which to rotate the vector.
///   - order: The order to apply the rotations.
///
/// - Returns: A new vector representing the rotated result.
///
	func rotated<T: Vector3>(by rotation: Rotation<T>, order: RotationOrder) -> Self where T.Component == AngleRepresentation
	
/// Rotates the vector by three Euler angles in X, Y and Z, mutating the
/// vector.
///
/// The specified rotation order determines the sequence in which the
/// individual rotations are applied in space, typically relative to a
/// gimbal.
///
/// - Parameters:
///   - x: The angle by which to rotate the vector in the X axis.
///   - y: The angle by which to rotate the vector in the Y axis.
///   - z: The angle by which to rotate the vector in the Z axis.
///   - order: The order to apply the rotations.
///
	mutating func rotate(x: Angle<AngleRepresentation>, y: Angle<AngleRepresentation>, z: Angle<AngleRepresentation>, order: RotationOrder)
	
/// Rotates the vector by a vector storing Euler angles in X, Y and Z,
/// mutating the vector.
///
/// The specified rotation order determines the sequence in which the
/// individual rotations are applied in space, typically relative to a
/// gimbal.
///
/// - Parameters:
///   - rotation: The rotation by which to rotate the vector.
///   - order: The order to apply the rotations.
///
	mutating func rotate<T: Vector3>(by rotation: Rotation<T>, order: RotationOrder) where T.Component == AngleRepresentation
}
