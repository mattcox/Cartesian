//
//  DoubleQuaternion.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import Units

#if canImport(simd) && !SKIP_SIMD_IMPLEMENTATION
import simd

/// A ``Quaternion`` containing Double values.
///
public struct DoubleQuaternion {
	private var storage: SIMDRepresentation
}

extension DoubleQuaternion: Blendable {
	public static func blend(from: Self, to: Self, by amount: Component) -> Self {
		Self(simd_slerp(from.storage, to.storage, amount))
	}
	
	public mutating func blend(to other: Self, by amount: Component) {
		storage = simd_slerp(storage, other.storage, amount)
	}
}

extension DoubleQuaternion: Codable {
	public init(from decoder: Decoder) throws {
		// Decode the values as a flat array of components. There should be
		// 4 values.
		//
		let values = try Array<Component>(from: decoder)
		if values.count != 4 {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid number of values to decode"))
		}
		
		self.storage = SIMDRepresentation(ix: values[0], iy: values[1], iz: values[2], r: values[3])
	}

	public func encode(to encoder: Encoder) throws {
		// Values are encoded as a flat array of components.
		//
		var values = [Component]()
		values.append(storage.imag[0])
		values.append(storage.imag[1])
		values.append(storage.imag[2])
		values.append(storage.real)
		try values.encode(to: encoder)
	}
}

extension DoubleQuaternion: CustomStringConvertible {
	public var description: String {
		"[\(imaginary), \(real)]"
	}
}

extension DoubleQuaternion: Equatable {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		let lhsImaginary = lhs.storage.imag
		let rhsImaginary = rhs.storage.imag
		
		for index in 0..<3 {
			if lhsImaginary[index] != rhsImaginary[index] {
				return false
			}
		}
		
		if lhs.storage.real != rhs.storage.real {
			return false
		}
		
		return true
	}
}

extension DoubleQuaternion: Invertible {
	public var inverse: Self {
		Self(simd_inverse(storage))
	}

	public mutating func invert() {
		storage = simd_inverse(storage)
	}
}

extension DoubleQuaternion: Quaternion {
	public typealias Component = Double
	public typealias Imaginary = Double3
	
	public var imaginary: Imaginary {
		get {
			Imaginary(storage.imag)
		}
		set {
			storage.imag = newValue.simd
		}
	}
	
	public var real: Real {
		get {
			storage.real
		}
		set {
			storage.real = newValue
		}
	}
	
	public init() {
		self.storage = SIMDRepresentation()
	}
	
	public init<V>(with vector: V) where V : Vector4, Component == V.Component {
		self.storage = SIMDRepresentation(ix: vector[0], iy: vector[1], iz: vector[2], r: vector[3])
	}
	
	public init<V>(from: V, to: V) where V : Vector3, Component == V.Component {
		self.storage = SIMDRepresentation(from: simd_double3(from[0], from[1], from[2]), to: simd_double3(to[0], to[1], to[2]))
	}

	public init(imaginary: Imaginary, real: Real) {
		self.storage = SIMDRepresentation(ix: imaginary[0], iy: imaginary[1], iz: imaginary[2], r: real)
	}
	
	public init(imaginaryX x: Component, y: Component, z: Component, real: Component) {
		self.storage = SIMDRepresentation(ix: x, iy: y, iz: z, r: real)
	}
}

extension DoubleQuaternion: QuaternionAxisAngle {
	public typealias AngleRepresentation = Double
	public typealias AxisRepresentation = Double3
	
	public var axis: AxisRepresentation {
		get {
			AxisRepresentation(storage.axis)
		}
		set {
			self.storage = SIMDRepresentation(angle: storage.angle, axis: newValue.simd)
		}
	}
	
	public var angle: Angle<AngleRepresentation> {
		get {
			Angle(storage.angle, unit: .radians)
		}
		set {
			self.storage = SIMDRepresentation(angle: newValue.radians, axis: storage.axis)
		}
	}
	
	public init(withAxis axis: AxisRepresentation, angle: Angle<AngleRepresentation>) {
		self.storage = SIMDRepresentation(angle: angle.radians, axis: axis.simd)
	}
}

extension DoubleQuaternion: QuaternionMagnitude {
	public var magnitude: Component {
		get {
			simd_length(storage)
		}
		set {
			storage = simd_mul(simd_normalize(storage), newValue)
		}
	}
}

extension DoubleQuaternion: QuaternionMath {
	public static func + (lhs: Self, rhs: Self) -> Self {
		Self(simd_add(lhs.storage, rhs.storage))
	}
	
	public static func += (lhs: inout Self, rhs: Self) {
		lhs.storage = simd_add(lhs.storage, rhs.storage)
	}
	
	public static func - (lhs: Self, rhs: Self) -> Self {
		Self(simd_sub(lhs.storage, rhs.storage))
	}
	
	public static func -= (lhs: inout Self, rhs: Self) {
		lhs.storage = simd_sub(lhs.storage, rhs.storage)
	}
	
	public static prefix func - (vector: Self) -> Self {
		Self(simd_negate(vector.storage))
	}
	
	public static func * (lhs: Self, rhs: Self) -> Self {
		Self(simd_mul(lhs.storage, rhs.storage))
	}
	
	public static func *= (lhs: inout Self, rhs: Self) {
		lhs.storage = simd_mul(lhs.storage, rhs.storage)
	}
	
	public static func * (lhs: Self, rhs: Component) -> Self {
		Self(simd_mul(lhs.storage, rhs))
	}
	
	public static func * (lhs: Component, rhs: Self) -> Self {
		Self(simd_mul(lhs, rhs.storage))
	}
	
	public static func *= (lhs: inout Self, rhs: Component) {
		lhs.storage = simd_mul(lhs.storage, rhs)
	}
}

extension DoubleQuaternion: QuaternionMatrixConvertible {
	public typealias MatrixRepresentation = Double3x3

	public init(withMatrix matrix: MatrixRepresentation) {
		self = Self(SIMDRepresentation(matrix.simd))
	}
	
	public var matrix: MatrixRepresentation {
		MatrixRepresentation(MatrixRepresentation.SIMDRepresentation(storage))
	}
}

extension DoubleQuaternion: QuaternionNormalizable {
	public var normalized: Self {
		Self(simd_normalize(storage))
	}
	
	public mutating func normalize() {
		storage = simd_normalize(storage)
	}
}

extension DoubleQuaternion: QuaternionVectorRotation {
	public func rotate<V: Vector3>(vector: V) -> V where V.Component == Component {
		let vector = storage.act(simd_double3(vector.first, vector.second, vector.third))
		return V(vector[0], vector[1], vector[2])
	}
}

extension DoubleQuaternion: Sendable {
	
}

extension DoubleQuaternion: SIMDConvertible {
	public typealias SIMDRepresentation = simd_quatd

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
#else
// TODO: Add a non-simd implementation for linux.
//
	#warning("DoubleQuaternion is not implemented on this platform.")
#endif
