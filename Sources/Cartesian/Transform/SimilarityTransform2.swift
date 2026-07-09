//
//  SimilarityTransform2.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import RealModule
import Units

/// A similarity transformation within a two-dimensional Cartesian coordinate
/// space.
///
/// A similarity transform encodes a uniform scale, followed by a rotation, then
/// a translation. It preserves angles and shape, scaling everything by a single
/// factor, making it well suited to placing objects at differing sizes without
/// introducing shear. Like a rigid transform, a similarity transform is a
/// member of a closed group: composing two similarity transforms produces
/// another similarity transform, and its inverse can be computed exactly.
///
/// The transform is stored internally as an ``Angle``, a translation vector and
/// a uniform scale factor. The equivalent affine ``matrix`` is derived on
/// demand and is independent of this internal representation.
///
public struct SimilarityTransform2<Component: Real & SIMDScalar & BinaryFloatingPoint> {
/// The rotation encoded by the transform.
///
	public var rotation: Angle<Component>

/// The translation encoded by the transform.
///
	public var translation: Vector2<Component>

/// The uniform scale encoded by the transform.
///
	public var scale: Component

/// Initialize a similarity transform from a rotation, translation and uniform
/// scale.
///
/// - Parameters:
///   - rotation: The rotation encoded by the transform.
///   - translation: The translation encoded by the transform.
///   - scale: The uniform scale encoded by the transform.
///
	@inlinable
	public init(rotation: Angle<Component>, translation: Vector2<Component>, scale: Component) {
		self.rotation = rotation
		self.translation = translation
		self.scale = scale
	}
}

extension SimilarityTransform2: TransformProtocol {
	public typealias Matrix = MatrixAffine3x3<Component>
	public typealias Vector = Vector2<Component>

	@inlinable
	public init() {
		self.init(rotation: Angle(radians: 0), translation: .zero, scale: 1)
	}

	@inlinable
	public var matrix: MatrixAffine3x3<Component> {
		var matrix = MatrixAffine3x3(rotation: rotation)
		matrix.scale = Vector2(scale, scale)
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
	public func apply(to position: Vector2<Component>) -> Vector2<Component> {
		let cos = Component.cos(rotation.radians)
		let sin = Component.sin(rotation.radians)
		let x = (position[0] * cos - position[1] * sin) * scale + translation.x
		let y = (position[0] * sin + position[1] * cos) * scale + translation.y
		return Vector2(x: x, y: y)
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
	public func concatenated(with other: SimilarityTransform2) -> SimilarityTransform2 {
		let cos = Component.cos(rotation.radians)
		let sin = Component.sin(rotation.radians)
		let x = (other.translation.x * cos - other.translation.y * sin) * scale + translation.x
		let y = (other.translation.x * sin + other.translation.y * cos) * scale + translation.y
		return SimilarityTransform2(
			rotation: Angle(radians: rotation.radians + other.rotation.radians),
			translation: Vector2(x: x, y: y),
			scale: scale * other.scale
		)
	}
}

extension SimilarityTransform2: Transform2Protocol {

}

extension SimilarityTransform2: TranslatableTransform {

}

extension SimilarityTransform2: RotatableTransform {

}

extension SimilarityTransform2: ScalableTransform {

}

extension SimilarityTransform2: Identity {
/// The identity similarity transform, encoding no rotation, no translation
/// and a unit scale.
///
	@inlinable
	public static var identity: Self {
		Self(rotation: Angle(radians: 0), translation: .zero, scale: 1)
	}

	@inlinable
	public var isIdentity: Bool {
		rotation.radians.isApproximatelyEqual(to: .zero) && translation == .zero && scale.isApproximatelyEqual(to: 1)
	}

	@inlinable
	public mutating func toIdentity() {
		self = .identity
	}
}

extension SimilarityTransform2: Invertible {
/// The inverse of the similarity transform, or `nil` if the scale is zero.
///
	@inlinable
	public var inverse: Self? {
		guard !scale.isApproximatelyEqual(to: .zero) else {
			return nil
		}
		let inverseScale = 1 / scale
		let cos = Component.cos(rotation.radians)
		let sin = Component.sin(rotation.radians)
		let x = (translation.x * cos + translation.y * sin) * -inverseScale
		let y = (-translation.x * sin + translation.y * cos) * -inverseScale
		return Self(
			rotation: Angle(radians: -rotation.radians),
			translation: Vector2(x: x, y: y),
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

extension SimilarityTransform2: Equatable {

}

extension SimilarityTransform2: Hashable {
	@inlinable
	public func hash(into hasher: inout Hasher) {
		hasher.combine(rotation.radians)
		hasher.combine(translation)
		hasher.combine(scale)
	}
}

extension SimilarityTransform2: Codable {

}

extension SimilarityTransform2: Sendable where Angle<Component>: Sendable, Vector2<Component>: Sendable, Component: Sendable {

}

extension SimilarityTransform2: CustomStringConvertible where Component: CVarArg {
	public var description: String {
		"SimilarityTransform2(rotation: \(rotation.radians), translation: \(translation), scale: \(scale))"
	}
}

extension SimilarityTransform2: Blendable {
	@inlinable
	public static func blend(from: Self, to: Self, by amount: Component) -> Self {
		let delta = to.rotation.radians - from.rotation.radians
		let shortest = Component.atan2(y: Component.sin(delta), x: Component.cos(delta))
		return Self(
			rotation: Angle(radians: from.rotation.radians + shortest * amount),
			translation: Vector2<Component>.blend(from: from.translation, to: to.translation, by: amount),
			scale: from.scale + (to.scale - from.scale) * amount
		)
	}

	@inlinable
	public mutating func blend(to other: Self, by amount: Component) {
		self = Self.blend(from: self, to: other, by: amount)
	}
}
