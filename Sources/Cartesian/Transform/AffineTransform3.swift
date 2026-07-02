//
//  AffineTransform3.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import RealModule

/// An affine transformation within a three-dimensional Cartesian coordinate
/// space.
///
/// An affine transform is the most general class of transform in the library,
/// encoding translation, rotation, non-uniform scale and shear. Because it can
/// represent shear - which cannot be captured by an independent rotation and
/// scale - it is stored directly as an affine ``Matrix4x4`` rather than as
/// decomposed components. Affine transforms are closed under composition and
/// inversion, and serve as the common representation when combining transforms
/// of differing classes.
///
/// The translation and scale are read and written directly on the underlying
/// matrix. The rotation is derived by removing the scale from the matrix, and
/// setting it rebuilds the matrix from the translation, rotation and scale;
/// any shear present in the matrix is not preserved when the rotation is set.
///
public struct AffineTransform3<Component: Real & SIMDScalar> {
/// The affine matrix representation of the transform.
///
	public private(set) var matrix: Matrix4x4<Component>

/// Initialize an affine transform from an affine matrix.
///
/// - Parameters:
///   - matrix: The affine matrix encoding the transform.
///
	public init(matrix: Matrix4x4<Component>) {
		self.matrix = matrix
	}
}

extension AffineTransform3 {
/// Initialize an affine transform encoding only a translation.
///
/// - Parameters:
///   - translation: The translation encoded by the transform.
///
	public init(translation: Vector3<Component>) {
		self.init(matrix: Matrix4x4(withTranslation: translation))
	}

/// Initialize an affine transform encoding only a rotation.
///
/// - Parameters:
///   - rotation: The rotation encoded by the transform. This is expected to
///   be a unit quaternion.
///
	public init(rotation: Quaternion<Component>) {
		self.init(matrix: Matrix4x4(withQuaternion: rotation))
	}

/// Initialize an affine transform encoding only a scale in each axis.
///
/// - Parameters:
///   - scale: The scale encoded by the transform along each axis.
///
	public init(scale: Vector3<Component>) {
		self.init(matrix: Matrix4x4(withScale: scale))
	}
}

extension AffineTransform3: TransformProtocol {
	public typealias Matrix = Matrix4x4<Component>
	public typealias Vector = Vector3<Component>

	public init() {
		self.init(matrix: .identity)
	}

/// Apply the transform to a position, returning the transformed position.
///
/// - Parameters:
///   - position: The position to transform.
///
/// - Returns: The transformed position.
///
	public func apply(to position: Vector3<Component>) -> Vector3<Component> {
		matrix.transform(point: position)
	}

/// Concatenate this transform with another affine transform, returning the
/// combined transform.
///
/// The transforms are combined such that the resulting transform is
/// equivalent to applying `other` first, followed by `self`.
///
/// - Parameters:
///   - other: The transform to concatenate with this transform.
///
/// - Returns: The combined affine transform.
///
	public func concatenated(with other: AffineTransform3) -> AffineTransform3 {
		AffineTransform3(matrix: matrix * other.matrix)
	}
}

extension AffineTransform3: Transform3Protocol {

}

extension AffineTransform3: TranslatableTransform {
	public var translation: Vector3<Component> {
		get {
			matrix.translation
		}
		set {
			matrix.translation = newValue
		}
	}
}

extension AffineTransform3: ScalableTransform {
	public var scale: Vector3<Component> {
		get {
			matrix.scale
		}
		set {
			matrix.scale = newValue
		}
	}
}

extension AffineTransform3: RotatableTransform {
	public var rotation: Quaternion<Component> {
		get {
			var normalized = matrix
			normalized.scale = Vector3(1, 1, 1)
			return normalized.quaternion
		}
		set {
			let scale = matrix.scale
			let translation = matrix.translation
			var rebuilt = Matrix4x4(withQuaternion: newValue)
			rebuilt.scale = scale
			rebuilt.translation = translation
			matrix = rebuilt
		}
	}
}

extension AffineTransform3: Identity {
/// The identity affine transform, encoding no transformation.
///
	public static var identity: Self {
		Self(matrix: .identity)
	}

	public var isIdentity: Bool {
		matrix.isIdentity
	}

	public mutating func toIdentity() {
		matrix = .identity
	}
}

extension AffineTransform3: Invertible {
/// The inverse of the affine transform, or `nil` if the transform is
/// singular.
///
	public var inverse: Self? {
		guard let inverse = matrix.inverse else {
			return nil
		}
		return Self(matrix: inverse)
	}

	public mutating func invert() -> Bool {
		guard let inverse else {
			return false
		}
		self = inverse
		return true
	}
}

extension AffineTransform3: Equatable {

}

extension AffineTransform3: Hashable {

}

extension AffineTransform3: Codable {

}

extension AffineTransform3: Sendable where Matrix4x4<Component>: Sendable {

}

extension AffineTransform3: CustomStringConvertible where Component: CVarArg {
	public var description: String {
		"AffineTransform3(\(matrix))"
	}
}
