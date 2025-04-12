//
//  Float3x3.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import Units

#if canImport(simd) && !SKIP_SIMD_IMPLEMENTATION
import simd

/// A 3x3 ``Matrix`` containing Float values.
///
public struct Float3x3 {
/// The matrix data is stored as a simd type where available.
///
	private var storage: SIMDRepresentation
}

extension Float3x3: Codable {
	public init(from decoder: Decoder) throws {
		// Decode the values as a flat array of components. There should be
		// 9 values, as this is a 3x3 matrix.
		//
		let values = try Array<Component>(from: decoder)
		if values.count != (Self.columns * Self.rows) {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid number of values to decode"))
		}
		
		var storage = SIMDRepresentation()
		var count = 0
		for y in 0..<Self.columns{
			for x in 0..<Self.rows{
				storage[y, x] = values[count]
				count += 1
			}
		}
		
		self.storage = storage
	}

	public func encode(to encoder: Encoder) throws {
		// Values are encoded as a flat array of components. There should be
		// 9 values, as this is a 3x3 matrix.
		//
		var values = [Component]()
		for y in 0..<Self.columns{
			for x in 0..<Self.rows{
				let value = storage[y, x]
				values.append(value)
			}
		}
		assert(values.count == 9, "Invalid number of values to encode")
		
		try values.encode(to: encoder)
	}
}

extension Float3x3: CustomStringConvertible {
	public var description: String {
		"""
		[[\(storage[0][0]), \(storage[1][0]), \(storage[2][0])],
		 [\(storage[0][1]), \(storage[1][1]), \(storage[2][1])],
		 [\(storage[0][2]), \(storage[1][2]), \(storage[2][2])]]
		"""
	}
}

extension Float3x3: Equatable {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		for y in 0..<Self.columns {
			for x in 0..<Self.rows {
				guard lhs.storage[y][x] == rhs.storage[y][x] else {
					return false
				}
			}
		}
		
		return true
	}
}

extension Float3x3: Invertible {
	public var inverse: Self {
		Self(storage.inverse)
	}
	
	public mutating func invert() {
		storage = storage.inverse
	}
}

extension Float3x3: Sendable {
	
}

extension Float3x3: SIMDConvertible {
	public typealias SIMDRepresentation = simd_float3x3

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

extension Float3x3: Matrix3x3 {
	public typealias Component = Float

	public var determinant: Component {
		storage.determinant
	}
	
	public var trace: Component {
		var trace: Component = .zero
		for y in 0..<Self.columns {
			trace += storage[y][y]
		}
		return trace
	}

	public init() {
		self.storage = SIMDRepresentation()
	}

	public subscript(_ column: Int, _ row: Int) -> Component {
		get {
			storage[column][row]
		}
		set {
			storage[column][row] = newValue
		}
	}
}

extension Float3x3: MatrixIdentity {
	public static var identity: Self {
		Self(matrix_identity_float3x3)
	}

	public var isIdentity: Bool {
		storage == matrix_identity_float3x3
	}

	public mutating func toIdentity() {
		storage = matrix_identity_float3x3
	}
}

extension Float3x3: MatrixMath {
	public static func + (lhs: Self, rhs: Self) -> Self {
		Self(lhs.storage + rhs.storage)
	}

	public static func += (lhs: inout Self, rhs: Self) {
		lhs.storage += rhs.storage
	}

	public static prefix func - (rhs: Self) -> Self {
		Self(-rhs.storage)
	}

	public static func - (lhs: Self, rhs: Self) -> Self {
		Self(lhs.storage - rhs.storage)
	}

	public static func -= (lhs: inout Self, rhs: Self) {
		lhs.storage -= rhs.storage
	}
	
	public static func * (lhs: Self, rhs: Self) -> Self {
		Self(lhs.storage * rhs.storage)
	}
	
	public static func *= (lhs: inout Self, rhs: Self) {
		lhs.storage *= rhs.storage
	}

	public static func * (lhs: Component, rhs: Self) -> Self {
		Self(lhs * rhs.storage)
	}

	public static func * (lhs: Self, rhs: Component) -> Self {
		Self(lhs.storage * rhs)
	}

	public static func *= (lhs: inout Self, rhs: Component) {
		lhs.storage *= rhs
	}
}

extension Float3x3: MatrixQuaternionConvertible {
	public typealias QuaternionRepresentation = FloatQuaternion
	
	public init(withQuaternion quaternion: QuaternionRepresentation) {
		self = Self(SIMDRepresentation(quaternion.simd))
	}
	
	public var quaternion: QuaternionRepresentation {
		QuaternionRepresentation(QuaternionRepresentation.SIMDRepresentation(self.storage))
	}
}

extension Float3x3: MatrixRotation {
	public init<T: Vector3>(withRotation rotation: Rotation<T>, order: RotationOrder) where T.Component == Component {
		var matrix = Self()
		matrix.fromRotation(rotation, order: order)
		self = matrix
	}

