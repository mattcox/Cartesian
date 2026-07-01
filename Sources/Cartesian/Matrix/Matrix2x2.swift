//
//  Matrix2x2.swift
//  Cartesian
//
//  Created by Matt Cox on 18/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import RealModule

/// A 2×2 matrix stored in column-major order.
///
/// Matrix2x2 represents a square matrix with 2 columns and 2 rows. The matrix
/// is stored in **column-major order**, meaning it consists of two column
/// vectors, each with two elements.
///
public struct Matrix2x2<Component: Real & SIMDScalar> {
/// The underlying storage type for the matrix.
///
/// This essentially provides a wrapper around the `Vector2` type, using a
/// vector per column.
///
	public struct Storage {
	/// Each column is stored a `Vector2`.
	///
		public typealias Column = Vector2<Component>
		
	/// The storage for this type is two columns, each with two components.
	///
		public var columns: (Column, Column)
		
	/// Initialize an empty matrix.
	///
		internal init() {
			self.columns = (Column(), Column())
		}
		
	/// Initialize the matrix from two columns.
	///
	/// - Parameters:
	///   - first: The values to place in the first column.
	///   - second: The values to place in the second column.
	///
		internal init(_ first: Column, _ second: Column) {
			self.columns = (first, second)
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
					default:
						preconditionFailure("Index out of range")
				}
			}
		}
	}

	private var storage: SIMDRepresentation
	
/// Initialize the matrix with the values for the two columns.
///
/// - Parameters:
///   - first: The first column of values.
///   - second: The second column of values.
///
	public init(columns first: SIMDRepresentation.Column, _ second: SIMDRepresentation.Column) {
		self.storage = SIMDRepresentation(first, second)
	}
	
/// Initialize the matrix with the values for the two rows.
///
/// - Parameters:
///   - first: The first row of values.
///   - second: The second row of values.
///
	public init(rows first: SIMDRepresentation.Column, _ second: SIMDRepresentation.Column, ) {
		self = Self(SIMDRepresentation(first, second)).transposed
	}
}

