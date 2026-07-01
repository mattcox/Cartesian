//
//  Matrix3x3.swift
//  Cartesian
//
//  Created by Matt Cox on 14/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import RealModule
import Units

/// A 3×3 matrix stored in column-major order.
///
/// Matrix3x3 represents a square matrix with 3 columns and 3 rows. The matrix
/// is stored in **column-major order**, meaning it consists of three column
/// vectors, each with three elements.
///
/// - Note: This matrix encodes scale and rotation, and is commonly used to
/// transform 3D vectors without translation. To include translation, use a ``Matrix4x4`` instead.
///
public struct Matrix3x3<Component: Real & SIMDScalar> {
/// The underlying storage type for the matrix.
///
/// This essentially provides a wrapper around the `Vector3` type, using a
/// vector per column.
///
	public struct Storage {
	/// Each column is stored a `Vector3`.
	///
		public typealias Column = Vector3<Component>
		
	/// The storage for this type is three columns, each with three
	/// components.
	///
		public var columns: (Column, Column, Column)
		
	/// Initialize an empty matrix.
	///
		internal init() {
			self.columns = (Column(), Column(), Column())
		}

	/// Initialize the matrix from three columns.
	///
	/// - Parameters:
	///   - first: The values to place in the first column.
	///   - second: The values to place in the second column.
	///   - third: The values to place in the third column.
	///
		internal init(_ first: Column, _ second: Column, _ third: Column) {
			self.columns = (first, second, third)
		}
		
	/// Get and set the matrix component at the specified column and row
	/// index.
	///
	/// - Parameters:
	///   - column: The index of the column to access.
	///   - row: The index of the row to access.
	///
	/// - Returns: The value at the specified column and row index.
	///
		internal subscript(column: Int, row: Int) -> Component {
			get {
				switch column {
					case 0:
						columns.0[row]
					case 1:
						columns.1[row]
					case 2:
						columns.2[row]
					default:
						preconditionFailure("Index out of range")
				}
			}
			set {
				switch column {
					case 0:
						columns.0[row] = newValue
					case 1:
						columns.1[row] = newValue
					case 2:
						columns.2[row] = newValue
					default:
						preconditionFailure("Index out of range")
				}
			}
		}
		
	/// Get and set the matrix column at the specified index.
	///
	/// - Parameters:
	///   - column: The index of the column to access.
	///
	/// - Returns: The column at the specified index.
	///
		internal subscript(column: Int) -> Column {
			get {
				switch column {
					case 0:
						columns.0
					case 1:
						columns.1
					case 2:
						columns.2
					default:
						preconditionFailure("Index out of range")
				}
			}
			set {
				switch column {
					case 0:
						columns.0 = newValue
					case 1:
						columns.1 = newValue
					case 2:
						columns.2 = newValue
					default:
						preconditionFailure("Index out of range")
				}
			}
		}
	}

	private var storage: SIMDRepresentation
	
/// Initialize the matrix from three columns.
///
/// - Parameters:
///   - first: The first column of values.
///   - second: The second column of values.
///   - third: The third column of values.
///
	public init(columns first: SIMDRepresentation.Column, _ second: SIMDRepresentation.Column, _ third: SIMDRepresentation.Column) {
		self.storage = SIMDRepresentation(first, second, third)
	}
	
/// Initialize the matrix from three rows.
///
/// - Parameters:
///   - first: The first row of values.
///   - second: The second row of values.
///   - third: The third row of values.
///
	public init(rows first: SIMDRepresentation.Column, _ second: SIMDRepresentation.Column, _ third: SIMDRepresentation.Column) {
		self = Self(SIMDRepresentation(first, second, third)).transposed
	}
}

extension Matrix3x3 {
/// Access a matrix column at a specified index.
///
/// - Parameters:
///   - column: The index of the column in the matrix.
///
	public subscript(column: Int) -> Storage.Column {
		get {
			storage[column]
		}
		set {
			storage[column] = newValue
		}
	}
}

