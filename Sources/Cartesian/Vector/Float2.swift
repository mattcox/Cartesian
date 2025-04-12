//
//  Float2.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import Units

#if canImport(simd) && !SKIP_SIMD_IMPLEMENTATION
import simd

/// A two-dimensional ``Vector`` containing Float values.
///
public struct Float2 {
	private var storage: SIMDRepresentation
}

extension Float2: Blendable {
	public static func blend(from: Self, to: Self, by amount: Component) -> Self {
		Self(simd_mix(from.storage, to.storage, SIMDRepresentation(repeating: amount)))
	}
	
	public mutating func blend(to other: Self, by amount: Component) {
		storage = simd_mix(storage, other.storage, SIMDRepresentation(repeating: amount))
	}
}

extension Float2: Codable {
	public init(from decoder: Decoder) throws {
		// Decode the values as a flat array of components. There should be
		// 2 values, as this is a 2 dimensional vector.
		//
		let values = try Array<Component>(from: decoder)
		if values.count != Self.count {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid number of values to decode"))
		}
		
		self.storage = SIMDRepresentation(values[0], values[1])
	}

	public func encode(to encoder: Encoder) throws {
		// Values are encoded as a flat array of components. There should be
		// 2 values as this is a 2 dimensional vector.
		//
		try [storage[0], storage[1]].encode(to: encoder)
	}
}

extension Float2: CustomStringConvertible {
	public var description: String {
		"[\(storage[0]), \(storage[1])]"
	}
}

extension Float2: Equatable {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		for index in 0..<Self.count {
			if lhs.storage[index] != rhs.storage[index] {
				return false
			}
		}
		
		return true
	}
}

extension Float2: Sendable {
	
}

extension Float2: SIMDConvertible {
	public typealias SIMDRepresentation = simd_float2

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

extension Float2: Vector2 {
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

extension Float2: Vector2Rotatable {
	public func rotated(by angle: Angle<Component>) -> Self {
		let radians = angle.radians
			
		let u = self[0] * cos(radians) - self[1] * sin(radians)
		let v = self[0] * sin(radians) + self[1] * cos(radians)
			
		return Self(u, v)
	}
	
	public mutating func rotate(by angle: Angle<Component>) {
		let radians = angle.radians
			
		let u = self[0] * cos(radians) - self[1] * sin(radians)
		let v = self[0] * sin(radians) + self[1] * cos(radians)
			
		self = Self(u, v)
	}
}

extension Float2: VectorAngle {
	public static func angle(from: Self, to: Self, by: Self?) -> Angle<Component> {
		let by = by ?? Self.zero
		
		let fromNormalized = (from - by).normalized
		let toNormalized = (to - by).normalized
		
		let dotProduct = fromNormalized.dot(toNormalized)
		let radians = acos(dotProduct)
		
		return Angle(radians: radians)
	}
}

extension Float2: VectorDot {
	public func dot(_ other: Self) -> Component {
		simd_dot(storage, other.storage)
	}
}

extension Float2: VectorEuclidianDistance {
	public func squaredDistance(to other: Self) -> Component {
		simd_distance_squared(self.storage, other.storage)
	}
}

extension Float2: VectorMagnitude {
	public var magnitude: Component {
		get {
			simd_length(storage)
		}
		set {
			storage = simd_normalize(storage) * newValue
		}
	}
}

extension Float2: VectorMath {
	public func min() -> Component {
		storage.min()
	}
	
	public func max() -> Component {
		storage.max()
	}
	
