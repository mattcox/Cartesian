//
//  MatrixAffine3x3.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import RealModule
import Units

/// A two-dimensional affine transformation matrix, stored as a 3×3 homogeneous
/// matrix in column-major order.
///
/// MatrixAffine3x3 represents affine transformations of the two-dimensional plane
/// - translation, rotation, scaling and shearing - using homogeneous
/// coordinates. The transformation is laid out as:
/// ```
/// | m00  m01  tx |
/// | m10  m11  ty |
/// |   0    0   1 |
/// ```
/// where the upper-left 2×2 block encodes the linear part and the final column
/// encodes the translation. The bottom row is fixed at `[0, 0, 1]` to preserve
/// the affine invariant.
///
/// Unlike ``Matrix3x3``, which interprets a 3×3 matrix as a *linear* transform
/// in three-dimensional space, MatrixAffine3x3 interprets the same storage as an
/// *affine* transform of the two-dimensional plane, exposing translation,
/// rotation and scale in two dimensions.
///
public struct MatrixAffine3x3<Component: Real & SIMDScalar> {
/// The underlying 3×3 storage backing the affine matrix.
///
	private var storage: Matrix3x3<Component>

/// Initialize the affine matrix from its backing storage.
///
	private init(storage: Matrix3x3<Component>) {
		self.storage = storage
	}
}

extension MatrixAffine3x3 {
/// The translation encoded by the matrix.
///
	public var translation: Vector2<Component> {
		get {
			Vector2(x: storage[2, 0], y: storage[2, 1])
		}
		set {
			storage[2, 0] = newValue.x
			storage[2, 1] = newValue.y
		}
	}

/// The scale encoded by the matrix, derived from the magnitude of the linear
/// columns.
///
/// Setting the scale preserves the direction of each linear column while
/// resizing it to the requested magnitude. Columns with a magnitude of zero
/// remain zero.
///
	public var scale: Vector2<Component> {
		get {
			let x = Component.sqrt(storage[0, 0] * storage[0, 0] + storage[0, 1] * storage[0, 1])
			let y = Component.sqrt(storage[1, 0] * storage[1, 0] + storage[1, 1] * storage[1, 1])
			return Vector2(x: x, y: y)
		}
		set {
			let current = scale
			if !current.x.isApproximatelyEqual(to: .zero) {
				let ratio = newValue.x / current.x
				storage[0, 0] *= ratio
				storage[0, 1] *= ratio
			}
			if !current.y.isApproximatelyEqual(to: .zero) {
				let ratio = newValue.y / current.y
				storage[1, 0] *= ratio
				storage[1, 1] *= ratio
			}
		}
	}

/// Initialize an affine matrix encoding a translation.
///
/// - Parameters:
///   - translation: The translation to encode.
///
	public init(translation: Vector2<Component>) {
		var storage = Matrix3x3<Component>.identity
		storage[2, 0] = translation.x
		storage[2, 1] = translation.y
		self.init(storage: storage)
	}

/// Initialize an affine matrix encoding a scale in each axis.
///
/// - Parameters:
///   - scale: The scale to encode along each axis.
///
	public init(scale: Vector2<Component>) {
		var storage = Matrix3x3<Component>.identity
		storage[0, 0] = scale.x
		storage[1, 1] = scale.y
		self.init(storage: storage)
	}

/// Initialize an affine matrix encoding a uniform scale.
///
/// - Parameters:
///   - scale: The uniform scale to encode along both axes.
///
	public init(scale: Component) {
		self.init(scale: Vector2(x: scale, y: scale))
	}
}

extension MatrixAffine3x3 {
/// Transform a point by the affine matrix, returning the transformed point.
///
/// The point is extended to homogeneous coordinates with a `z` component of
/// `1`, so the transformation includes the translation encoded by the matrix.
///
/// - Parameters:
///   - point: The point to transform.
///
/// - Returns: The transformed point.
///
	public func transform(point: Point2<Component>) -> Point2<Component> {
		let result = self * Vector3(point[0], point[1], 1)
		return Point2(x: result[0], y: result[1])
	}

/// Transform a direction by the affine matrix, returning the transformed
/// direction.
///
/// The direction is extended to homogeneous coordinates with a `z` component
/// of `0`, so the transformation applies rotation, scale and shear but ignores
/// the translation encoded by the matrix. The result is not normalized; any
/// scale or shear encoded by the matrix affects its magnitude.
///
/// - Parameters:
///   - direction: The direction to transform.
///
/// - Returns: The transformed direction.
///
	public func transform(direction: Vector2<Component>) -> Vector2<Component> {
		let result = self * Vector3(direction[0], direction[1], 0)
		return Vector2(x: result[0], y: result[1])
	}
}

extension MatrixAffine3x3 where Component: BinaryFloatingPoint {
/// The rotation encoded by the matrix, derived from the orientation of the
/// first linear column.
///
/// Setting the rotation preserves the scale encoded in the matrix.
///
	public var rotation: Angle<Component> {
		get {
			Angle(radians: Component.atan2(y: storage[0, 1], x: storage[0, 0]))
		}
		set {
			let scale = self.scale
			let cos = Component.cos(newValue.radians)
			let sin = Component.sin(newValue.radians)
			storage[0, 0] = cos * scale.x
			storage[0, 1] = sin * scale.x
			storage[1, 0] = -sin * scale.y
			storage[1, 1] = cos * scale.y
		}
	}

/// Initialize an affine matrix encoding a rotation.
///
/// - Parameters:
///   - rotation: The rotation to encode.
///
	public init(rotation: Angle<Component>) {
		let cos = Component.cos(rotation.radians)
		let sin = Component.sin(rotation.radians)
		var storage = Matrix3x3<Component>.identity
		storage[0, 0] = cos
		storage[0, 1] = sin
		storage[1, 0] = -sin
		storage[1, 1] = cos
		self.init(storage: storage)
	}
}

