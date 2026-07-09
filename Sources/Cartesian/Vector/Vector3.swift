//
//  Vector3.swift
//  Cartesian
//
//  Created by Matt Cox on 14/04/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import RealModule
import Units

/// A vector with three scalar components.
///
public struct Vector3<Component: Real & SIMDScalar> {
	@usableFromInline
	var storage: SIMDRepresentation
}

extension Vector3 {
/// Initialize the vector using individual X, Y and Z components.
///
/// - Parameters:
///   - x: The first component of the vector.
///   - y: The second component of the vector.
///   - z: The third component of the vector.
///
	@inlinable
	public init(x: Component, y: Component, z: Component) {
		self.storage = SIMDRepresentation(x: x, y: y, z: z)
	}
	
/// Initialize the vector using individual components.
///
/// - Parameters:
///   - first: The first component of the vector.
///   - second: The second component of the vector.
///   - third: The third component of the vector.
///
	@inlinable
	public init(_ first: Component, _ second: Component, _ third: Component) {
		self.storage = SIMDRepresentation(x: first, y: second, z: third)
	}
	
/// The first component of the vector.
///
	@inlinable
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
	@inlinable
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
	@inlinable
	public var third: Component {
		get {
			storage.z
		}
		set {
			storage.z = newValue
		}
	}
	
/// The first component of the vector.
///
	@inlinable
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
	@inlinable
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
	@inlinable
	public var z: Component {
		get {
			storage.z
		}
		set {
			storage.z = newValue
		}
	}
}

extension Vector3: AngleMeasurable where Component: BinaryFloatingPoint {
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
	@inlinable
	public static func angle(from: Self, to: Self, by: Self?) -> Angle<Component> {
		let by = by ?? Self.zero
		
		let fromNormalized = (from - by).normalized
		let toNormalized = (to - by).normalized
		
		let dotProduct = fromNormalized.dot(toNormalized).clamped(between: -1, and: 1)
		
		return Angle(radians: Component.acos(dotProduct))
	}
}

extension Vector3: Blendable {
	@inlinable
	public static func blend(from: Self, to: Self, by amount: Component) -> Self {
		Self(from.storage + (to.storage - from.storage) * amount)
	}
	
	@inlinable
	public mutating func blend(to other: Self, by amount: Component) {
		storage = storage + (other.storage - storage) * amount
	}
}

extension Vector3: Codable {
	@inlinable
	public init(from decoder: Decoder) throws {
		let values = try Array<Component>(from: decoder)
		if values.count != Self.count {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid number of values to decode"))
		}
		self.storage = SIMDRepresentation(values)
	}

	@inlinable
	public func encode(to encoder: Encoder) throws {
		var values: [Component] = []
		for i in 0..<Self.count {
			values.append(storage[i])
		}
		try values.encode(to: encoder)
	}
}

extension Vector3: CrossProduct {
/// Computes the cross product of this vector and the provided vector.
///
/// The cross product of two vectors is another vector perpendicular to
/// the two vectors.
///
/// - Parameters:
///   - other: The vector to calculate a cross product against.
///
/// - Returns: A new vector storing the calculated cross product.
///
	@inlinable
	public func cross(_ other: Self) -> Self {
		Self(x: storage.y * other.storage.z - storage.z * other.storage.y,
			 y: storage.z * other.storage.x - storage.x * other.storage.z,
			 z: storage.x * other.storage.y - storage.y * other.storage.x)
	}
}

extension Vector3: CustomStringConvertible where Component: CVarArg {
	public var description: String {
		"""
		[ \(String(format: "%.3f", storage[0]))  \(String(format: "%.3f", storage[1]))  \(String(format: "%.3f", storage[2])) ]
		"""
	}
}

extension Vector3: DotProduct {
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
	@inlinable
	public func dot(_ other: Self) -> Component {
		storage.x * other.storage.x +
		storage.y * other.storage.y +
		storage.z * other.storage.z
	}
}

extension Vector3: Equatable {
	
}

