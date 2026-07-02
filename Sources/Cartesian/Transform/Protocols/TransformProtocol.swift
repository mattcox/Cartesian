//
//  TransformProtocol.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A type that represents a transformation within a Cartesian coordinate
/// space.
///
/// A transform maps positions from one coordinate space into another, and can
/// be composed with other transforms and applied to vectors. Conforming types
/// describe a specific class of transformation - such as rigid, similarity or
/// affine - where the class determines which effects (translation, rotation,
/// scaling or shearing) the transform is able to represent.
///
/// Regardless of how a transform stores its components internally, it can
/// always be expressed as an equivalent affine ``matrix``. This provides
/// interoperability with matrix based APIs, and a common representation when
/// composing transforms of differing classes.
///
public protocol TransformProtocol: Identity, Invertible {
/// The scalar type used for specifying the transform components.
///
	associatedtype Component: Numeric

/// The matrix type used to represent this transform.
///
/// Every transform can be expressed as an equivalent matrix, which provides a
/// common representation for interoperability and a fallback when composing
/// transforms of differing classes. The specific matrix type - and its
/// dimensionality - is fixed by the conforming type; two-dimensional
/// transforms use a homogeneous ``MatrixAffine3x3`` while three-dimensional
/// transforms use a ``Matrix4x4``.
///
	associatedtype Matrix: MatrixProtocol where Matrix.Component == Component

/// The vector type describing a position that the transform can be applied
/// to.
///
	associatedtype Vector: VectorProtocol where Vector.Component == Component

/// Initialize an identity transform.
///
	init()

/// The equivalent affine matrix representation of this transform.
///
	var matrix: Matrix { get }

/// Apply the transform to a position, returning the transformed position.
///
/// - Parameters:
///   - position: The position to transform.
///
/// - Returns: The transformed position.
///
	func apply(to position: Vector) -> Vector

/// Concatenate this transform with another transform of the same class,
/// returning the combined transform.
///
/// The transforms are combined such that the resulting transform is
/// equivalent to applying `other` first, followed by `self`.
///
/// - Parameters:
///   - other: The transform to concatenate with this transform.
///
/// - Returns: The combined transform, of the same class as its operands.
///
	func concatenated(with other: Self) -> Self
}
