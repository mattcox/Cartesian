//
//  Float3.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import Units

#if canImport(simd) && !SKIP_SIMD_IMPLEMENTATION
import simd

/// A three-dimensional ``Vector`` containing Float values.
///
public struct Float3 {
	private var storage: SIMDRepresentation
}

extension Float3: Blendable {
	public static func blend(from: Self, to: Self, by amount: Component) -> Self {
		Self(simd_mix(from.storage, to.storage, SIMDRepresentation(repeating: amount)))
	}
	
	public mutating func blend(to other: Self, by amount: Component) {
		storage = simd_mix(storage, other.storage, SIMDRepresentation(repeating: amount))
	}
}

extension Float3: Codable {
	public init(from decoder: Decoder) throws {
		// Decode the values as a flat array of components. There should be
		// 3 values, as this is a 3 dimensional vector.
		//
		let values = try Array<Component>(from: decoder)
		if values.count != Self.count {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid number of values to decode"))
		}
		
		self.storage = SIMDRepresentation(values[0], values[1], values[2])
	}

	public func encode(to encoder: Encoder) throws {
		// Values are encoded as a flat array of components. There should be
		// 3 values as this is a 3 dimensional vector.
		//
		try [storage[0], storage[1], storage[2]].encode(to: encoder)
	}
}

extension Float3: CustomStringConvertible {
	public var description: String {
		"[\(storage[0]), \(storage[1]), \(storage[2])]"
	}
}

extension Float3: Equatable {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		for index in 0..<Self.count {
			if lhs.storage[index] != rhs.storage[index] {
				return false
			}
		}
		
		return true
	}
}

extension Float3: Sendable {
	
}

extension Float3: SIMDConvertible {
	public typealias SIMDRepresentation = simd_float3

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

extension Float3: Vector3 {
	public typealias Component = Float

	public init() {
		self.storage = SIMDRepresentation()
	}
	
	public init<C: Collection>(_ collection: C) where C.Element == Component {
		var vector = SIMDRepresentation()
		for enumerator in collection.prefix(Self.count).enumerated() {
			vector[enumerator.offset] = enumerator.element
		}
		self.storage = vector
	}
	
	public subscript(index: Int) -> Component {
		get {
			storage[index]
		}
		set {
			storage[index] = newValue
		}
	}
	
	public mutating func clear() {
		self.storage = SIMDRepresentation()
	}
}

extension Float3: Vector3Rotatable {
	public func rotated(x: Angle<Component>, y: Angle<Component>, z: Angle<Component>, order: RotationOrder) -> Self {
		self * Float3x3(withRotation: Rotation(Self(x.radians, y.radians, z.radians), unit: .radians), order: order)
	}

	public func rotated<T: Vector3>(by rotation: Rotation<T>, order: RotationOrder) -> Self where T.Component == Component {
		self * Float3x3(withRotation: rotation, order: order)
	}
	
	public mutating func rotate(x: Angle<Component>, y: Angle<Component>, z: Angle<Component>, order: RotationOrder) {
		self = self * Float3x3(withRotation: Rotation(Self(x.radians, y.radians, z.radians)), order: order)
	}

	public mutating func rotate<T: Vector3>(by rotation: Rotation<T>, order: RotationOrder) where T.Component == Component {
		self = self * Float3x3(withRotation: rotation, order: order)
	}
}

extension Float3: VectorAngle {
	public static func angle(from: Self, to: Self, by: Self?) -> Angle<Component> {
		let by = by ?? .zero
		
		let fromNormalized = (from - by).normalized
		let toNormalized = (to - by).normalized
		
		let dotProduct = fromNormalized.dot(toNormalized)
		let angle = acos(dotProduct)
		
		return Angle(radians: angle)
	}
}

extension Float3: VectorCross {
	public func cross(_ other: Self) -> Self {
		Self(simd_cross(storage, other.storage))
	}
	
