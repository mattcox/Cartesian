//
//  Matrix4x4.swift
//  Cartesian
//
//  Created by Matt Cox on 18/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import RealModule

/// A 4×4 matrix stored in column-major order.
///
/// Matrix4x4 represents a square matrix with 4 columns and 4 rows. The matrix
/// is stored in **column-major order**, meaning it consists of four column
/// vectors, each with four elements.
///
/// The matrix is stored as:
/// ```
/// [ c0.x  c1.x  c2.x, c3.x ]
/// [ c0.y  c1.y  c2.y, c3.y ]
/// [ c0.z  c1.z  c2.z, c3.z ]
/// [ c0.w  c1.w  c2.w, c3.w ]
/// ```
/// where `c0` `c1` `c2` and `c3` are column vectors.
///
/// This matrix encodes scale, rotation and translation, and is commonly used to
/// transform 3D vectors.
///
public struct Matrix4x4<Component: Real & SIMDScalar> {
/// The underlying storage type for the matrix.
///
/// This essentially provides a wrapper around the `Vector4` type, using a
/// vector per column.
///
	public struct Storage {
	/// Each column is stored a `Vector4`.
	///
		public typealias Column = Vector4<Component>
		
	/// The storage for this type is four columns, each with four
	/// components.
	///
		public var columns: (Column, Column, Column, Column)
		
	/// Initialize an empty matrix.
	///
		internal init() {
			self.columns = (Column(), Column(), Column(), Column())
		}
		
	/// Initialize the matrix from four columns.
	///
	/// - Parameters:
	///   - first: The values to place in the first column.
	///   - second: The values to place in the second column.
	///   - third: The values to place in the third column.
	///   - fourth: The values to place in the fourth column.
	///
		internal init(_ first: Column, _ second: Column, _ third: Column, _ fourth: Column) {
			self.columns = (first, second, third, fourth)
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
					case 3:
						columns.3[row]
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
					case 3:
						columns.3[row] = newValue
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
					case 3:
						columns.3
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
					case 3:
						columns.3 = newValue
					default:
						preconditionFailure("Index out of range")
				}
			}
		}
	}
	
	private var storage: SIMDRepresentation
	
/// Initialize the matrix from four columns.
///
/// - Parameters:
///   - first: The first column of values.
///   - second: The second column of values.
///   - third: The third column of values.
///   - fourth: The fourth column of values.
///
	public init(columns first: SIMDRepresentation.Column, _ second: SIMDRepresentation.Column, _ third: SIMDRepresentation.Column, _ fourth: SIMDRepresentation.Column) {
		self.storage = SIMDRepresentation(first, second, third, fourth)
	}
	
/// Initialize the matrix from four rows.
///
/// - Parameters:
///   - first: The first row of values.
///   - second: The second row of values.
///   - third: The third row of values.
///   - fourth: The fourth column of values.
///
	public init(rows first: SIMDRepresentation.Column, _ second: SIMDRepresentation.Column, _ third: SIMDRepresentation.Column, _ fourth: SIMDRepresentation.Column) {
		self = Self(SIMDRepresentation(first, second, third, fourth)).transposed
	}
}

extension Matrix4x4: Codable {
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

extension Matrix4x4: CustomStringConvertible where Component: CVarArg  {
	public var description: String {
		"""
		| \(String(format: "%.3f", storage[0, 0]))  \(String(format: "%.3f", storage[1, 0]))  \(String(format: "%.3f", storage[2, 0]))  \(String(format: "%.3f", storage[3, 0])) |
		| \(String(format: "%.3f", storage[0, 1]))  \(String(format: "%.3f", storage[1, 1]))  \(String(format: "%.3f", storage[2, 1]))  \(String(format: "%.3f", storage[3, 1])) |
		| \(String(format: "%.3f", storage[0, 2]))  \(String(format: "%.3f", storage[1, 2]))  \(String(format: "%.3f", storage[2, 2]))  \(String(format: "%.3f", storage[3, 2])) |
		| \(String(format: "%.3f", storage[0, 3]))  \(String(format: "%.3f", storage[1, 3]))  \(String(format: "%.3f", storage[2, 3]))  \(String(format: "%.3f", storage[3, 3])) |
		"""
	}
}

extension Matrix4x4: Equatable {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.storage.columns.0 == rhs.storage.columns.0 &&
		lhs.storage.columns.1 == rhs.storage.columns.1 &&
		lhs.storage.columns.2 == rhs.storage.columns.2 &&
		lhs.storage.columns.3 == rhs.storage.columns.3
	}
}