	public func toRotation<T: Vector3>(order: RotationOrder) -> Rotation<T> where T.Component == Component {
		let orders = [order[0].index, order[1].index, order[2].index]

		var radians = T()
		let scalar = sqrt(pow(storage[orders[0], orders[0]], 2.0) + pow(storage[orders[1], orders[0]], 2.0))
		if scalar > (16.0 * Component.ulpOfOne) {
			radians[0] = atan2( storage[orders[1], orders[2]], storage[orders[2], orders[2]])
			radians[1] = atan2(-storage[orders[0], orders[2]], scalar)
			radians[2] = atan2( storage[orders[0], orders[1]], storage[orders[0], orders[0]])
		}
		else {
			radians[0] = atan2(-storage[orders[2], orders[1]], storage[orders[1], orders[1]])
			radians[1] = atan2(-storage[orders[0], orders[2]], scalar)
			radians[2] = 0.0
		}
		
		if((orders[0] == 0 && orders[1] != 1) || (orders[0] == 1 && orders[1] != 2) || (orders[0] == 2 && orders[1] != 0)) {
			for i in 0..<T.dimensions {
				radians[i] *= -1.0
			}
		}
		
		return Rotation(radians, unit: .radians)
	}

	public mutating func fromRotation<T: Vector3>(_ rotation: Rotation<T>, order: RotationOrder) where T.Component == Component {
		var matrix = Self.identity
		
		for i in 0..<3 {
			let orderAxis = order[i].index
			if (0.0 >= rotation[orderAxis].radians.nextDown && 0.0 <= rotation[orderAxis].radians.nextUp) {
				continue
			}
			
			let axis = [[2, 1], [0, 2], [1, 0]]
			let radiansSin = sin(rotation[orderAxis].radians)
			
			var temp = Self.identity
			
			temp.storage[axis[orderAxis][1], axis[orderAxis][0]] =  radiansSin
			temp.storage[axis[orderAxis][0], axis[orderAxis][1]] = -radiansSin
			temp.storage[axis[orderAxis][0], axis[orderAxis][0]] =  cos(rotation[orderAxis].radians)
			temp.storage[axis[orderAxis][1], axis[orderAxis][1]] =  temp.storage[axis[orderAxis][0], axis[orderAxis][0]]
			
			matrix *= temp
		}
		
		self = matrix
	}
}

extension Float3x3: MatrixScale {
	public typealias Scale = Float3
	
	public init(withScale scale: Component) {
		self.storage = SIMDRepresentation(diagonal: Scale.SIMDRepresentation(repeating: scale))
	}

	public init(withScale scale: Scale) {
		self.storage = SIMDRepresentation(diagonal: scale.simd)
	}

	public var scale: Scale {
		get {
			let row0 = Scale(storage[0][0], storage[0][1], storage[0][2])
			let row1 = Scale(storage[1][0], storage[1][1], storage[1][2])
			let row2 = Scale(storage[2][0], storage[2][1], storage[2][2])
			
			return Scale(row0.magnitude, row1.magnitude, row2.magnitude)
		}
		set {
			let row0 = Scale(storage[0][0], storage[0][1], storage[0][2]).normalized * newValue[0]
			let row1 = Scale(storage[1][0], storage[1][1], storage[1][2]).normalized * newValue[1]
			let row2 = Scale(storage[2][0], storage[2][1], storage[2][2]).normalized * newValue[2]
			
			self.storage[0][0] = row0[0]
			self.storage[0][1] = row0[1]
			self.storage[0][2] = row0[2]
			
			self.storage[1][0] = row1[0]
			self.storage[1][1] = row1[1]
			self.storage[1][2] = row1[2]
			
			self.storage[2][0] = row2[0]
			self.storage[2][1] = row2[1]
			self.storage[2][2] = row2[2]
		}
	}
}

extension Float3x3: MatrixTransposable {
	public var transposed: Self {
		var temp = Self()
		for columnIndex in 0..<Self.columns {
			for rowIndex in 0..<Self.rows {
				temp.storage[columnIndex][rowIndex] = storage[rowIndex][columnIndex]
			}
		}
		return temp
	}
	
	public mutating func transpose() {
		let temp = self
		for columnIndex in 0..<Self.columns {
			for rowIndex in 0..<Self.rows {
				self.storage[columnIndex][rowIndex] = temp.storage[rowIndex][columnIndex]
			}
		}
	}
}

extension Float3x3: MatrixVectorMath {
	public typealias VectorRepresentation = Float3
	
	public static func * (lhs: Self, rhs: VectorRepresentation) -> VectorRepresentation {
		VectorRepresentation(lhs.storage * rhs.simd)
	}

	public static func * (lhs: VectorRepresentation, rhs: Self) -> VectorRepresentation {
		VectorRepresentation(lhs.simd * rhs.storage)
	}
}
#else
// TODO: Add a non-simd implementation for linux.
//
	#warning("Float3x3 is not implemented on this platform.")
#endif