extension Matrix3x3: Codable {
	public init(from decoder: Decoder) throws {
		let values = try Array<Component>(from: decoder)
		if values.count != (Self.columns * Self.rows) {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid number of values to decode"))
		}
		
		var storage = SIMDRepresentation()
		var count = 0
		for column in 0..<Self.columns{
			for row in 0..<Self.rows{
				storage[column, row] = values[count]
				count += 1
			}
		}
		
		self.storage = storage
	}

	public func encode(to encoder: Encoder) throws {
		var values = [Component]()
		for column in 0..<Self.columns{
			for row in 0..<Self.rows{
				let value = storage[column, row]
				values.append(value)
			}
		}
		
		try values.encode(to: encoder)
	}
}

extension Matrix3x3: CustomStringConvertible where Component: CVarArg {
	public var description: String {
		"""
		| \(String(format: "%.3f", storage[0, 0]))  \(String(format: "%.3f", storage[1, 0]))  \(String(format: "%.3f", storage[2, 0])) |
		| \(String(format: "%.3f", storage[0, 1]))  \(String(format: "%.3f", storage[1, 1]))  \(String(format: "%.3f", storage[2, 1])) |
		| \(String(format: "%.3f", storage[0, 2]))  \(String(format: "%.3f", storage[1, 2]))  \(String(format: "%.3f", storage[2, 2])) |
		"""
	}
}

extension Matrix3x3: Equatable {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.storage.columns.0 == rhs.storage.columns.0 &&
		lhs.storage.columns.1 == rhs.storage.columns.1 &&
		lhs.storage.columns.2 == rhs.storage.columns.2
	}
}

extension Matrix3x3: ExpressibleByArrayLiteral {
/// Initialize the matrix from an array literal.
///
/// The array is initialized as three rows, and then transposed into the
/// column-major storage used by the matrix.
///
/// For example, the following matrix is as it appears visually:
/// ```swift
/// let matrix: Matrix3x3 = [
///     [1.0, 2.0, 3.0],
///     [4.0, 5.0, 6.0],
///     [7.0, 8.0, 9.0]
/// ]
/// ```
/// But it is stored as three arrays representing the three column vectors:
/// ```swift
/// [1.0, 4.0, 7.0], [2.0, 5.0, 8.0], [3.0, 6.0, 9.0]
/// ```
///
	public init(arrayLiteral elements: [Component]...) {
		var matrix = Self()
		
		for x in 0..<min(Self.columns, elements.count) {
			for y in 0..<min(Self.rows, elements[x].count) {
				matrix[x, y] = elements[y][x]
			}
		}
		
		self = matrix
	}
}

extension Matrix3x3: Identity {
/// Creates an identity matrix.
///
/// An identity matrix is a matrix with 1 in the main diagonal, and 0
/// everywhere else. It acts as the multiplicative identity in matrix
/// operations, leaving other matrices unchanged when multiplied.
///
/// ```swift
/// | 1  0  0 |
/// | 0  1  0 |
/// | 0  0  1 |
/// ```
///
	public static var identity: Self {
		var matrix = Self()
		for i in 0..<Self.columns {
			matrix.storage[i, i] = 1
		}
		return matrix
	}
	
/// Returns true if the matrix is identity.
///
/// An identity matrix is a matrix with 1 in the main diagonal, and 0
/// everywhere else. It acts as the multiplicative identity in matrix
/// operations, leaving other matrices unchanged when multiplied.
///
/// ```swift
/// | 1  0  0 |
/// | 0  1  0 |
/// | 0  0  1 |
/// ```
///
	public var isIdentity: Bool {
		for column in 0..<Self.columns {
			for row in 0..<Self.rows {
				guard self.storage[column, row] == ((column == row) ? 1 : 0) else {
					return false
				}
			}
		}
		return true
	}
	
/// Sets the matrix to identity.
///
/// An identity matrix is a matrix with 1 in the main diagonal, and 0
/// everywhere else. It acts as the multiplicative identity in matrix
/// operations, leaving other matrices unchanged when multiplied.
///
/// ```swift
/// | 1  0  0 |
/// | 0  1  0 |
/// | 0  0  1 |
/// ```
///
	public mutating func toIdentity() {
		var matrix = Self()
		for column in 0..<Self.columns {
			for row in 0..<Self.rows {
				matrix.storage[column, row] = (column == row) ? 1 : 0
			}
		}
		self = matrix
	}
}