extension Matrix4x4: ExpressibleByArrayLiteral {
/// Initialize the matrix from an array literal.
///
/// The array is initialized as four rows, and then transposed into the
/// column-major storage used by the matrix.
///
/// For example, the following matrix is as it appears visually:
/// ```swift
/// let matrix: Matrix4x4 = [
///     [1.0,   2.0,  3.0,  4.0],
///     [5.0,   6.0,  7.0,  8.0],
///     [9.0,  10.0, 11.0, 12.0],
///     [13.0, 14.0, 15.0, 16.0]
/// ]
/// ```
/// But it is stored as three arrays representing the three column vectors:
/// ```swift
/// [1.0, 5.0, 9.0, 13.0], [2.0, 6.0, 10.0, 14.0], [3.0, 7.0, 11.0, 15.0], [4.0, 8.0, 12.0, 16.0],
/// ```
///
	public init(arrayLiteral elements: [Component]...) {
		var matrix = Self()
		
		for x in 0..<min(Self.columns, elements.count) {
			for y in 0..<min(Self.rows, elements[x].count) {
				matrix[x, y] = elements[x][y]
			}
		}
		
		self = matrix.transposed
	}
}

extension Matrix4x4: Identity {
	public static var identity: Self {
		var matrix = Self()
		for index in 0..<Self.columns {
			matrix.storage[index, index] = 1
		}
		return matrix
	}
	
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

extension Matrix4x4: Invertible {
	public var inverse: Self? {
		if isAffine {
			guard let inverseRotationAndScale = subMatrix().inverse else {
				return nil
			}

			let inverseTranslation = -(inverseRotationAndScale * translation)
			
			let column0 = Storage.Column(from: inverseRotationAndScale[0])
			let column1 = Storage.Column(from: inverseRotationAndScale[1])
			let column2 = Storage.Column(from: inverseRotationAndScale[2])
			let column3 = Storage.Column(from: inverseTranslation)
			
			return Matrix4x4(columns: column0, column1, column2, column3)
		}
		else {
			let adjugate = self.adjugate
			let determinant = self.determinant
			guard (abs(determinant) < .zero) == false &&
				determinant.isApproximatelyEqual(to: .zero) == false
			else {
				return nil
			}
			return adjugate * (1 / determinant)
		}
	}
	
	public mutating func invert() -> Bool {
		if let inverse = self.inverse {
			self.storage = inverse.storage
			return true
		}
		return false
	}
}


extension Matrix4x4: MatrixAffineTransform {
	public typealias Rotation =  Vector3<Component>
	public typealias Scale = Vector3<Component>
	public typealias Translation = Vector3<Component>
	
	public var isAffine: Bool {
		storage.columns.0[3].isApproximatelyEqual(to: .zero) &&
		storage.columns.1[3].isApproximatelyEqual(to: .zero) &&
		storage.columns.2[3].isApproximatelyEqual(to: .zero) &&
		storage.columns.3[3].isApproximatelyEqual(to: 1)
	}
	
