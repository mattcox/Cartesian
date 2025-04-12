//
//  QuaternionAxisAngle.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import Units

/// A ``Quaternion`` that can be represented using an axis and an angle.
///
/// This representation defines the rotation as an angle around a normalized
/// axis vector in 3D space.
///
public protocol QuaternionAxisAngle: Quaternion {
/// The scalar storing the angle.
///
	associatedtype AngleRepresentation: BinaryFloatingPoint
	
/// The vector storing the axis of rotation.
///
	associatedtype AxisRepresentation: Vector3 where AxisRepresentation.Component == Component
	
/// Initialize the quaternion from an axis vector and an angle around the
/// axis.
///
/// - Parameters:
///   - axis: The axis of rotation.
///   - angle: An angle describing the amount of rotation around the axis.
///
	init(withAxis axis: AxisRepresentation, angle: Angle<AngleRepresentation>)
	
/// The axis of rotation used to define the quaternion.
///
	var axis: AxisRepresentation { get set }
	
/// An angle describing the rotation around the axis.
///
	var angle: Angle<AngleRepresentation> { get set }
}
