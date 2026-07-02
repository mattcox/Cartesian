//
//  AffineTransform2.swift
//  Cartesian
//
//  Created by Matt Cox on 02/07/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import RealModule
import Units

/// An affine transformation within a two-dimensional Cartesian coordinate
/// space.
///
/// An affine transform is the most general class of transform in the library,
/// encoding translation, rotation, non-uniform scale and shear. Because it can
/// represent shear - which cannot be captured by an independent rotation and
/// scale - it is stored directly as an affine ``MatrixAffine3x3`` rather than
/// as decomposed components. Affine transforms are closed under composition and
/// inversion, and serve as the common representation when combining transforms
/// of differing classes.
///
/// The translation, rotation and scale are read and written directly on the
/// underlying matrix.
///
public struct AffineTransform2<Component: Real & SIMDScalar & BinaryFloatingPoint> {
/// The affine matrix representation of the transform.
///
	public private(set) var matrix: MatrixAffine3x3<Component>

/// Initialize an affine transform from an affine matrix.
///
/// - Parameters:
///   - matrix: The affine matrix encoding the transform.
///
	public init(matrix: MatrixAffine3x3<Component>) {
		self.matrix = matrix
	}
}

extension AffineTransform2 {
/// Initialize an affine transform encoding only a translation.
///
/// - Parameters:
///   - translation: The translation encoded by the transform.
///
	public init(translation: Vector2<Component>) {
		self.init(matrix: MatrixAffine3x3(translation: translation))
	}

/// Initialize an affine transform encoding only a rotation.
///
/// - Parameters:
///   - rotation: The rotation encoded by the transform.
///
	public init(rotation: Angle<Component>) {
		self.init(matrix: MatrixAffine3x3(rotation: rotation))
	}

/// Initialize an affine transform encoding only a scale in each axis.
///
/// - Parameters:
///   - scale: The scale encoded by the transform along each axis.
///
	public init(scale: Vector2<Component>) {
		self.init(matrix: MatrixAffine3x3(scale: scale))
	}
}

extension AffineTransform2: TransformProtocol {
	public typealias Matrix = MatrixAffine3x3<Component>
	public typealias Vector = Vector2<Component>

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
	public func apply(to position: Vector2<Component>) -> Vector2<Component> {
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
	public func concatenated(with other: AffineTransform2) -> AffineTransform2 {
		AffineTransform2(matrix: matrix * other.matrix)
	}
}

extension AffineTransform2: Transform2Protocol {

}

extension AffineTransform2: TranslatableTransform {
	public var translation: Vector2<Component> {
		get {
			matrix.translation
		}
		set {
			matrix.translation = newValue
		}
	}
}

extension AffineTransform2: ScalableTransform {
	public var scale: Vector2<Component> {
		get {
			matrix.scale
		}
		set {
			matrix.scale = newValue
		}
	}
}

extension AffineTransform2: RotatableTransform {
	public var rotation: Angle<Component> {
		get {
			matrix.rotation
		}
		set {
			matrix.rotation = newValue
		}
	}
}

extension AffineTransform2: Identity {
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

extension AffineTransform2: Invertible {
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

extension AffineTransform2: Equatable {

}

extension AffineTransform2: Hashable {

}

extension AffineTransform2: Codable {

}

extension AffineTransform2: Sendable where MatrixAffine3x3<Component>: Sendable {

}

extension AffineTransform2: CustomStringConvertible where Component: CVarArg {
	public var description: String {
		"AffineTransform2(\(matrix))"
	}
}