extension Vector3: EuclideanDistanceMeasurable {
/// Computes the straight-line euclidian distance from this vector to
/// another.
///
/// - Parameters:
///   - other: The vector to measure the distance to.
///
/// - Returns: The euclidian distance between the two vectors.
///
	@inlinable
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
	@inlinable
	public func squaredDistance(to other: Self) -> Component {
		Component.pow((storage.x - other.storage.x), 2) +
		Component.pow((storage.y - other.storage.y), 2) +
		Component.pow((storage.z - other.storage.z), 2)
	}
}

extension Vector3: ExpressibleByArrayLiteral {
/// Initialize the vector from an array literal.
///
/// For example, the vector can be initialized as follows:
/// ```swift
/// let vector: Vector3 = [1.0, 2.0, 3.0]
/// ```
///
	@inlinable
	public init(arrayLiteral elements: Component...) {
		var vector = Self()
		for i in 0..<Swift.min(Self.count, elements.count) {
			vector.storage[i] = elements[i]
		}
		self = vector
	}
}

extension Vector3: MagnitudeAdjustable {
/// The magnitude or length of the vector.
///
	@inlinable
	public var magnitude: Component {
		get {
			Component.sqrt(Component.pow(storage.x, 2) + Component.pow(storage.y, 2) + Component.pow(storage.z, 2))
		}
		set {
			let length = Component.sqrt(Component.pow(storage.x, 2) + Component.pow(storage.y, 2) + Component.pow(storage.z, 2))
			if length.isApproximatelyEqual(to: .zero) {
				return
			}
			let factor = newValue / length
			storage.x *= factor
			storage.y *= factor
			storage.z *= factor
		}
	}
}

extension Vector3: MagnitudeMeasurable {
	
}

extension Vector3: Normalizable {
/// Normalizes the vector, setting its magnitude to 1.0.
///
/// Returns a unit vector that maintains the same direction as the original 
/// but has a length of 1.0.
///
/// - Warning: If the vector has zero length, the behavior of this function
/// is undefined.
///
	@inlinable
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
	@inlinable
	public mutating func normalize() {
		let length = magnitude
		precondition(length.isApproximatelyEqual(to: .zero) == false, "Attempted to normalize a zero-length vector.")
		self /= length
	}
}

extension Vector3: QuaternionRotatable {
/// Rotates the vector by a quaternion returning a rotated vector.
///
/// - Parameters:
///   - quaternion: The quaternion to rotate the vector by.
///
/// - Returns: A vector storing the result of the rotation.
///
	@inlinable
	public func rotated(by quaternion: Quaternion<Component>) -> Self {
		quaternion.rotate(vector: self)
	}

/// Rotates the vector by a quaternion.
///
/// - Parameters:
///   - quaternion: The quaternion to rotate the vector by.
///
	@inlinable
	public mutating func rotate(by quaternion: Quaternion<Component>) {
		self = quaternion.rotate(vector: self)
	}
}

extension Vector3: Sendable where SIMDRepresentation: Sendable {
	
}

extension Vector3: SIMDConvertible {
	public typealias SIMDRepresentation = SIMD3<Component>
	
	@inlinable
	public init(_ simd: SIMDRepresentation) {
		self.storage = simd
	}
	
	@inlinable
	public var simd: SIMDRepresentation {
		get {
			storage
		}
		set {
			storage = newValue
		}
	}
}

extension Vector3: Transformable3D {
	public typealias Scalar = Component

	@inlinable
	public mutating func transform<T>(by transform: T) where T: Transform3Protocol, Component == T.Component {
		self = transform.matrix.transform(point: self)
	}
	
	@inlinable
	public func transformed<T>(by transform: T) -> Vector3<Component> where T: Transform3Protocol, Component == T.Component {
		transform.matrix.transform(point: self)
	}
}

extension Vector3: Vector3Like {
	
}

extension Vector3: VectorMath {
	@inlinable
	public func min() -> Component {
		storage.min()
	}
	
	@inlinable
	public func max() -> Component {
		storage.max()
	}
	
	@inlinable
	public func average() -> Component {
		storage.sum() / Component(Self.count)
	}
	
	@inlinable
	public func sum() -> Component {
		storage.sum()
	}
	
	@inlinable
	public static func min(_ a: Self, _ b: Self) -> Self {
		Self(x: Swift.min(a.storage.x, b.storage.x),
			 y: Swift.min(a.storage.y, b.storage.y),
			 z: Swift.min(a.storage.z, b.storage.z)
		)
	}