extension Matrix3x3: Invertible {
/// Gets the inverse of this matrix if it exists.
///
	public var inverse: Self? {
		let determinant = self.determinant
		guard (abs(determinant) < .zero) == false &&
			determinant.isApproximatelyEqual(to: .zero) == false
		else {
			return nil
		}
		
		let factors = (storage.columns.1.cross(storage.columns.2),
					   storage.columns.2.cross(storage.columns.0),
					   storage.columns.0.cross(storage.columns.1))
					   
		let inverse = (Vector3<Component>(factors.0.x, factors.1.x, factors.2.x),
					   Vector3<Component>(factors.0.y, factors.1.y, factors.2.y),
					   Vector3<Component>(factors.0.z, factors.1.z, factors.2.z))
					   
		return Matrix3x3(columns: inverse.0, inverse.1, inverse.2) * (1 / determinant)
	}
	
/// Inverts this matrix if it can be inverted, mutating the matrix.
///
/// - Returns: A boolean indicating if the matrix could be inverted.
///
	public mutating func invert() -> Bool {
		if let inverse = self.inverse {
			self.storage = inverse.storage
			return true
		}
		return false
	}
}

extension Matrix3x3: MatrixLinearTransform where Component: BinaryFloatingPoint {
	public typealias Rotation = Units.Rotation<SIMD3<Component>>
	public typealias Scale = Vector3<Component>
	
	public var scale: Scale {
		get {
			Scale(
				storage.columns.0.magnitude,
				storage.columns.1.magnitude,
				storage.columns.2.magnitude
			)
		}
		set {
			storage.columns.0 = storage.columns.0.normalized * newValue[0]
			storage.columns.1 = storage.columns.1.normalized * newValue[1]
			storage.columns.2 = storage.columns.2.normalized * newValue[2]
		}
	}
	
	public init(withRotation rotation: Rotation, order: RotationOrder) {
		var matrix = Self.identity
		matrix.fromRotation(rotation, order: order)
		self = matrix
	}
	
	public init(withScale scale: Component) {
		var matrix = Self()
		for i in 0..<Self.columns {
			matrix[i, i] = scale
		}
		self = matrix
	}
	
	public init(withScale scale: Scale) {
		var matrix = Self()
		for i in 0..<Self.columns {
			matrix[i, i] = scale[i]
		}
		self = matrix
	}
	
	public func toRotation(order: RotationOrder) -> Rotation {
		let normalized = Self(columns:
			self[0].normalized,
			self[1].normalized,
			self[2].normalized
		)

		let orders = [order[0].index, order[1].index, order[2].index]

		var rotation = Vector3<Component>()

		let scalar = Component.sqrt(Component.pow(normalized.storage[orders[0], orders[0]], 2) + Component.pow(normalized.storage[orders[1], orders[0]], 2))
		if scalar > (16 * Component.ulpOfOne) {
			rotation[0] = Component.atan2(y: normalized.storage[orders[2], orders[1]], x: normalized.storage[orders[2], orders[2]])
			rotation[1] = Component.atan2(y: -normalized.storage[orders[2], orders[0]], x: scalar)
			rotation[2] = Component.atan2(y: normalized.storage[orders[1], orders[0]], x: normalized.storage[orders[0], orders[0]])
		}
		else {
			rotation[0] = Component.atan2(y: -normalized.storage[orders[1], orders[2]], x: normalized.storage[orders[1], orders[1]])
			rotation[1] = Component.atan2(y: -normalized.storage[orders[2], orders[0]], x: scalar)
			rotation[2] = .zero
		}

		if (orders[0] == 0 && orders[1] != 1) || (orders[0] == 1 && orders[1] != 2) || (orders[0] == 2 && orders[1] != 0) {
			rotation = -rotation
		}

		return [Angle(radians: rotation[0]), Angle(radians: rotation[1]), Angle(radians: rotation[2])]
	}
	