	public var scale: Scale {
		get {
			let row0 = Scale(storage.columns.0[0], storage.columns.1[0], storage.columns.2[0])
			let row1 = Scale(storage.columns.0[1], storage.columns.1[1], storage.columns.2[1])
			let row2 = Scale(storage.columns.0[2], storage.columns.1[2], storage.columns.2[2])
			
			return Scale(row0.magnitude, row1.magnitude, row2.magnitude)
		}
		set {
			let row0 = Scale(storage.columns.0[0], storage.columns.1[0], storage.columns.2[0]).normalized * newValue[0]
			let row1 = Scale(storage.columns.0[1], storage.columns.1[1], storage.columns.2[1]).normalized * newValue[1]
			let row2 = Scale(storage.columns.0[2], storage.columns.1[2], storage.columns.2[2]).normalized * newValue[2]
			
			storage.columns.0 = Storage.Column(row0[0], row1[0], row2[0], storage.columns.0[3])
			storage.columns.1 = Storage.Column(row0[1], row1[1], row2[1], storage.columns.0[2])
			storage.columns.2 = Storage.Column(row0[2], row1[2], row2[2], storage.columns.0[1])
		}
	}
	
	public var translation: Vector3<Component> {
		get {
			Vector3(storage.columns.3[0], storage.columns.3[1], storage.columns.3[2])
		}
		set {
			storage.columns.3[0] = newValue[0]
			storage.columns.3[1] = newValue[1]
			storage.columns.3[2] = newValue[2]
		}
	}
	
	public init(withRotation rotation: Rotation, order: RotationOrder) {
		var matrix = Self.identity
		matrix.fromRotation(rotation, order: order)
		self = matrix
	}
	
	public init(withScale scale: Component) {
		var matrix = Self.identity
		for index in 0..<Scale.count {
			matrix[index, index] = scale
		}
		self = matrix
	}
	
	public init(withScale scale: Scale) {
		var matrix = Self.identity
		for index in 0..<Scale.count {
			matrix[index, index] = scale[index]
		}
		self = matrix
	}
	
	public init(withTranslation translation: Translation) {
		var matrix = Self.identity
		matrix.storage.columns.3[0] = translation[0]
		matrix.storage.columns.3[1] = translation[1]
		matrix.storage.columns.3[2] = translation[2]
		self = matrix
	}
	
	public func toRotation(order: RotationOrder) -> Rotation {
		let orders = [order[0].index, order[1].index, order[2].index]

		var rotation = Rotation()
		let scalar = Component.sqrt(Component.pow(storage[orders[0], orders[0]], 2) + Component.pow(storage[orders[1], orders[0]], 2))
		if scalar > (16 * Component.ulpOfOne) {
			rotation[0] = Component.atan2(y: storage[orders[1], orders[2]], x: storage[orders[2], orders[2]])
			rotation[1] = Component.atan2(y: -storage[orders[0], orders[2]], x: scalar)
			rotation[2] = Component.atan2(y: storage[orders[0], orders[1]], x: storage[orders[0], orders[0]])
		}
		else {
			rotation[0] = Component.atan2(y: -storage[orders[2], orders[1]], x: storage[orders[1], orders[1]])
			rotation[1] = Component.atan2(y: -storage[orders[0], orders[2]], x: scalar)
			rotation[2] = .zero
		}
		
		if((orders[0] == 0 && orders[1] != 1) || (orders[0] == 1 && orders[1] != 2) || (orders[0] == 2 && orders[1] != 0)) {
			for i in 0..<Rotation.count {
				rotation[i] *= -1
			}
		}
		
		return rotation
	}
	