extension Matrix2x2 {
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

extension Matrix2x2: Codable {
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

extension Matrix2x2: CustomStringConvertible where Component: CVarArg {
	public var description: String {
		"""
		| \(String(format: "%.3f", storage[0, 0]))  \(String(format: "%.3f", storage[1, 0])) |
		| \(String(format: "%.3f", storage[0, 1]))  \(String(format: "%.3f", storage[1, 1])) |
		"""
	}
}

extension Matrix2x2: Equatable {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.storage.columns.0 == rhs.storage.columns.0 &&
		lhs.storage.columns.1 == rhs.storage.columns.1
	}
}

extension Matrix2x2: ExpressibleByArrayLiteral {
/// Initialize the matrix from an array literal.
///
/// The array is initialized as two rows, and then transposed into the
/// column-major storage used by the matrix.
///
/// For example, the following matrix is as it appears visually:
/// ```swift
/// let matrix: Matrix2x2 = [
///     [1.0, 2.0],
///     [3.0, 4.0]
/// ]
/// ```
/// But it is stored as two arrays representing the two column vectors:
/// ```swift
/// [1.0, 3.0], [2.0, 4.0]
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

extension Matrix2x2: Identity {
/// Creates an identity matrix.
///
/// An identity matrix is a matrix with 1 in the main diagonal, and 0
/// everywhere else. It acts as the multiplicative identity in matrix
/// operations, leaving other matrices unchanged when multiplied.
///
/// ```swift
/// | 1  0 |
/// | 0  1 |
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
/// | 1  0 |
/// | 0  1 |
/// ```
///
	public var isIdentity: Bool {
		for column in 0..<Self.columns {
			for row in 0..<Self.rows {
				guard storage[column, row] == ((column == row) ? 1 : 0) else {
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
/// | 1  0 |
/// | 0  1 |
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

extension Matrix2x2: Invertible {
/// Gets the inverse of this matrix if it exists.
///
	public var inverse: Self? {
		let determinant = self.determinant
		guard (abs(determinant) < .zero) == false &&
			determinant.isApproximatelyEqual(to: .zero) == false
		else {
			return nil
		}
		
		return self.cofactor * (1 / determinant)
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

extension Matrix2x2: MatrixMath {
	public static func + (lhs: Self, rhs: Self) -> Self {
		Self(columns: lhs.storage.columns.0 + rhs.storage.columns.0,
					  lhs.storage.columns.1 + rhs.storage.columns.1)
	}

	public static func += (lhs: inout Self, rhs: Self) {
		lhs.storage.columns.0 += rhs.storage.columns.0
		lhs.storage.columns.1 += rhs.storage.columns.1
	}

	public static prefix func - (rhs: Self) -> Self {
		Self(columns: -rhs.storage.columns.0,
					  -rhs.storage.columns.1)
	}

	public static func - (lhs: Self, rhs: Self) -> Self {
		Self(columns: lhs.storage.columns.0 - rhs.storage.columns.0,
					  lhs.storage.columns.1 - rhs.storage.columns.1)
	}

	public static func -= (lhs: inout Self, rhs: Self) {
		lhs.storage.columns.0 -= rhs.storage.columns.0
		lhs.storage.columns.1 -= rhs.storage.columns.1
	}
	
	public static func * (lhs: Self, rhs: Self) -> Self {
		let lhsRow0 = Storage.Column(
			lhs.storage.columns.0[0],
			lhs.storage.columns.1[0]
		)
		
		let lhsRow1 = Storage.Column(
			lhs.storage.columns.0[1],
			lhs.storage.columns.1[1]
		)

		let column0 = Storage.Column(
			lhsRow0.dot(rhs.storage.columns.0),
			lhsRow1.dot(rhs.storage.columns.0)
		)
		
		let column1 = Storage.Column(
			lhsRow0.dot(rhs.storage.columns.1),
			lhsRow1.dot(rhs.storage.columns.1)
		)
		
		return Self(columns: column0, column1)
	}
	
	public static func *= (lhs: inout Self, rhs: Self) {
		lhs.storage = (lhs * rhs).storage
	}

	public static func * (lhs: Component, rhs: Self) -> Self {
		Self(columns: lhs * rhs.storage.columns.0,
					  lhs * rhs.storage.columns.1)
	}

	public static func * (lhs: Self, rhs: Component) -> Self {
		Self(columns: lhs.storage.columns.0 * rhs,
					  lhs.storage.columns.1 * rhs)
	}

	public static func *= (lhs: inout Self, rhs: Component) {
		lhs.storage.columns.0 *= rhs
		lhs.storage.columns.1 *= rhs
	}
}

extension Matrix2x2: MatrixProtocol {
	public static var columns: Int {
		2
	}
	
	public static var rows: Int {
		2
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

extension Matrix2x2: MatrixVectorMath {
	public typealias Vector = Storage.Column
	
	public static func * (lhs: Self, rhs: Vector) -> Vector {
		lhs.storage.columns.0 * rhs[0] + lhs.storage.columns.1 * rhs[1]
	}
}

extension Matrix2x2: SIMDConvertible {
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

extension Matrix2x2: Sendable where SIMDRepresentation: Sendable {
	
}

extension Matrix2x2: SquareMatrix {
	public var adjugate: Self {
		cofactor.transposed
	}
	
	public var cofactor: Self {
		var result = Self()
		result.storage[0, 0] =  self.storage[1, 1]
		result.storage[0, 1] = -self.storage[0, 1]
		result.storage[1, 0] = -self.storage[1, 0]
		result.storage[1, 1] =  self.storage[0, 0]
		return result
	}

	public var determinant: Component {
		storage.columns.0[0] * storage.columns.1[1] - storage.columns.0[1] * storage.columns.1[0]
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
/// | 1  2 |
/// | 3  4 |
/// ```
/// Becomes:
/// ```swift
/// | 1  3 |
/// | 2  4 |
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
/// | 1  2 |
/// | 3  4 |
/// ```
/// Becomes:
/// ```swift
/// | 1  3 |
/// | 2  4 |
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

extension Matrix2x2.Storage: Sendable where Column: Sendable {
	
}
