//
//  Vector4.swift
//  Cartesian
//
//  Created by Matt Cox on 14/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import RealModule
import Units

/// A vector with four scalar components.
///
public struct Vector4<Component: Real & SIMDScalar> {
	private var storage: SIMDRepresentation
}

extension Vector4 {
/// Initialize the vector using individual X, Y, Z and W components.
///
/// - Parameters:
///   - x: The first component of the vector.
///   - y: The second component of the vector.
///   - z: The third component of the vector.
///   - w: The fourth component of the vector.
///
	public init(x: Component, y: Component, z: Component, w: Component) {
		self.storage = SIMDRepresentation(x: x, y: y, z: z, w: w)
	}
	
/// Initialize the vector using individual components.
///
/// - Parameters:
///   - first: The first component of the vector.
///   - second: The second component of the vector.
///   - third: The third component of the vector.
///   - fourth: The fourth component of the vector.
///
	public init(_ first: Component, _ second: Component, _ third: Component, _ fourth: Component) {
		self.storage = SIMDRepresentation(x: first, y: second, z: third, w: fourth)
	}
	
/// The first component of the vector.
///
	public var first: Component {
		get {
			storage.x
		}
		set {
			storage.x = newValue
		}
	}

/// The second component of the vector.
///
	public var second: Component {
		get {
			storage.y
		}
		set {
			storage.y = newValue
		}
	}
	
/// The third component of the vector.
///
	public var third: Component {
		get {
			storage.z
		}
		set {
			storage.z = newValue
		}
	}
	
/// The fourth component of the vector.
///
	public var fourth: Component {
		get {
			storage.w
		}
		set {
			storage.w = newValue
		}
	}
	
/// The first component of the vector.
///
	public var x: Component {
		get {
			storage.x
		}
		set {
			storage.x = newValue
		}
	}

/// The second component of the vector.
///
	public var y: Component {
		get {
			storage.y
		}
		set {
			storage.y = newValue
		}
	}
	
/// The third component of the vector.
///
	public var z: Component {
		get {
			storage.z
		}
		set {
			storage.z = newValue
		}
	}
	
/// The fourth component of the vector.
///
	public var w: Component {
		get {
			storage.w
		}
		set {
			storage.w = newValue
		}
	}
}

extension Vector4: AngleMeasurable where Component: BinaryFloatingPoint {
/// Computes the angle between two vectors.
///
/// An optional third vector can be provided describing the pivot the angle
/// is measured at. If this is undefined, a pivot vector of zero is used.
///
/// - Parameters:
///   - from: The incoming vector in the angle measurement.
///   - to: The outgoing vector in the angle measurement.
///   - by: An optional vector describing the position the angle should
///   be measured.
///
/// - Returns: The angle formed by the vectors.
///
	public static func angle(from: Self, to: Self, by: Self?) -> Angle<Component> {
		let by = by ?? Self.zero
		
		let fromNormalized = (from - by).normalized
		let toNormalized = (to - by).normalized
		
		let dotProduct = fromNormalized.dot(toNormalized).clamped(between: -1, and: 1)
		
		return Angle(radians: Component.acos(dotProduct))
	}
}

extension Vector4: Blendable {
	public static func blend(from: Self, to: Self, by amount: Component) -> Self {
		Self(from.storage + (to.storage - from.storage) * amount)
	}
	
	public mutating func blend(to other: Self, by amount: Component) {
		storage = storage + (other.storage - storage) * amount
	}
}

extension Vector4: Codable {
	public init(from decoder: Decoder) throws {
		let values = try Array<Component>(from: decoder)
		if values.count != Self.count {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid number of values to decode"))
		}
		self.storage = SIMDRepresentation(values)
	}

	public func encode(to encoder: Encoder) throws {
		var values: [Component] = []
		for i in 0..<Self.count {
			values.append(storage[i])
		}
		try values.encode(to: encoder)
	}
}

extension Vector4: CustomStringConvertible where Component: CVarArg {
	public var description: String {
		"""
		[ \(String(format: "%.3f", storage[0]))  \(String(format: "%.3f", storage[1]))  \(String(format: "%.3f", storage[2]))  \(String(format: "%.3f", storage[3])) ]
		"""
	}
}

extension Vector4: DotProduct {
/// Computes the dot product of this vector and the provided vector.
///
/// The dot product of two vectors is a scalar value encoding the cosine of
/// the angle between the two vectors. If the source vectors are
/// non-normalized, the resulting angle will be multiplied by the magnitude
/// of the source vectors.
///
/// - Parameters:
///   - other: The vector to calculate a dot product against.
///
/// - Returns: A value containing the result of the dot product.
///
	public func dot(_ other: Self) -> Component {
		storage.x * other.storage.x +
		storage.y * other.storage.y +
		storage.z * other.storage.z +
		storage.w * other.storage.w
	}
}

extension Vector4: Equatable {
	
}