extension MatrixAffine3x3 {
/// Concatenate two affine matrices, returning the combined transform.
///
/// - Parameters:
///   - lhs: The first affine matrix in the composition.
///   - rhs: The second affine matrix in the composition.
///
/// - Returns: The combined affine matrix.
///
	public static func * (lhs: Self, rhs: Self) -> Self {
		Self(storage: lhs.storage * rhs.storage)
	}

/// Concatenate two affine matrices, mutating the first.
///
/// - Parameters:
///   - lhs: The first affine matrix. This will be updated with the result.
///   - rhs: The second affine matrix.
///
	public static func *= (lhs: inout Self, rhs: Self) {
		lhs.storage *= rhs.storage
	}
}

extension MatrixAffine3x3: MatrixProtocol {
	public static var columns: Int {
		3
	}

	public static var rows: Int {
		3
	}

/// Initialize an identity affine matrix.
///
/// Unlike a general matrix, the natural empty state of an affine matrix is
/// the identity rather than a matrix of zeros, as a zero matrix does not
/// preserve the affine invariant.
///
	public init() {
		self.storage = .identity
	}

	public subscript(column: Int, row: Int) -> Component {
		get {
			storage[column, row]
		}
		set {
			storage[column, row] = newValue
		}
	}
}

extension MatrixAffine3x3: Identity {
/// The identity affine matrix, encoding no transformation.
///
	public static var identity: Self {
		Self(storage: .identity)
	}

	public var isIdentity: Bool {
		storage.isIdentity
	}

	public mutating func toIdentity() {
		storage = .identity
	}
}

extension MatrixAffine3x3: Invertible {
/// The inverse of the affine matrix, or `nil` if the matrix is singular.
///
	public var inverse: Self? {
		guard let inverse = storage.inverse else {
			return nil
		}
		return Self(storage: inverse)
	}

	public mutating func invert() -> Bool {
		guard let inverse else {
			return false
		}
		self = inverse
		return true
	}
}

extension MatrixAffine3x3 {
/// The determinant of the affine matrix.
///
/// For an affine matrix this is equal to the determinant of the linear
/// portion, describing the signed factor by which the transform scales area.
/// A determinant of zero indicates the matrix is singular and cannot be
/// inverted.
///
	public var determinant: Component {
		storage.determinant
	}

/// The trace of the affine matrix, equal to the sum of the elements on its
/// main diagonal.
///
	public var trace: Component {
		storage.trace
	}
}

extension MatrixAffine3x3: MatrixVectorMath {
	public typealias Vector = Vector3<Component>

/// Multiply the affine matrix with a homogeneous vector, producing the
/// transformed vector.
///
/// The vector is a homogeneous representation of a point in the plane, where
/// a `z` component of `1` denotes a position and a `z` component of `0`
/// denotes a direction. For the common case of transforming a two-dimensional
/// point or direction, use ``transform(point:)`` or ``transform(direction:)``.
///
/// - Parameters:
///   - lhs: The affine matrix.
///   - rhs: The homogeneous vector to transform.
///
/// - Returns: The transformed homogeneous vector.
///
	public static func * (lhs: Self, rhs: Vector) -> Vector {
		lhs.storage * rhs
	}
}

extension MatrixAffine3x3: Equatable {

}

extension MatrixAffine3x3: Codable {
	public init(from decoder: Decoder) throws {
		self.storage = try Matrix3x3(from: decoder)
	}

	public func encode(to encoder: Encoder) throws {
		try storage.encode(to: encoder)
	}
}

extension MatrixAffine3x3: CustomStringConvertible where Component: CVarArg {
	public var description: String {
		storage.description
	}
}

extension MatrixAffine3x3: ExpressibleByArrayLiteral {
/// Initialize the affine matrix from an array literal.
///
/// The array is provided as rows describing the linear and translation
/// portion of the transform, and is transposed into the column-major storage
/// used by the matrix. Only the first two rows are read; the homogeneous
/// bottom row is fixed at `[0, 0, 1]` and any values provided for it are
/// ignored.
///
/// For example, the following matrix is as it appears visually:
/// ```swift
/// let matrix: MatrixAffine3x3 = [
///     [1.0, 0.0, 4.0],
///     [0.0, 1.0, 5.0]
/// ]
/// ```
///
	public init(arrayLiteral elements: [Component]...) {
		var matrix = Self()

		for y in 0..<min(2, elements.count) {
			for x in 0..<min(3, elements[y].count) {
				matrix[x, y] = elements[y][x]
			}
		}

		self = matrix
	}
}

extension MatrixAffine3x3: SIMDConvertible {
	public typealias SIMDRepresentation = Matrix3x3<Component>.SIMDRepresentation

	public init(_ simd: SIMDRepresentation) {
		self.storage = Matrix3x3(simd)
	}

	public var simd: SIMDRepresentation {
		get {
			storage.simd
		}
		set {
			storage.simd = newValue
		}
	}
}

extension MatrixAffine3x3: Sendable where SIMDRepresentation: Sendable {

}

extension MatrixAffine3x3: Hashable {
	public func hash(into hasher: inout Hasher) {
		for column in 0..<Self.columns {
			for row in 0..<Self.rows {
				hasher.combine(self[column, row])
			}
		}
	}
}
