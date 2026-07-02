//
//  Matrix.swift
//  Cartesian
//
//  Created by Matt Cox on 30/06/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import RealModule
import Units

/// A N×M matrix stored in column-major order.
///
/// The matrix is stored in **column-major order**, meaning it consists _N_ of
/// column vectors, each with _M_ elements.
///
/// This uses `InlineArray` as a backing store, so is unavailable on older
/// or unsupported platforms. The values are stored on the stack for efficiency.
///
/// - Warning: Unlike the fixed-size `Matrix2x2`, `Matrix3x3` and `Matrix4x4`
/// types, this type does not use simd instructions and is not vectorized. It
/// should only be used for non-standard matrix sizes or cases where SIMD
/// acceleration is not required.
///
@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
public struct Matrix<let n: Int, let m: Int, Component: Real & SIMDScalar> {
	public typealias Column = InlineArray<m, Component>
	private typealias Storage = InlineArray<n, Column>
	private var storage: Storage
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Matrix {
/// Access a matrix column at a specified index.
///
/// - Parameters:
///   - column: The index of the column in the matrix.
///
	public subscript(column: Int) -> Column {
		get {
			storage[column]
		}
		set {
			storage[column] = newValue
		}
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Matrix: Codable {
	public init(from decoder: Decoder) throws {
		let values = try Array<Component>(from: decoder)
		if values.count != (Self.columns * Self.rows) {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid number of values to decode"))
		}
		
		var matrix = Self()
		var count = 0
		for column in 0..<Self.columns{
			for row in 0..<Self.rows{
				matrix.storage[column][row] = values[count]
				count += 1
			}
		}
		
		self = matrix
	}

	public func encode(to encoder: Encoder) throws {
		var values = [Component]()
		for column in 0..<Self.columns{
			for row in 0..<Self.rows{
				let value = storage[column][row]
				values.append(value)
			}
		}
		
		try values.encode(to: encoder)
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Matrix: CustomStringConvertible where Component: CVarArg {
	public var description: String {
		(0..<Self.rows)
			.map { y in
				let columns = (0..<Self.columns)
					.map { x in
						String(format: "%.3f", storage[x][y])
					}
					.joined(separator: "  ")
					
				return "| \(columns) |"
			}
			.joined(separator: "\n")
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Matrix: Equatable {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		for x in 0..<Self.columns {
			for y in 0..<Self.rows {
				guard lhs.storage[x][y] == rhs.storage[x][y] else {
					return false
				}
			}
		}
		
		return true
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Matrix: ExpressibleByArrayLiteral {
/// Initialize the matrix from an array literal.
///
/// Each inner array represents a row, and the result is transposed into
/// the column-major storage used by the matrix.
///
/// For example, the following matrix is as it appears visually:
/// ```swift
/// let matrix: Matrix<4, 4, Double> = [
///     [1.0,   2.0,  3.0,  4.0],
///     [5.0,   6.0,  7.0,  8.0],
///     [9.0,  10.0, 11.0, 12.0],
///     [13.0, 14.0, 15.0, 16.0]
/// ]
/// ```
/// But it is stored as four arrays representing the four column vectors:
/// ```swift
/// [1.0, 5.0, 9.0, 13.0], [2.0, 6.0, 10.0, 14.0], [3.0, 7.0, 11.0, 15.0], [4.0, 8.0, 12.0, 16.0],
/// ```
///
	public init(arrayLiteral elements: [Component]...) {
		var matrix = Self()
		
		for x in 0..<min(Self.columns, elements.count) {
			for y in 0..<min(Self.rows, elements[x].count) {
				matrix[x][y] = elements[y][x]
			}
		}
		
		self = matrix
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Matrix: Identity {
/// Creates an identity matrix.
///
/// An identity matrix is a matrix with 1 in the main diagonal, and 0
/// everywhere else. It acts as the multiplicative identity in matrix
/// operations, leaving other matrices unchanged when multiplied.
///
/// - Note: Only square matrices have a meaningful identity. For non-square
/// matrices, the diagonal is filled with 1 up to the shorter dimension.
///
	public static var identity: Self {
		var matrix = Self()
		for i in 0..<Self.columns {
			matrix.storage[i][i] = 1
		}
		return matrix
	}

/// Returns true if the matrix is identity.
///
/// An identity matrix is a matrix with 1 in the main diagonal, and 0
/// everywhere else.
///
	public var isIdentity: Bool {
		for column in 0..<Self.columns {
			for row in 0..<Self.rows {
				guard self.storage[column][row] == ((column == row) ? 1 : 0) else {
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
	public mutating func toIdentity() {
		var matrix = Self()
		for column in 0..<Self.columns {
			for row in 0..<Self.rows {
				matrix.storage[column][row] = (column == row) ? 1 : 0
			}
		}
		self = matrix
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Matrix: Invertible where n == m {
/// Gets the inverse of this matrix if it exists.
///
/// Uses the adjugate-over-determinant method. Returns `nil` when the
/// determinant is zero or approximately zero, indicating a singular matrix.
///
/// - Warning: This algorithm is O(n!) due to cofactor expansion and is only
/// suitable for small matrices.
///
	public var inverse: Self? {
		let determinant = self.determinant
		guard (abs(determinant) < .zero) == false &&
			determinant.isApproximatelyEqual(to: .zero) == false
		else {
			return nil
		}
		return adjugate * (1 / determinant)
	}

/// Inverts this matrix if it can be inverted, mutating the matrix.
///
/// - Returns: A boolean indicating if the matrix could be inverted.
///
	public mutating func invert() -> Bool {
		if let inverse = self.inverse {
			self = inverse
			return true
		}
		return false
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Matrix: MatrixAffineTransform where n == m, n == 4, Component: BinaryFloatingPoint {
	public typealias Rotation = Vector3<Component>
	public typealias Scale = Vector3<Component>
	public typealias Translation = Vector3<Component>

	public var isAffine: Bool {
		storage[0][3].isApproximatelyEqual(to: .zero) &&
		storage[1][3].isApproximatelyEqual(to: .zero) &&
		storage[2][3].isApproximatelyEqual(to: .zero) &&
		storage[3][3].isApproximatelyEqual(to: 1)
	}

	public var scale: Scale {
		get {
			let row0 = Scale(storage[0][0], storage[1][0], storage[2][0])
			let row1 = Scale(storage[0][1], storage[1][1], storage[2][1])
			let row2 = Scale(storage[0][2], storage[1][2], storage[2][2])
			return Scale(row0.magnitude, row1.magnitude, row2.magnitude)
		}
		set {
			let row0 = Scale(storage[0][0], storage[1][0], storage[2][0]).normalized * newValue[0]
			let row1 = Scale(storage[0][1], storage[1][1], storage[2][1]).normalized * newValue[1]
			let row2 = Scale(storage[0][2], storage[1][2], storage[2][2]).normalized * newValue[2]
			storage[0][0] = row0[0]; storage[0][1] = row1[0]; storage[0][2] = row2[0]
			storage[1][0] = row0[1]; storage[1][1] = row1[1]; storage[1][2] = row2[1]
			storage[2][0] = row0[2]; storage[2][1] = row1[2]; storage[2][2] = row2[2]
		}
	}

	public var translation: Translation {
		get {
			Translation(storage[3][0], storage[3][1], storage[3][2])
		}
		set {
			storage[3][0] = newValue[0]
			storage[3][1] = newValue[1]
			storage[3][2] = newValue[2]
		}
	}

	public init(withRotation rotation: Rotation, order: RotationOrder) {
		var matrix = Self.identity
		matrix.fromRotation(rotation, order: order)
		self = matrix
	}

	public init(withScale scale: Component) {
		var matrix = Self.identity
		for i in 0..<3 {
			matrix.storage[i][i] = scale
		}
		self = matrix
	}

	public init(withScale scale: Scale) {
		var matrix = Self.identity
		for i in 0..<3 {
			matrix.storage[i][i] = scale[i]
		}
		self = matrix
	}

	public init(withTranslation translation: Translation) {
		var matrix = Self.identity
		matrix.storage[3][0] = translation[0]
		matrix.storage[3][1] = translation[1]
		matrix.storage[3][2] = translation[2]
		self = matrix
	}

	public func toRotation(order: RotationOrder) -> Rotation {
		let orders = [order[0].index, order[1].index, order[2].index]

		// The extraction computes the angles in the order the rotations are
		// applied (first, second, third); these are scattered back to their
		// axis index below.
		//
		var sequence = Rotation()

		let scalar = Component.sqrt(Component.pow(storage[orders[0]][orders[0]], 2) + Component.pow(storage[orders[1]][orders[0]], 2))
		if scalar > (16 * Component.ulpOfOne) {
			sequence[0] = Component.atan2(y: storage[orders[2]][orders[1]], x: storage[orders[2]][orders[2]])
			sequence[1] = Component.atan2(y: -storage[orders[2]][orders[0]], x: scalar)
			sequence[2] = Component.atan2(y: storage[orders[1]][orders[0]], x: storage[orders[0]][orders[0]])
		}
		else {
			sequence[0] = Component.atan2(y: -storage[orders[1]][orders[2]], x: storage[orders[1]][orders[1]])
			sequence[1] = Component.atan2(y: -storage[orders[2]][orders[0]], x: scalar)
			sequence[2] = .zero
		}

		if (orders[0] == 0 && orders[1] == 1) || (orders[0] == 1 && orders[1] == 2) || (orders[0] == 2 && orders[1] == 0) {
			sequence *= -1
		}

		var rotation = Rotation()
		rotation[orders[0]] = sequence[0]
		rotation[orders[1]] = sequence[1]
		rotation[orders[2]] = sequence[2]

		return rotation
	}

	public mutating func fromRotation(_ rotation: Rotation, order: RotationOrder) {
		var result = Self.identity

		for i in 0..<3 {
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

		self = result * Self(withScale: self.scale)
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Matrix: MatrixLinearTransform where n == m, n == 4, Component: BinaryFloatingPoint {

}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Matrix: MatrixMath {
	public static func + (lhs: Self, rhs: Self) -> Self {
		var result = Self()
		for column in 0..<n {
			for row in 0..<m {
				result.storage[column][row] = lhs.storage[column][row] + rhs.storage[column][row]
			}
		}
		return result
	}

	public static func += (lhs: inout Self, rhs: Self) {
		for column in 0..<n {
			for row in 0..<m {
				lhs.storage[column][row] += rhs.storage[column][row]
			}
		}
	}

	public static prefix func - (rhs: Self) -> Self {
		var result = Self()
		for column in 0..<n {
			for row in 0..<m {
				result.storage[column][row] = -rhs.storage[column][row]
			}
		}
		return result
	}

	public static func - (lhs: Self, rhs: Self) -> Self {
		var result = Self()
		for column in 0..<n {
			for row in 0..<m {
				result.storage[column][row] = lhs.storage[column][row] - rhs.storage[column][row]
			}
		}
		return result
	}

	public static func -= (lhs: inout Self, rhs: Self) {
		for column in 0..<n {
			for row in 0..<m {
				lhs.storage[column][row] -= rhs.storage[column][row]
			}
		}
	}

	public static func * (lhs: Self, rhs: Self) -> Self {
		precondition(n == m, "Matrix multiplication requires a square matrix")
		var result = Self()
		for column in 0..<n {
			for row in 0..<m {
				var sum: Component = .zero
				for k in 0..<n {
					sum += lhs.storage[k][row] * rhs.storage[column][k]
				}
				result.storage[column][row] = sum
			}
		}
		return result
	}

	public static func *= (lhs: inout Self, rhs: Self) {
		lhs = lhs * rhs
	}

	public static func * (lhs: Component, rhs: Self) -> Self {
		var result = Self()
		for column in 0..<n {
			for row in 0..<m {
				result.storage[column][row] = lhs * rhs.storage[column][row]
			}
		}
		return result
	}

	public static func * (lhs: Self, rhs: Component) -> Self {
		var result = Self()
		for column in 0..<n {
			for row in 0..<m {
				result.storage[column][row] = lhs.storage[column][row] * rhs
			}
		}
		return result
	}

	public static func *= (lhs: inout Self, rhs: Component) {
		for column in 0..<n {
			for row in 0..<m {
				lhs.storage[column][row] *= rhs
			}
		}
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Matrix: MatrixProtocol {
	public static var columns: Int {
		n
	}
	
	public static var rows: Int {
		m
	}
	
	public init() {
		storage = Storage(repeating: Column(repeating: .zero))
	}
	
	public subscript(column: Int, row: Int) -> Component {
		get {
			storage[column][row]
		}
		set {
			storage[column][row] = newValue
		}
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Matrix: MatrixVectorMath {
	public typealias Vector = Cartesian.Vector<m, Component>

	public static func * (lhs: Self, rhs: Vector) -> Vector {
		precondition(n == m, "Matrix-vector multiplication requires a square matrix")
		var result = Vector()
		for row in 0..<m {
			var sum: Component = .zero
			for k in 0..<n {
				sum += lhs.storage[k][row] * rhs[k]
			}
			result[row] = sum
		}
		return result
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Matrix: QuaternionConvertible where n == m, n == 3 {
	public typealias QuaternionComponent = Component

/// Initialize the rotational elements of the matrix using the provided
/// quaternion.
///
/// - Parameters:
///   - quaternion: The quaternion that will be used to initialize the
///   rotational elements of the matrix.
///
	public init(withQuaternion quaternion: Quaternion<Component>) {
		self = Self(from: quaternion.matrix)
	}

/// The rotational elements of the matrix as a quaternion.
///
	public var quaternion: Quaternion<Component> {
		Quaternion(withMatrix: Matrix3x3(from: self))
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Matrix: Sendable where Storage: Sendable {
	
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Matrix: SquareMatrix where n == m {
	public var adjugate: Self {
		cofactor.transposed
	}

	public var cofactor: Self {
		var result = Self()
		for col in 0..<n {
			for row in 0..<m {
				var minor = [[Component]]()
				for c in 0..<n where c != col {
					var minorColumn = [Component]()
					for r in 0..<m where r != row {
						minorColumn.append(storage[c][r])
					}
					minor.append(minorColumn)
				}
				let sign: Component = ((col + row) % 2 == 0) ? 1 : -1
				result.storage[col][row] = sign * Self.determinantOfColumns(minor)
			}
		}
		return result
	}

	public var determinant: Component {
		var columns = [[Component]]()
		for col in 0..<n {
			var column = [Component]()
			for row in 0..<m {
				column.append(storage[col][row])
			}
			columns.append(column)
		}
		return Self.determinantOfColumns(columns)
	}

	public var trace: Component {
		(0..<n).reduce(into: Component.zero) {
			$0 += storage[$1][$1]
		}
	}

/// A transposed version of the matrix.
///
/// A transposed matrix is the result of flipping the original matrix across
/// its main diagonal, effectively swapping rows with columns.
///
	public var transposed: Self {
		var result = Self()
		for col in 0..<n {
			for row in 0..<m {
				result.storage[col][row] = storage[row][col]
			}
		}
		return result
	}

/// Transposes this matrix, mutating the matrix.
///
/// A transposed matrix is the result of flipping the original matrix across
/// its main diagonal, effectively swapping rows with columns.
///
	public mutating func transpose() {
		let temp = self
		for col in 0..<n {
			for row in 0..<m {
				storage[col][row] = temp.storage[row][col]
			}
		}
	}

/// Computes the determinant of a matrix represented as an array of column
/// vectors using cofactor expansion.
///
/// - Warning: This algorithm is O(n!) and is only suitable for small matrices.
///
/// - Parameters:
///   - columns: The matrix represented as an array of column vectors, where
///   each inner array contains the elements of that column.
///
/// - Returns: The determinant of the matrix.
///
	private static func determinantOfColumns(_ columns: [[Component]]) -> Component {
		let size = columns.count
		if size == 0 { return 1 }
		if size == 1 { return columns[0][0] }
		if size == 2 {
			return columns[0][0] * columns[1][1] - columns[1][0] * columns[0][1]
		}
		var result: Component = .zero
		for col in 0..<size {
			var minor = [[Component]]()
			for c in 0..<size where c != col {
				var minorColumn = [Component]()
				for r in 1..<size {
					minorColumn.append(columns[c][r])
				}
				minor.append(minorColumn)
			}
			let sign: Component = (col % 2 == 0) ? 1 : -1
			result += sign * columns[col][0] * determinantOfColumns(minor)
		}
		return result
	}
}