	@inlinable
	public static func max(_ a: Self, _ b: Self) -> Self {
		Self(x: Swift.max(a.storage.x, b.storage.x),
			 y: Swift.max(a.storage.y, b.storage.y),
			 z: Swift.max(a.storage.z, b.storage.z)
		)
	}

	@inlinable
	public func abs() -> Self {
		Self(x: Swift.abs(storage.x),
			 y: Swift.abs(storage.y),
			 z: Swift.abs(storage.z)
		)
	}
	
	@inlinable
	public static func + (lhs: Self, rhs: Self) -> Self {
		Self(lhs.storage + rhs.storage)
	}

	@inlinable
	public static func += (lhs: inout Self, rhs: Self) {
		lhs.storage += rhs.storage
	}

	@inlinable
	public static func + (lhs: Self, rhs: Component) -> Self {
		Self(lhs.storage + rhs)
	}

	@inlinable
	public static func + (lhs: Component, rhs: Self) -> Self {
		Self(lhs + rhs.storage)
	}

	@inlinable
	public static func += (lhs: inout Self, rhs: Component) {
		lhs.storage += rhs
	}

	@inlinable
	public static func - (lhs: Self, rhs: Self) -> Self {
		Self(lhs.storage - rhs.storage)
	}

	@inlinable
	public static func -= (lhs: inout Self, rhs: Self) {
		lhs.storage -= rhs.storage
	}

	@inlinable
	public static func - (lhs: Self, rhs: Component) -> Self {
		Self(lhs.storage - rhs)
	}

	@inlinable
	public static func - (lhs: Component, rhs: Self) -> Self {
		Self(lhs - rhs.storage)
	}

	@inlinable
	public static func -= (lhs: inout Self, rhs: Component) {
		lhs.storage -= rhs
	}

	@inlinable
	public static prefix func - (vector: Self) -> Self {
		Self(-vector.storage)
	}

	@inlinable
	public static func * (lhs: Self, rhs: Self) -> Self {
		Self(lhs.storage * rhs.storage)
	}

	@inlinable
	public static func *= (lhs: inout Self, rhs: Self) {
		lhs.storage *= rhs.storage
	}

	@inlinable
	public static func * (lhs: Self, rhs: Component) -> Self {
		Self(lhs.storage * rhs)
	}

	@inlinable
	public static func * (lhs: Component, rhs: Self) -> Self {
		Self(lhs * rhs.storage)
	}
	
	@inlinable
	public static func *= (lhs: inout Self, rhs: Component) {
		lhs.storage *= rhs
	}

	@inlinable
	public static func / (lhs: Self, rhs: Self) -> Self {
		Self(lhs.storage / rhs.storage)
	}

	@inlinable
	public static func /= (lhs: inout Self, rhs: Self) {
		lhs.storage /= rhs.storage
	}

	@inlinable
	public static func / (lhs: Self, rhs: Component) -> Self {
		Self(lhs.storage / rhs)
	}

	@inlinable
	public static func /= (lhs: inout Self, rhs: Component) {
		lhs.storage /= rhs
	}
}

extension Vector3: VectorProtocol {
	@inlinable
	public static var count: Int {
		SIMDRepresentation.scalarCount
	}
	
	@inlinable
	public init() {
		self.storage = SIMDRepresentation()
	}
	
	@inlinable
	public init<C>(_ collection: C) where C : Collection, Component == C.Element {
		var vector = SIMDRepresentation()
		for enumerator in collection.prefix(Self.count).enumerated() {
			vector[enumerator.offset] = enumerator.element
		}
		self.storage = vector
	}
	
	@inlinable
	public subscript(index: Int) -> Component {
		get {
			storage[index]
		}
		set {
			storage[index] = newValue
		}
	}
	
	@inlinable
	public mutating func clear() {
		storage = SIMDRepresentation()
	}
}

extension Vector3: VectorReflectable {
	@inlinable
	public func reflection(withNormal normal: Self) -> Self {
		let normal = normal.normalized
		return self - (2 * dot(normal) * normal)
	}
}

extension Vector3: VectorRefractable {
	@inlinable
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

extension Vector3: Hashable {
	@inlinable
	public func hash(into hasher: inout Hasher) {
		hasher.combine(simd)
	}
}