extension Vector4: EuclidianDistanceMeasurable {
/// Computes the straight-line euclidian distance from this vector to
/// another.
///
/// - Parameters:
///   - other: The vector to measure the distance to.
///
/// - Returns: The euclidian distance between the two vectors.
///
	public func distance(to other: Self) -> Component {
		Component.sqrt(squaredDistance(to: other))
	}

/// Computes the squared straight-line euclidian distance from this vector
/// to another.
///
/// This skips the final square root calculation, and can be useful for
/// performing faster comparisons of distances where the relative distances
/// is important, but an accurate distance is unnecessary.
///
/// - Parameters:
///   - other: The vector to measure the distance to.
///
/// - Returns: The squared euclidian distance between the two vectors.
///
	public func squaredDistance(to other: Self) -> Component {
		Component.pow((storage.x - other.storage.x), 2) +
		Component.pow((storage.y - other.storage.y), 2) +
		Component.pow((storage.z - other.storage.z), 2) +
		Component.pow((storage.w - other.storage.w), 2)
	}
}

extension Vector4: ExpressibleByArrayLiteral {
/// Initialize the vector from an array literal.
///
/// For example, the vector can be initialized as follows:
/// ```swift
/// let vector: Vector4 = [1.0, 2.0, 3.0, 4.0]
/// ```
///
	public init(arrayLiteral elements: Component...) {
		var vector = Self()
		for i in 0..<Swift.min(Self.count, elements.count) {
			vector.storage[i] = elements[i]
		}
		self = vector
	}
}

extension Vector4: MagnitudeAdjustable {
/// The magnitude or length of the vector.
///
	public var magnitude: Component {
		get {
			Component.sqrt(Component.pow(storage.x, 2) + Component.pow(storage.y, 2) + Component.pow(storage.z, 2) + Component.pow(storage.w, 2))
		}
		set {
			let length = Component.sqrt(Component.pow(storage.x, 2) + Component.pow(storage.y, 2) + Component.pow(storage.z, 2) + Component.pow(storage.w, 2))
			if length.isApproximatelyEqual(to: .zero) {
				return
			}
			let factor = newValue / length
			storage.x *= factor
			storage.y *= factor
			storage.z *= factor
			storage.w *= factor
		}
	}
}

extension Vector4: MagnitudeMeasurable {
	
}

extension Vector4: Normalizable {
/// Normalizes the vector, setting its magnitude to 1.0.
///
/// Returns a unit vector that maintains the same direction as the original 
/// but has a length of 1.0.
///
/// - Warning: If the vector has zero length, the behavior of this function
/// is undefined.
///
	public var normalized: Self {
		let length = magnitude
		precondition(length.isApproximatelyEqual(to: .zero) == false, "Attempted to normalize a zero-length vector.")
		return self / length
	}

/// Normalizes the vector, setting its magnitude to 1.0.
///
/// This modifies the vector in place, scaling its components so that the
/// resulting vector has unit length and retains the original direction.
///
/// - Warning: If the vector has zero length, the behavior of this function
/// is undefined.
///
	public mutating func normalize() {
		let length = magnitude
		precondition(length.isApproximatelyEqual(to: .zero) == false, "Attempted to normalize a zero-length vector.")
		self /= length
	}
}

extension Vector4: Sendable where SIMDRepresentation: Sendable {
	
}

extension Vector4: SIMDConvertible {
	public typealias SIMDRepresentation = SIMD4<Component>
	
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

extension Vector4: VectorMath {
	public func min() -> Component {
		storage.min()
	}
	
	public func max() -> Component {
		storage.max()
	}
	
	public func average() -> Component {
		storage.sum() / Component(Self.count)
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
		Self(lhs - rhs.storage)
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

extension Vector4: VectorProtocol {
	public static var count: Int {
		SIMDRepresentation.scalarCount
	}
	
	public init() {
		self.storage = SIMDRepresentation()
	}
	
	public init<C>(_ collection: C) where C : Collection, Component == C.Element {
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
		storage = SIMDRepresentation()
	}
}


extension Vector4: VectorReflectable {
	public func reflection(withNormal normal: Self) -> Self {
		let normal = normal.normalized
		return self - (2 * dot(normal) * normal)
	}
}

extension Vector4: VectorRefractable {
	public func refraction(withNormal normal: Self, indexOfRefraction: Component) -> Self {
		let rayDirection = self.normalized
		let normal = normal.normalized

		let cosAngleOfIncidence = -rayDirection.dot(normal)
		let sinSquaredAngleOfRefraction = Component.pow(indexOfRefraction, 2) * (1 - Component.pow(cosAngleOfIncidence, 2))

		if sinSquaredAngleOfRefraction > 1 {
			return .zero
		}

		let cosAngleOfRefraction = Component.sqrt(1 - sinSquaredAngleOfRefraction)

		let directionParallelToSurface = rayDirection * indexOfRefraction
		let directionPerpendicularToSurface = normal * (indexOfRefraction * cosAngleOfIncidence - cosAngleOfRefraction)

		return directionParallelToSurface + directionPerpendicularToSurface
	}
}
