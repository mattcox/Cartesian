//
//  RotatableTransform.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import RealModule
import Units

/// A transform that can encode a rotation within a Cartesian coordinate space.
///
/// Rotation reorients the space around its origin. Rigid, similarity and affine
/// transforms all support rotation.
///
/// The representation of a rotation depends on the dimensionality of the
/// transform, and is exposed through the ``Rotation`` associated type. A
/// two-dimensional transform expresses its rotation as a single scalar
/// ``Angle``, whereas a three-dimensional transform expresses its rotation as a
/// ``Quaternion``. The representation is independent of how the conforming type
/// stores its components internally.
///
/// When the rotation is expressed as a quaternion, the rotation can
/// additionally be read and written as a vector of Euler angles. These
/// conveniences are provided automatically and require a ``RotationOrder`` to
/// be interpreted unambiguously.
///
public protocol RotatableTransform: TransformProtocol {
/// The type used to express the rotation encoded by the transform.
///
/// This is typically a scalar ``Angle`` for two-dimensional transforms, or a
/// ``Quaternion`` for three-dimensional transforms.
///
	associatedtype Rotation

/// The rotation encoded by the transform.
///
	var rotation: Rotation { get set }
}

extension RotatableTransform where Component: Real & SIMDScalar & BinaryFloatingPoint, Rotation == Quaternion<Component> {
/// The rotation encoded by the transform, expressed as Euler angles using
/// the default rotation order.
///
/// Setting this property replaces the rotation with the supplied Euler
/// angles, interpreted using ``RotationOrder/default``. For control over the
/// order in which the rotations are applied, use ``toEulerRotation(order:)``
/// and ``fromEulerRotation(_:order:)``.
///
	public var eulerRotation: Quaternion<Component>.Rotation {
		get {
			rotation.toRotation(order: .default)
		}
		set {
			rotation = Quaternion(withRotation: newValue, order: .default)
		}
	}

/// Converts the encoded rotation into a vector of Euler angles.
///
/// The specified rotation order defines the sequence in which the rotations
/// are applied about the principal axes.
///
/// - Parameters:
///   - order: The order the rotations are applied.
///
/// - Returns: The rotation expressed as Euler angles.
///
	public func toEulerRotation(order: RotationOrder) -> Quaternion<Component>.Rotation {
		rotation.toRotation(order: order)
	}

/// Sets the encoded rotation from a vector of Euler angles.
///
/// The specified rotation order defines the sequence in which the rotations
/// are applied about the principal axes.
///
/// - Parameters:
///   - rotation: The rotation, expressed as Euler angles.
///   - order: The order to apply the rotations.
///
	public mutating func fromEulerRotation(_ rotation: Quaternion<Component>.Rotation, order: RotationOrder) {
		self.rotation = Quaternion(withRotation: rotation, order: order)
	}
}