	public func average() -> Component {
		storage.sum() / 2.0
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

extension Float2: VectorNormalizable {
	public var normalized: Self {
		Self(simd_normalize(storage))
	}

	public mutating func normalize() {
		storage = simd_normalize(storage)
	}
}

extension Float2: VectorReflection {
	public func reflection(withNormal normal: Self) -> Self {
		Self(reflect(storage, n: normal.storage))
	}
	
	public func refraction(withNormal normal: Self, indexOfRefraction: Component) -> Self {
		Self(refract(storage, n: normal.storage, eta: indexOfRefraction))
	}
}
#else
import Foundation

/// A two-dimensional ``Vector`` containing Float values.
///
public struct Float2 {
	private var storage: (Float, Float)
}

extension Float2: Blendable {
	public static func blend(from: Self, to: Self, by amount: Component) -> Self {
		var vector = Self()
		for i in 0..<Self.count {
			vector[i] = from[i] + (to[i] - from[i]) * amount
		}
		return vector
	}
	
	public mutating func blend(to other: Self, by amount: Component) {
		var vector = Self()
		for i in 0..<Self.count {
			vector[i] = self[i] + (other[i] - self[i]) * amount
		}
		self.storage = vector.storage
	}
}

extension Float2: Codable {
	public init(from decoder: Decoder) throws {
		// Decode the values as a flat array of components. There should be
		// 2 values, as this is a 2 dimensional vector.
		//
		let values = try Array<Component>(from: decoder)
		if values.count != Self.count {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid number of values to decode"))
		}
		
		self = Self(values)
	}

	public func encode(to encoder: Encoder) throws {
		// Values are encoded as a flat array of components. There should be
		// 2 values as this is a 2 dimensional vector.
		//
		try [storage.0, storage.1].encode(to: encoder)
	}
}

extension Float2: CustomStringConvertible {
	public var description: String {
		"[\(storage.0), \(storage.1)]"
	}
}

extension Float2: Equatable {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.storage.0 == rhs.storage.0 && lhs.storage.1 == rhs.storage.1
	}
}

extension Float2: Sendable {
	
}

extension Float2: Vector2 {
	public typealias Component = Float
	
	public init() {
		self.storage = (.zero, .zero)
	}
	
	public init<C: Collection>(_ collection: C) where C.Element == Component {
		var vector = Self()
		for enumerator in collection.prefix(Self.count).enumerated() {
			vector[enumerator.offset] = enumerator.element
		}
		self = vector
	}
	
	public subscript(index: Int) -> Component {
		get {
			switch index {
				case 0:
					storage.0
				case 1:
					storage.1
				default:
					preconditionFailure("Index out of range")
			}
		}
		set {
			switch index {
				case 0:
					storage.0 = newValue
				case 1:
					storage.1 = newValue
				default:
					preconditionFailure("Index out of range")
			}
		}
	}
	
	public mutating func clear() {
		self.storage = (.zero, .zero)
	}
}

extension Float2: Vector2Rotatable {
	public func rotated(by angle: Angle<Component>) -> Self {
		let radians = angle.radians
			
		let u = storage.0 * cos(radians) - storage.1 * sin(radians)
		let v = storage.0 * sin(radians) + storage.1 * cos(radians)
			
		return Self(u, v)
	}
	
	public mutating func rotate(by angle: Angle<Component>) {
		let radians = angle.radians
			
		let u = storage.0 * cos(radians) - storage.1 * sin(radians)
		let v = storage.0 * sin(radians) + storage.1 * cos(radians)
			
		self = Self(u, v)
	}
}

extension Float2: VectorAngle {
	public static func angle(from: Self, to: Self, by: Self?) -> Angle<Component> {
		let by = by ?? Self.zero
		
		let fromNormalized = (from - by).normalized
		let toNormalized = (to - by).normalized
		
		let dotProduct = fromNormalized.dot(toNormalized)
		let radians = acos(dotProduct)
		
		return Angle(radians: radians)
	}
}

extension Float2: VectorDot {
	public func dot(_ other: Self) -> Component {
		storage.0 * other.storage.0 + storage.1 * other.storage.1
	}
}

extension Float2: VectorEuclidianDistance {
	public func squaredDistance(to other: Self) -> Component {
		pow((storage.0 - other.storage.0), 2) + pow((storage.1 - other.storage.1), 2)
	}
}

extension Float2: VectorMagnitude {
	public var magnitude: Component {
		get {
			sqrt(pow(storage.0, 2) + pow(storage.1, 2))
		}
		set {
			let factor = 1.0 / sqrt(pow(storage.0, 2) + pow(storage.1, 2))
			storage.0 *= factor * newValue
			storage.1 *= factor * newValue
		}
	}
}

extension Float2: VectorMath {
	public func min() -> Component {
		Swift.min(storage.0, storage.1)
	}
	
	public func max() -> Component {
		Swift.max(storage.0, storage.1)
	}
	
	public func average() -> Component {
		sum() / 2
	}
	
	public func sum() -> Component {
		storage.0 + storage.1
	}
	
