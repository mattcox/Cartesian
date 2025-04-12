//
//  Double4.swift
//  Cartesian
//
//  Created by Matt Cox on 12/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import Units

#if canImport(simd) && !SKIP_SIMD_IMPLEMENTATION
import simd

/// A four-dimensional ``Vector`` containing Double values.
///
public struct Double4 {
	private var storage: SIMDRepresentation
}

extension Double4: Blendable {
	public static func blend(from: Self, to: Self, by amount: Component) -> Self {
		Self(simd_mix(from.storage, to.storage, SIMDRepresentation(repeating: amount)))
	}
	
	public mutating func blend(to other: Self, by amount: Component) {
		storage = simd_mix(storage, other.storage, SIMDRepresentation(repeating: amount))
	}
}

extension Double4: Codable {
	public init(from decoder: Decoder) throws {
		storage = try SIMDRepresentation(from: decoder)
	}

	public func encode(to encoder: Encoder) throws {
		try storage.encode(to: encoder)
	}
}

extension Double4: CustomStringConvertible {
	public var description: String {
		"[\(storage[0]), \(storage[1]), \(storage[2]), \(storage[3])]"
	}
}

extension Double4: Equatable {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		for index in 0..<Self.dimensions {
			if lhs.storage[index] != rhs.storage[index] {
				return false
			}
		}
		
		return true
	}
}

extension Double4: Sendable {
	
}

extension Double4: SIMDConvertible {
	public typealias SIMDRepresentation = simd_double4

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

extension Double4: Vector4 {
	public typealias Component = Double

	public init() {
		self.storage = SIMDRepresentation()
	}
	
	public init<C: Collection>(_ collection: C) where C.Element == Component {
		var vector = SIMDRepresentation()
		for enumerator in collection.prefix(Self.dimensions).enumerated() {
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

extension Double4: VectorDot {
	public func dot(_ other: Self) -> Component {
		simd_dot(storage, other.storage)
	}
}

extension Double4: VectorEuclidianDistance {
	public func squaredDistance(to other: Self) -> Component {
		simd_distance_squared(self.storage, other.storage)
	}
}

extension Double4: VectorMagnitude {
	public var magnitude: Component {
		get {
			simd_length(storage)
		}
		set {
			storage = simd_normalize(storage) * newValue
		}
	}
}

extension Double4: VectorMath {
	public func min() -> Component {
		storage.min()
	}
	
	public func max() -> Component {
		storage.max()
	}
	
	public func average() -> Component {
		storage.sum() / 4.0
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

extension Double4: VectorNormalizable {
	public var normalized: Self {
		Self(simd_normalize(storage))
	}

	public mutating func normalize() {
		storage = simd_normalize(storage)
	}
}

extension Double4: VectorReflection {
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
	#warning("Double4 is not implemented on this platform.")
#endif