	public static func ⨯= (lhs: inout Self, rhs: Self) {
		lhs.storage = simd_cross(lhs.storage, rhs.storage)
	}
}

extension Float3: VectorDot {
	public func dot(_ other: Self) -> Component {
		simd_dot(storage, other.storage)
	}
}

extension Float3: VectorEuclidianDistance {
	public func squaredDistance(to other: Self) -> Component {
		simd_distance_squared(self.storage, other.storage)
	}
}

extension Float3: VectorMagnitude {
	public var magnitude: Component {
		get {
			simd_length(storage)
		}
		set {
			storage = simd_normalize(storage) * newValue
		}
	}
}

extension Float3: VectorMath {
	public func min() -> Component {
		storage.min()
	}
	
	public func max() -> Component {
		storage.max()
	}
	
	public func average() -> Component {
		storage.sum() / 3.0
	}
	
	public func sum() -> Component {
		storage.sum()
	}
	
	public static func + (lhs: Self, rhs: Self) -> Self {
		Self(lhs.storage + rhs.storage)
	}

	public static func += (lhs: inout Self, rhs: Self) {
		lhs.storage += rhs.storage
	}

	public static func + (lhs: Self, rhs: Component) -> Self {
		Self(lhs.storage + rhs)
	}

	public static func + (lhs: Component, rhs: Self) -> Self {
		Self(lhs + rhs.storage)
	}

	public static func += (lhs: inout Self, rhs: Component) {
		lhs.storage += rhs
	}

	public static func - (lhs: Self, rhs: Self) -> Self {
		Self(lhs.storage - rhs.storage)
	}

	public static func -= (lhs: inout Self, rhs: Self) {
		lhs.storage -= rhs.storage
	}

	public static func - (lhs: Self, rhs: Component) -> Self {
		Self(lhs.storage - rhs)
	}

	public static func - (lhs: Component, rhs: Self) -> Self {
		Self(lhs + rhs.storage)
	}

	public static func -= (lhs: inout Self, rhs: Component) {
		lhs.storage -= rhs
	}

	public static prefix func - (vector: Self) -> Self {
		Self(-vector.storage)
	}

	public static func * (lhs: Self, rhs: Self) -> Self {
		Self(lhs.storage * rhs.storage)
	}

	public static func *= (lhs: inout Self, rhs: Self) {
		lhs.storage *= rhs.storage
	}

	public static func * (lhs: Self, rhs: Component) -> Self {
		Self(lhs.storage * rhs)
	}

	public static func * (lhs: Component, rhs: Self) -> Self {
		Self(lhs * rhs.storage)
	}
	
	public static func *= (lhs: inout Self, rhs: Component) {
		lhs.storage *= rhs
	}

	public static func / (lhs: Self, rhs: Self) -> Self {
		Self(lhs.storage / rhs.storage)
	}

	public static func /= (lhs: inout Self, rhs: Self) {
		lhs.storage /= rhs.storage
	}

	public static func / (lhs: Self, rhs: Component) -> Self {
		Self(lhs.storage / rhs)
	}

	public static func /= (lhs: inout Self, rhs: Component) {
		lhs.storage /= rhs
	}
}

extension Float3: VectorNormalizable {
	public var normalized: Self {
		Self(simd_normalize(storage))
	}

	public mutating func normalize() {
		storage = simd_normalize(storage)
	}
}

extension Float3: VectorQuaternionRotation {
	public func rotated<T>(by quaternion: T) -> Self where T: QuaternionVectorRotation, T.Component == Component {
		quaternion.rotate(vector: self)
	}
	
	public mutating func rotate<T>(by quaternion: T) where T: QuaternionVectorRotation, T.Component == Component {
		self = quaternion.rotate(vector: self)
	}
}

extension Float3: VectorReflection {
	public func reflection(withNormal normal: Self) -> Self {
		Self(reflect(storage, n: normal.storage))
	}
	
	public func refraction(withNormal normal: Self, indexOfRefraction: Component) -> Self {
		Self(refract(storage, n: normal.storage, eta: indexOfRefraction))
	}
}
#else
// TODO: Add a non-simd implementation for linux.
//
	#warning("Float3 is not implemented on this platform.")
#endif