	public mutating func fromRotation(_ rotation: Rotation, order: RotationOrder) {
		let normalizedRotation = rotation.normalized
		let cos = Vector3(
			Component.cos(normalizedRotation[0].radians),
			Component.cos(normalizedRotation[1].radians),
			Component.cos(normalizedRotation[2].radians)
		)
		
		let sin = Vector3(
			Component.sin(normalizedRotation[0].radians),
			Component.sin(normalizedRotation[1].radians),
			Component.sin(normalizedRotation[2].radians)
		)
		
		let x: Self = [
			[1, 0, 0],
			[0, cos[0], -sin[0]],
			[0, sin[0], cos[0]]
		]
		
		let y: Self = [
			[cos[1], 0, sin[1]],
			[0, 1, 0],
			[-sin[1], 0, cos[1]]
		]
		
		let z: Self = [
			[cos[2], -sin[2], 0],
			[sin[2], cos[2], 0],
			[0, 0, 1]
		]
		
		let matrices: [Self] = [x, y, z]
		
		self = matrices[order.third.index] *
		       matrices[order.second.index] *
		       matrices[order.first.index] *
		       Self(withScale: self.scale)
	}
}

extension Matrix3x3: MatrixMath {
	public static func + (lhs: Self, rhs: Self) -> Self {
		Self(columns: lhs.storage.columns.0 + rhs.storage.columns.0,
					  lhs.storage.columns.1 + rhs.storage.columns.1,
					  lhs.storage.columns.2 + rhs.storage.columns.2)
	}

	public static func += (lhs: inout Self, rhs: Self) {
		lhs.storage.columns.0 += rhs.storage.columns.0
		lhs.storage.columns.1 += rhs.storage.columns.1
		lhs.storage.columns.2 += rhs.storage.columns.2
	}

	public static prefix func - (rhs: Self) -> Self {
		Self(columns: -rhs.storage.columns.0,
					  -rhs.storage.columns.1,
					  -rhs.storage.columns.2)
	}

	public static func - (lhs: Self, rhs: Self) -> Self {
		Self(columns: lhs.storage.columns.0 - rhs.storage.columns.0,
					  lhs.storage.columns.1 - rhs.storage.columns.1,
					  lhs.storage.columns.2 - rhs.storage.columns.2)
	}

	public static func -= (lhs: inout Self, rhs: Self) {
		lhs.storage.columns.0 -= rhs.storage.columns.0
		lhs.storage.columns.1 -= rhs.storage.columns.1
		lhs.storage.columns.2 -= rhs.storage.columns.2
	}
	
	public static func * (lhs: Self, rhs: Self) -> Self {
		let lhsRow0 = Storage.Column(
			lhs.storage.columns.0[0],
			lhs.storage.columns.1[0],
			lhs.storage.columns.2[0]
		)
		
		let lhsRow1 = Storage.Column(
			lhs.storage.columns.0[1],
			lhs.storage.columns.1[1],
			lhs.storage.columns.2[1]
		)
		
		let lhsRow2 = Storage.Column(
			lhs.storage.columns.0[2],
			lhs.storage.columns.1[2],
			lhs.storage.columns.2[2]
		)

		let column0 = Storage.Column(
			lhsRow0.dot(rhs.storage.columns.0),
			lhsRow1.dot(rhs.storage.columns.0),
			lhsRow2.dot(rhs.storage.columns.0)
		)
		
		let column1 = Storage.Column(
			lhsRow0.dot(rhs.storage.columns.1),
			lhsRow1.dot(rhs.storage.columns.1),
			lhsRow2.dot(rhs.storage.columns.1)
		)
		
		let column2 = Storage.Column(
			lhsRow0.dot(rhs.storage.columns.2),
			lhsRow1.dot(rhs.storage.columns.2),
			lhsRow2.dot(rhs.storage.columns.2)
		)
		
		return Self(columns: column0, column1, column2)
	}
	
	public static func *= (lhs: inout Self, rhs: Self) {
		lhs.storage = (lhs * rhs).storage
	}

	public static func * (lhs: Component, rhs: Self) -> Self {
		Self(columns: lhs * rhs.storage.columns.0,
					  lhs * rhs.storage.columns.1,
					  lhs * rhs.storage.columns.2)
	}

	public static func * (lhs: Self, rhs: Component) -> Self {
		Self(columns: lhs.storage.columns.0 * rhs,
					  lhs.storage.columns.1 * rhs,
					  lhs.storage.columns.2 * rhs)
	}