	public mutating func fromRotation(_ rotation: Rotation, order: RotationOrder) {
		var result = Self.identity
		
		for i in 0..<Self.columns {
			let orderAxis = order[i].index
			if rotation[orderAxis].isApproximatelyEqual(to: .zero) {
				continue
			}
			let axis = [[2, 1], [0, 2], [1, 0]]
			let sin = Component.sin(rotation[orderAxis])
			
			var temporary = Self.identity
			
			temporary[axis[orderAxis][1], axis[orderAxis][0]] =  sin
			temporary[axis[orderAxis][0], axis[orderAxis][1]] = -sin
			temporary[axis[orderAxis][0], axis[orderAxis][0]] =  Component.cos(rotation[orderAxis])
			temporary[axis[orderAxis][1], axis[orderAxis][1]] =  temporary[axis[orderAxis][0], axis[orderAxis][0]]
			
			result *= temporary
		}
		
		self = result
	}
}

extension Matrix4x4: MatrixMath {
	public static func + (lhs: Self, rhs: Self) -> Self {
		Self(columns: lhs.storage.columns.0 + rhs.storage.columns.0,
					  lhs.storage.columns.1 + rhs.storage.columns.1,
					  lhs.storage.columns.2 + rhs.storage.columns.2,
					  lhs.storage.columns.3 + rhs.storage.columns.3)
	}

	public static func += (lhs: inout Self, rhs: Self) {
		lhs.storage.columns.0 += rhs.storage.columns.0
		lhs.storage.columns.1 += rhs.storage.columns.1
		lhs.storage.columns.2 += rhs.storage.columns.2
		lhs.storage.columns.3 += rhs.storage.columns.3
	}

	public static prefix func - (rhs: Self) -> Self {
		Self(columns: -rhs.storage.columns.0,
					  -rhs.storage.columns.1,
					  -rhs.storage.columns.2,
					  -rhs.storage.columns.3)
	}

	public static func - (lhs: Self, rhs: Self) -> Self {
		Self(columns: lhs.storage.columns.0 - rhs.storage.columns.0,
					  lhs.storage.columns.1 - rhs.storage.columns.1,
					  lhs.storage.columns.2 + rhs.storage.columns.2,
					  lhs.storage.columns.3 + rhs.storage.columns.3)
	}

	public static func -= (lhs: inout Self, rhs: Self) {
		lhs.storage.columns.0 -= rhs.storage.columns.0
		lhs.storage.columns.1 -= rhs.storage.columns.1
		lhs.storage.columns.2 -= rhs.storage.columns.2
		lhs.storage.columns.3 -= rhs.storage.columns.3
	}
	
	public static func * (lhs: Self, rhs: Self) -> Self {
		let lhsRow0 = Storage.Column(
			lhs.storage.columns.0[0],
			lhs.storage.columns.1[0],
			lhs.storage.columns.2[0],
			lhs.storage.columns.3[0]
		)
		
		let lhsRow1 = Storage.Column(
			lhs.storage.columns.0[1],
			lhs.storage.columns.1[1],
			lhs.storage.columns.2[1],
			lhs.storage.columns.3[1]
		)
		
		let lhsRow2 = Storage.Column(
			lhs.storage.columns.0[2],
			lhs.storage.columns.1[2],
			lhs.storage.columns.2[2],
			lhs.storage.columns.3[2]
		)
		
		let lhsRow3 = Storage.Column(
			lhs.storage.columns.0[3],
			lhs.storage.columns.1[3],
			lhs.storage.columns.2[3],
			lhs.storage.columns.3[3]
		)

		let column0 = Storage.Column(
			lhsRow0.dot(rhs.storage.columns.0),
			lhsRow1.dot(rhs.storage.columns.0),
			lhsRow2.dot(rhs.storage.columns.0),
			lhsRow3.dot(rhs.storage.columns.0)
		)
		
		let column1 = Storage.Column(
			lhsRow0.dot(rhs.storage.columns.1),
			lhsRow1.dot(rhs.storage.columns.1),
			lhsRow2.dot(rhs.storage.columns.1),
			lhsRow3.dot(rhs.storage.columns.1)
		)
		
		let column2 = Storage.Column(
			lhsRow0.dot(rhs.storage.columns.2),
			lhsRow1.dot(rhs.storage.columns.2),
			lhsRow2.dot(rhs.storage.columns.2),
			lhsRow3.dot(rhs.storage.columns.2)
		)
		
		let column3 = Storage.Column(
			lhsRow0.dot(rhs.storage.columns.3),
			lhsRow1.dot(rhs.storage.columns.3),
			lhsRow2.dot(rhs.storage.columns.3),
			lhsRow3.dot(rhs.storage.columns.3)
		)
		
		return Self(columns: column0, column1, column2, column3)
	}
	