	public static func + (lhs: Self, rhs: Self) -> Self {
		Self(lhs.storage.0 + rhs.storage.0, lhs.storage.1 + rhs.storage.1)
	}

	public static func += (lhs: inout Self, rhs: Self) {
		lhs.storage.0 += rhs.storage.0
		lhs.storage.1 += rhs.storage.1
	}

	public static func + (lhs: Self, rhs: Component) -> Self {
		Self(lhs.storage.0 + rhs, lhs.storage.1 + rhs)
	}

	public static func + (lhs: Component, rhs: Self) -> Self {
		Self(lhs + rhs.storage.0, lhs + rhs.storage.1)
	}

	public static func += (lhs: inout Self, rhs: Component) {
		lhs.storage.0 += rhs
		lhs.storage.1 += rhs
	}

	public static func - (lhs: Self, rhs: Self) -> Self {
		Self(lhs.storage.0 - rhs.storage.0, lhs.storage.1 - rhs.storage.1)
	}

	public static func -= (lhs: inout Self, rhs: Self) {
		lhs.storage.0 -= rhs.storage.0
		lhs.storage.1 -= rhs.storage.1
	}

	public static func - (lhs: Self, rhs: Component) -> Self {
		Self(lhs.storage.0 - rhs, lhs.storage.1 - rhs)
	}

	public static func - (lhs: Component, rhs: Self) -> Self {
		Self(lhs - rhs.storage.0, lhs - rhs.storage.1)
	}

	public static func -= (lhs: inout Self, rhs: Component) {
		lhs.storage.0 -= rhs
		lhs.storage.1 -= rhs
	}

	public static prefix func - (vector: Self) -> Self {
		Self(-vector.storage.0, -vector.storage.1)
	}

	public static func * (lhs: Self, rhs: Self) -> Self {
		Self(lhs.storage.0 * rhs.storage.0, lhs.storage.1 * rhs.storage.1)
	}

	public static func *= (lhs: inout Self, rhs: Self) {
		lhs.storage.0 *= rhs.storage.0
		lhs.storage.1 *= rhs.storage.1
	}

	public static func * (lhs: Self, rhs: Component) -> Self {
		Self(lhs.storage.0 * rhs, lhs.storage.1 * rhs)
	}

	public static func * (lhs: Component, rhs: Self) -> Self {
		Self(lhs * rhs.storage.0, lhs * rhs.storage.1)
	}
	
	public static func *= (lhs: inout Self, rhs: Component) {
		lhs.storage.0 *= rhs
		lhs.storage.1 *= rhs
	}

	public static func / (lhs: Self, rhs: Self) -> Self {
		Self(lhs.storage.0 / rhs.storage.0, lhs.storage.1 / rhs.storage.1)
	}

	public static func /= (lhs: inout Self, rhs: Self) {
		lhs.storage.0 /= rhs.storage.0
		lhs.storage.1 /= rhs.storage.1
	}

	public static func / (lhs: Self, rhs: Component) -> Self {
		Self(lhs.storage.0 / rhs, lhs.storage.1 / rhs)
	}

	public static func /= (lhs: inout Self, rhs: Component) {
		lhs.storage.0 /= rhs
		lhs.storage.1 /= rhs
	}
}

extension Float2: VectorNormalizable {
	public var normalized: Self {
		self / magnitude
	}
}

extension Float2: VectorReflection {
	public func reflection(withNormal normal: Self) -> Self {
		let normal = normal.normalized
		return self - (2 * dot(normal) * normal)
	}
	
	public func refraction(withNormal normal: Self, indexOfRefraction: Component) -> Self {
		let rayDirection = self.normalized
		let normal = normal.normalized
		
		let cosAngleOfIncidence = -rayDirection.dot(normal)
		let sinSquaredAngleOfRefraction = pow(indexOfRefraction, 2) * (1 - pow(cosAngleOfIncidence, 2))
		
		if sinSquaredAngleOfRefraction > 1 {
			return .zero
		}
		
		let cosAngleOfRefraction = sqrt(1 - sinSquaredAngleOfRefraction)
		
		let directionParallelToSurface = rayDirection * indexOfRefraction
		let directionPerpendicularToSurface = normal * (indexOfRefraction * cosAngleOfIncidence - cosAngleOfRefraction)
	
		return directionParallelToSurface + directionPerpendicularToSurface
	}
}
#endif
