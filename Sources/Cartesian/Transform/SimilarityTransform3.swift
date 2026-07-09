//
//  SimilarityTransform3.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import RealModule

/// A similarity transformation within a three-dimensional Cartesian coordinate
/// space.
///
/// A similarity transform encodes a uniform scale, followed by a rotation, then
/// a translation. It preserves angles and shape, scaling everything by a single
/// factor, making it well suited to placing objects at differing sizes without
/// introducing shear. Like a rigid transform, a similarity transform is a
/// member of a closed group: composing two similarity transforms produces
/// another similarity transform, and its inverse can be computed exactly.
///
/// The transform is stored internally as a unit ``Quaternion``, a translation
/// vector and a uniform scale factor. The equivalent affine ``matrix``, and the
/// rotation as Euler angles, are derived on demand and are independent of this
/// internal representation.
///
public struct SimilarityTransform3<Component: Real & SIMDScalar> {
/// The rotation encoded by the transform, expressed as a unit quaternion.
///
	public var rotation: Quaternion<Component>

/// The translation encoded by the transform.
///
	public var translation: Vector3<Component>

/// The uniform scale encoded by the transform.
///
	public var scale: Component

/// Initialize a similarity transform from a rotation, translation and uniform
/// scale.
///
/// - Parameters:
///   - rotation: The rotation encoded by the transform. This is expected to
///   be a unit quaternion.
///   - translation: The translation encoded by the transform.
///   - scale: The uniform scale encoded by the transform.
///
	@inlinable
	public init(rotation: Quaternion<Component>, translation: Vector3<Component>, scale: Component) {
		self.rotation = rotation
		self.translation = translation
		self.scale = scale
	}
}

extension SimilarityTransform3: TransformProtocol {
	public typealias Matrix = Matrix4x4<Component>
	public typealias Vector = Vector3<Component>

	@inlinable
	public init() {
		self.init(rotation: .identity, translation: .zero, scale: 1)
	}

	@inlinable
	public var matrix: Matrix4x4<Component> {
		var matrix = Matrix4x4(withQuaternion: rotation)
		matrix.scale = Vector3(scale, scale, scale)
		matrix.translation = translation
		return matrix
	}

/// Apply the transform to a position, scaling it, then rotating it, then
/// translating it.
///
/// - Parameters:
///   - position: The position to transform.
///
/// - Returns: The transformed position.
///
	@inlinable
	public func apply(to position: Vector3<Component>) -> Vector3<Component> {
		(rotation.rotate(vector: position) * scale) + translation
	}

/// Concatenate this transform with another similarity transform, returning
/// the combined transform.
///
/// The transforms are combined such that the resulting transform is
/// equivalent to applying `other` first, followed by `self`.
///
/// - Parameters:
///   - other: The transform to concatenate with this transform.
///
/// - Returns: The combined similarity transform.
///
	@inlinable
	public func concatenated(with other: SimilarityTransform3) -> SimilarityTransform3 {
		SimilarityTransform3(
			rotation: rotation * other.rotation,
			translation: (rotation.rotate(vector: other.translation) * scale) + translation,
			scale: scale * other.scale
		)
	}
}

extension SimilarityTransform3: Transform3Protocol {

}

extension SimilarityTransform3: TranslatableTransform {

}

extension SimilarityTransform3: RotatableTransform {

}

extension SimilarityTransform3: ScalableTransform {

}

extension SimilarityTransform3: Identity {
/// The identity similarity transform, encoding no rotation, no translation
/// and a unit scale.
///
	@inlinable
	public static var identity: Self {
		Self(rotation: .identity, translation: .zero, scale: 1)
	}

	@inlinable
	public var isIdentity: Bool {
		rotation.isIdentity && translation == .zero && scale.isApproximatelyEqual(to: 1)
	}

	@inlinable
	public mutating func toIdentity() {
		self = .identity
	}
}

extension SimilarityTransform3: Invertible {
/// The inverse of the similarity transform, or `nil` if the scale is zero.
///
	@inlinable
	public var inverse: Self? {
		guard !scale.isApproximatelyEqual(to: .zero) else {
			return nil
		}
		let inverseScale = 1 / scale
		let inverseRotation = rotation.conjugate
		return Self(
			rotation: inverseRotation,
			translation: inverseRotation.rotate(vector: translation) * (-inverseScale),
			scale: inverseScale
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

extension SimilarityTransform3: Equatable {

}

extension SimilarityTransform3: Hashable {

}

extension SimilarityTransform3: Codable {

}

extension SimilarityTransform3: Sendable where Quaternion<Component>: Sendable, Vector3<Component>: Sendable, Component: Sendable {

}

extension SimilarityTransform3: CustomStringConvertible where Component: CVarArg {
	public var description: String {
		"SimilarityTransform3(rotation: \(rotation), translation: \(translation), scale: \(scale))"
	}
}

extension SimilarityTransform3: Blendable {
	@inlinable
	public static func blend(from: Self, to: Self, by amount: Component) -> Self {
		Self(
			rotation: Quaternion<Component>.slerp(from: from.rotation, to: to.rotation, by: amount),
			translation: Vector3<Component>.blend(from: from.translation, to: to.translation, by: amount),
			scale: from.scale + (to.scale - from.scale) * amount
		)
	}

	@inlinable
	public mutating func blend(to other: Self, by amount: Component) {
		self = Self.blend(from: self, to: other, by: amount)
	}
}