	public static func *= (lhs: inout Self, rhs: Self) {
		lhs.storage = (lhs * rhs).storage
	}

	public static func * (lhs: Component, rhs: Self) -> Self {
		Self(columns: lhs * rhs.storage.columns.0,
					  lhs * rhs.storage.columns.1,
					  lhs * rhs.storage.columns.2,
					  lhs * rhs.storage.columns.3)
	}

	public static func * (lhs: Self, rhs: Component) -> Self {
		Self(columns: lhs.storage.columns.0 * rhs,
					  lhs.storage.columns.1 * rhs,
					  lhs.storage.columns.2 * rhs,
					  lhs.storage.columns.3 * rhs)
	}

	public static func *= (lhs: inout Self, rhs: Component) {
		lhs.storage.columns.0 *= rhs
		lhs.storage.columns.1 *= rhs
		lhs.storage.columns.2 *= rhs
		lhs.storage.columns.3 *= rhs
	}
}

extension Matrix4x4: MatrixProtocol {
	public static var columns: Int {
		4
	}
	
	public static var rows: Int {
		4
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

	public subscript(column: Int) -> Storage.Column {
		get {
			storage[column]
		}
		set {
			storage[column] = newValue
		}
	}
}

extension Matrix4x4: MatrixSub {
	public func subMatrix(excludingColumn column: Int = 3, row: Int = 3) -> Matrix3x3<Component> {
		var elements = [[Component]]()
		for y in 0..<Self.rows where row != y {
			var row = [Component]()
			for x in 0..<Self.columns where column != x {
				row.append(self[y, x])
			}
			elements.append(row)
		}
		
		return Matrix3x3(rows: Vector3(elements[0]), Vector3(elements[1]), Vector3(elements[2]))
	}
}

extension Matrix4x4: MatrixVectorMath {
	public typealias Vector = Storage.Column
	
	public static func * (lhs: Self, rhs: Vector) -> Vector {
		lhs.storage.columns.0 * rhs[0] +
		lhs.storage.columns.1 * rhs[1] +
		lhs.storage.columns.2 * rhs[2] +
		lhs.storage.columns.3 * rhs[3]
	}
}

extension Matrix4x4: SIMDConvertible {
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

extension Matrix4x4: Sendable where SIMDRepresentation: Sendable {
	
}

extension Matrix4x4: SquareMatrix {
	public var determinant: Component {
		let row0 = [self[0][0], self[1][0], self[2][0], self[3][0]]
		
		let determinant0 = subMatrix(excludingColumn: 0, row: 0).determinant
		let determinant1 = subMatrix(excludingColumn: 0, row: 1).determinant
		let determinant2 = subMatrix(excludingColumn: 0, row: 2).determinant
		let determinant3 = subMatrix(excludingColumn: 0, row: 3).determinant
		
		return row0[0] * determinant0 - row0[1] * determinant1 + row0[2] * determinant2 - row0[3] * determinant3
	}
	
	public var trace: Component {
		(0..<Self.columns).reduce(into: Component.zero) {
			$0 += self[$1, $1]
		}
	}
	
	public var transposed: Self {
		var matrix = Self()
		for column in 0..<Self.columns {
			for row in 0..<Self.rows {
				matrix.storage[column, row] = storage[row, column]
			}
		}
		return matrix
	}
	
	public mutating func transpose() {
		let temp = self
		for column in 0..<Self.columns {
			for row in 0..<Self.rows {
				self.storage[column, row] = temp.storage[row, column]
			}
		}
	}
}

extension Matrix4x4.Storage: Sendable where Column: Sendable {
	
}