	public static func *= (lhs: inout Self, rhs: Component) {
		lhs.storage.columns.0 *= rhs
		lhs.storage.columns.1 *= rhs
		lhs.storage.columns.2 *= rhs
	}
}

extension Matrix3x3: MatrixProtocol {
	public static var columns: Int {
		3
	}
	
	public static var rows: Int {
		3
	}
	
	public init() {
		self.storage = SIMDRepresentation()
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

extension Matrix3x3: MatrixSub {
	public init(with subMatrix: Matrix2x2<Component>) {
		var matrix = Self()
		for y in 0..<Matrix2x2<Component>.rows {
			for x in 0..<Matrix2x2<Component>.columns {
				matrix[y, x] = subMatrix[y, x]
			}
		}
		self = matrix
	}
	
	public func subMatrix(excludingColumn column: Int = 2, row: Int = 2) -> Matrix2x2<Component> {
		var elements = [[Component]]()
		for y in 0..<Self.rows where row != y {
			var row = [Component]()
			for x in 0..<Self.columns where column != x {
				row.append(self[x, y])
			}
			elements.append(row)
		}

		return Matrix2x2(rows: Vector2(elements[0]), Vector2(elements[1]))
	}
}

extension Matrix3x3: MatrixVectorMath {
	public typealias Vector = Storage.Column
	
	public static func * (lhs: Self, rhs: Vector) -> Vector {
		lhs.storage.columns.0 * rhs.x +
		lhs.storage.columns.1 * rhs.y +
		lhs.storage.columns.2 * rhs.z
	}
}

extension Matrix3x3: QuaternionConvertible {
/// Initialize the rotational elements of the matrix using the provided
/// quaternion.
///
/// - Parameters:
///   - quaternion: The quaternion that will be used to initialize the
///   rotational elements of the matrix.
///
	public init(withQuaternion quaternion: Quaternion<Component>) {
		self = quaternion.matrix
	}
	
/// The rotational elements of the matrix as a quaternion.
///
	public var quaternion: Quaternion<Component> {
		Quaternion(withMatrix: self)
	}
}

extension Matrix3x3: Sendable where SIMDRepresentation: Sendable {
	
}

extension Matrix3x3: SIMDConvertible {
	public typealias SIMDRepresentation = Storage
	
	public init(_ simd: SIMDRepresentation) {
		self.storage = simd
	}
	
	public var simd: SIMDRepresentation {
		get {
			storage
		}
		set {
			storage = newValue
		}
	}
}

extension Matrix3x3: SquareMatrix {
	public var determinant: Component {
		let columns = self.storage.columns
		return columns.0.dot(columns.1.cross(columns.2))
	}
	
	public var trace: Component {
		(0..<Self.columns).reduce(into: Component.zero) {
			$0 += self[$1, $1]
		}
	}
	
/// A transposed version of the matrix.
///
/// A transposed matrix is the result of flipping the original matrix across
/// its main diagonal, effectively swapping rows with columns.
///
/// ```swift
/// | 1  2  3 |
/// | 4  5  6 |
/// | 7  8  9 |
/// ```
/// Becomes:
/// ```swift
/// | 1  4  7 |
/// | 2  5  8 |
/// | 3  6  9 |
/// ```
///
	public var transposed: Self {
		var matrix = Self()
		for column in 0..<Self.columns {
			for row in 0..<Self.rows {
				matrix.storage[column, row] = storage[row, column]
			}
		}
		return matrix
	}

/// Transposes this matrix, mutating the matrix.
///
/// A transposed matrix is the result of flipping the original matrix across
/// its main diagonal, effectively swapping rows with columns.
///
/// ```swift
/// | 1  2  3 |
/// | 4  5  6 |
/// | 7  8  9 |
/// ```
/// Becomes:
/// ```swift
/// | 1  4  7 |
/// | 2  5  8 |
/// | 3  6  9 |
/// ```
///
	public mutating func transpose() {
		let temp = self
		for column in 0..<Self.columns {
			for row in 0..<Self.rows {
				self.storage[column, row] = temp.storage[row, column]
			}
		}
	}
}

extension Matrix3x3.Storage: Sendable where Column: Sendable {
	
}
