//
//  MatrixLinearTransform.swift
//  Cartesian
//
//  Created by Matt Cox on 18/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A matrix that represents linear transformations in a Cartesian coordinate
/// space.
///
/// Conforming types support transformations that preserve the origin, including
/// rotation, uniform and non-uniform scaling. These transformations can be
/// composed using matrix multiplication and applied to vectors to produce
/// transformed vectors within the same space.
/// 
public protocol MatrixLinearTransform: MatrixProtocol {
/// A vector representing the Euler angles describing a rotation.
///
	associatedtype Rotation: VectorProtocol

/// A vector representing the scale applied to each axis of the coordinate
/// space.
///
	associatedtype Scale: VectorProtocol
	
/// The scale components of the matrix.
///
/// Represents the amount of scaling applied independently to each axis.
/// For uniform scaling, all three components will have the same value.
///
	var scale: Scale { get set }
	
/// Initializes the matrix from Euler rotation angles.
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
	init(withRotation rotation: Rotation, order: RotationOrder)
	
/// Initializes the matrix with a scalar value encoding uniform scale
/// in all axis.
///
/// This creates a scaling matrix where the same scalar value is applied
/// along all axes.
///
/// - Parameters:
///   - scale: The uniform scale value to store in the matrix.
///
	init(withScale scale: Component)
	
/// Initializes the matrix with a vector encoding scale in each axis.
///
/// - Parameters:
///   - scale: The scale values for each axis of the matrix.
///
	init(withScale scale: Scale)
	
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
	func toRotation(order: RotationOrder) -> Rotation
	
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
	mutating func fromRotation(_ rotation: Rotation, order: RotationOrder)
}
