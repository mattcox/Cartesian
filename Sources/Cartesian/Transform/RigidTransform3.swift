//
//  RigidTransform33.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import RealModule

/// A rigid transformation within a three-dimensional Cartesian coordinate
/// space.
///
/// A rigid transform encodes a rotation followed by a translation. It preserves
/// distances, angles and handedness, making it well suited to describing the
/// pose of an object, camera or coordinate frame. As it introduces no scaling
/// or shearing, a rigid transform is a member of a closed group: composing two
/// rigid transforms produces another rigid transform, and its inverse is always
/// a rigid transform that can be computed exactly and cheaply.
///
/// The transform is stored internally as a unit ``Quaternion`` and a
/// translation vector. The equivalent affine ``matrix``, and the rotation as
/// Euler angles, are derived on demand and are independent of this internal
/// representation.
///
public struct RigidTransform3<Component: Real & SIMDScalar> {
/// The rotation encoded by the transform, expressed as a unit quaternion.
///
	public var rotation: Quaternion<Component>

/// The translation encoded by the transform.
///
	public var translation: Vector3<Component>

/// Initialize a rigid transform from a rotation and a translation.
///
/// - Parameters:
///   - rotation: The rotation encoded by the transform. This is expected to
///   be a unit quaternion.
///   - translation: The translation encoded by the transform.
///
	@inlinable
	public init(rotation: Quaternion<Component>, translation: Vector3<Component>) {
		self.rotation = rotation
		self.translation = translation
	}
}

extension RigidTransform3 {
/// Initialize a rigid transform encoding only a rotation.
///
/// - Parameters:
///   - rotation: The rotation encoded by the transform. This is expected to
///   be a unit quaternion.
///
	@inlinable
	public init(rotation: Quaternion<Component>) {
		self.init(rotation: rotation, translation: .zero)
	}

/// Initialize a rigid transform encoding only a translation.
///
/// - Parameters:
///   - translation: The translation encoded by the transform.
///
	@inlinable
	public init(translation: Vector3<Component>) {
		self.init(rotation: .identity, translation: translation)
	}
}

extension RigidTransform3: TransformProtocol {
	public typealias Matrix = Matrix4x4<Component>
	public typealias Vector = Vector3<Component>

	@inlinable
	public init() {
		self.init(rotation: .identity, translation: .zero)
	}

	@inlinable
	public var matrix: Matrix4x4<Component> {
		var matrix = Matrix4x4(withQuaternion: rotation)
		matrix.translation = translation
		return matrix
	}

/// Apply the transform to a position, rotating it and then translating it.
///
/// - Parameters:
///   - position: The position to transform.
///
/// - Returns: The transformed position.
///
	@inlinable
	public func apply(to position: Vector3<Component>) -> Vector3<Component> {
		rotation.rotate(vector: position) + translation
	}

/// Concatenate this transform with another rigid transform, returning the
/// combined transform.
///
/// The transforms are combined such that the resulting transform is
/// equivalent to applying `other` first, followed by `self`.
///
/// - Parameters:
///   - other: The transform to concatenate with this transform.
///
/// - Returns: The combined rigid transform.
///
	@inlinable
	public func concatenated(with other: RigidTransform3) -> RigidTransform3 {
		RigidTransform3(
			rotation: rotation * other.rotation,
			translation: rotation.rotate(vector: other.translation) + translation
		)
	}
}

extension RigidTransform3: Transform3Protocol {

}

extension RigidTransform3: TranslatableTransform {

}

extension RigidTransform3: RotatableTransform {

}

extension RigidTransform3: Identity {
/// The identity rigid transform, encoding no rotation and no translation.
///
	@inlinable
	public static var identity: Self {
		Self(rotation: .identity, translation: .zero)
	}

	@inlinable
	public var isIdentity: Bool {
		rotation.isIdentity && translation == .zero
	}

	@inlinable
	public mutating func toIdentity() {
		self = .identity
	}
}

extension RigidTransform3: Invertible {
/// The inverse of the rigid transform.
///
/// The inverse rotation is the conjugate of the rotation, and the inverse
/// translation is the original translation rotated by that conjugate and
/// negated. A rigid transform is always invertible, so this never returns
/// `nil`.
///
	@inlinable
	public var inverse: Self? {
		let inverseRotation = rotation.conjugate
		return Self(
			rotation: inverseRotation,
			translation: -inverseRotation.rotate(vector: translation)
		)
	}

	@inlinable
	public mutating func invert() -> Bool {
		guard let inverse else {
			return false
		}
		self = inverse
		return true
	}
}

extension RigidTransform3: Equatable {

}

extension RigidTransform3: Codable {

}

extension RigidTransform3: Sendable where Quaternion<Component>: Sendable, Vector3<Component>: Sendable {

}

extension RigidTransform3: CustomStringConvertible where Component: CVarArg {
	public var description: String {
		"RigidTransform3(rotation: \(rotation), translation: \(translation))"
	}
}

extension RigidTransform3: Hashable {

}

extension RigidTransform3: Blendable {
	@inlinable
	public static func blend(from: Self, to: Self, by amount: Component) -> Self {
		Self(
			rotation: Quaternion<Component>.slerp(from: from.rotation, to: to.rotation, by: amount),
			translation: Vector3<Component>.blend(from: from.translation, to: to.translation, by: amount)
		)
	}

	@inlinable
	public mutating func blend(to other: Self, by amount: Component) {
		self = Self.blend(from: self, to: other, by: amount)
	}
}
