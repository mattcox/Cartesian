//
//  MatrixRotation.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A ``Matrix`` that represents rotational information using Euler angles.
///
/// Euler angles describe rotation around the principal axes (typically X, Y,
/// and Z), and this matrix stores or derives such rotations accordingly.
///
public protocol MatrixRotation: Matrix where Self.Component: BinaryFloatingPoint {
/// Initializes the matrix from a rotation vector.
///
/// The rotation vector contains Euler angles representing rotations around
/// the principal axes. The specified rotation order determines the sequence
/// in which these individual rotations are applied in space, typically
/// relative to a gimbal.
///
/// - Parameters:
///   - rotation: The rotation used to initialize the matrix.
///   - order: The order to apply the rotations.
///
	init<T: Vector3>(withRotation rotation: Rotation<T>, order: RotationOrder) where T.Component == Component
	
/// Converts a rotation matrix into a vector of Euler angles.
///
/// The resulting vector contains Euler angles representing rotations around 
/// the principal axes. The specified rotation order defines the sequence in 
/// which these rotations are applied in space, typically following a
/// gimbal-based system.
///
/// - Parameters:
///   - order: The order the rotations are applied to the matrix.
///
/// - Returns: The rotations stored in the matrix.
///
	func toRotation<T: Vector3>(order: RotationOrder) -> Rotation<T> where T.Component == Component
	
/// Sets the matrix components from a rotation vector.
///
/// The rotation vector encodes Euler angles representing rotation around
/// the principal axes. The specified rotation order determines the sequence
/// in which these individual rotations are applied in space, typically
/// following a gimbal-based system.
///
/// - Parameters:
///   - rotation: The rotation applied to the matrix.
///   - order: The order to apply the rotations.
/// 
	mutating func fromRotation<T: Vector3>(_ rotation: Rotation<T>, order: RotationOrder) where T.Component == Component
}
