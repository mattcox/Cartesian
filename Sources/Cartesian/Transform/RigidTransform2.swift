//
//  RigidTransform2.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import RealModule
import Units

/// A rigid transformation within a two-dimensional Cartesian coordinate space.
///
/// A rigid transform encodes a rotation followed by a translation. It preserves
/// distances, angles and handedness, making it well suited to describing the
/// pose of an object or coordinate frame in the plane. As it introduces no
/// scaling or shearing, a rigid transform is a member of a closed group:
/// composing two rigid transforms produces another rigid transform, and its
/// inverse is always a rigid transform that can be computed exactly and
/// cheaply.
///
/// The transform is stored internally as an ``Angle`` and a translation vector.
/// The equivalent affine ``matrix`` is derived on demand and is independent of
/// this internal representation.
///
public struct RigidTransform2<Component: Real & SIMDScalar & BinaryFloatingPoint> {
/// The rotation encoded by the transform.
///
	public var rotation: Angle<Component>

/// The translation encoded by the transform.
///
	public var translation: Vector2<Component>

/// Initialize a rigid transform from a rotation and a translation.
///
/// - Parameters:
///   - rotation: The rotation encoded by the transform.
///   - translation: The translation encoded by the transform.
///
	public init(rotation: Angle<Component>, translation: Vector2<Component>) {
		self.rotation = rotation
		self.translation = translation
	}
}

extension RigidTransform2 {
/// Initialize a rigid transform encoding only a rotation.
///
/// - Parameters:
///   - rotation: The rotation encoded by the transform.
///
	public init(rotation: Angle<Component>) {
		self.init(rotation: rotation, translation: .zero)
	}

/// Initialize a rigid transform encoding only a translation.
///
/// - Parameters:
///   - translation: The translation encoded by the transform.
///
	public init(translation: Vector2<Component>) {
		self.init(rotation: Angle(radians: 0), translation: translation)
	}
}

extension RigidTransform2: TransformProtocol {
	public typealias Matrix = MatrixAffine3x3<Component>
	public typealias Vector = Vector2<Component>

	public init() {
		self.init(rotation: Angle(radians: 0), translation: .zero)
	}

	public var matrix: MatrixAffine3x3<Component> {
		var matrix = MatrixAffine3x3(rotation: rotation)
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
	public func apply(to position: Vector2<Component>) -> Vector2<Component> {
		let cos = Component.cos(rotation.radians)
		let sin = Component.sin(rotation.radians)
		let x = position[0] * cos - position[1] * sin + translation.x
		let y = position[0] * sin + position[1] * cos + translation.y
		return Vector2(x: x, y: y)
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
	public func concatenated(with other: RigidTransform2) -> RigidTransform2 {
		let cos = Component.cos(rotation.radians)
		let sin = Component.sin(rotation.radians)
		let x = other.translation.x * cos - other.translation.y * sin + translation.x
		let y = other.translation.x * sin + other.translation.y * cos + translation.y
		return RigidTransform2(
			rotation: Angle(radians: rotation.radians + other.rotation.radians),
			translation: Vector2(x: x, y: y)
		)
	}
}

extension RigidTransform2: Transform2Protocol {

}

extension RigidTransform2: TranslatableTransform {

}

extension RigidTransform2: RotatableTransform {

}

extension RigidTransform2: Identity {
/// The identity rigid transform, encoding no rotation and no translation.
///
	public static var identity: Self {
		Self(rotation: Angle(radians: 0), translation: .zero)
	}

	public var isIdentity: Bool {
		rotation.radians.isApproximatelyEqual(to: .zero) && translation == .zero
	}

	public mutating func toIdentity() {
		self = .identity
	}
}

extension RigidTransform2: Invertible {
/// The inverse of the rigid transform.
///
/// The inverse rotation is the negation of the rotation, and the inverse
/// translation is the original translation rotated by that negated rotation
/// and negated. A rigid transform is always invertible, so this never returns
/// `nil`.
///
	public var inverse: Self? {
		let cos = Component.cos(rotation.radians)
		let sin = Component.sin(rotation.radians)
		let x = translation.x * cos + translation.y * sin
		let y = -translation.x * sin + translation.y * cos
		return Self(
			rotation: Angle(radians: -rotation.radians),
			translation: Vector2(x: -x, y: -y)
		)
	}

	public mutating func invert() -> Bool {
		guard let inverse else {
			return false
		}
		self = inverse
		return true
	}
}

extension RigidTransform2: Equatable {

}

extension RigidTransform2: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(rotation.radians)
		hasher.combine(translation)
	}
}

extension RigidTransform2: Codable {

}

extension RigidTransform2: Sendable where Angle<Component>: Sendable, Vector2<Component>: Sendable {

}

extension RigidTransform2: CustomStringConvertible where Component: CVarArg {
	public var description: String {
		"RigidTransform2(rotation: \(rotation.radians), translation: \(translation))"
	}
}

extension RigidTransform2: Blendable {
	public static func blend(from: Self, to: Self, by amount: Component) -> Self {
		let delta = to.rotation.radians - from.rotation.radians
		let shortest = Component.atan2(y: Component.sin(delta), x: Component.cos(delta))
		return Self(
			rotation: Angle(radians: from.rotation.radians + shortest * amount),
			translation: Vector2<Component>.blend(from: from.translation, to: to.translation, by: amount)
		)
	}

	public mutating func blend(to other: Self, by amount: Component) {
		self = Self.blend(from: self, to: other, by: amount)
	}
}
