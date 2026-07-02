//
//  Vector.swift
//  Cartesian
//
//  Created by Matt Cox on 18/06/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import RealModule
import Units

/// A N-dimensional vector storing scalar components.
///
/// This uses `InlineArray` as a backing store, so is unavailable on older
/// or unsupported platforms. The values are stored on the stack for efficiency.
///
/// - Warning: Unlike the fixed-size `Vector2`, `Vector3` and `Vector4` types,
/// this type does not use simd instructions and is not vectorized. It should
/// only be used for non-standard vector sizes or cases where SIMD acceleration
/// is not required.
///
/// - Precondition: `numberOfComponents` must be greater than zero.
///
@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
public struct Vector<let numberOfComponents: Int, Component: Real & SIMDScalar> {
	private typealias Storage = InlineArray<numberOfComponents, Component>
	private var storage: Storage
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector where numberOfComponents == 2 {
/// Initialize the vector using individual X and Y components.
///
/// - Parameters:
///   - x: The first component of the vector.
///   - y: The second component of the vector.
///
	public init(x: Component, y: Component) {
		self.storage = [x, y]
	}
	
/// Initialize the vector using individual U and V components.
///
/// - Parameters:
///   - u: The first component of the vector.
///   - v: The second component of the vector.
///
	public init(u: Component, v: Component) {
		self.storage = [u, v]
	}
	
/// Initialize the vector using individual components.
///
/// - Parameters:
///   - first: The first component of the vector.
///   - second: The second component of the vector.
///
	public init(_ first: Component, _ second: Component) {
		self.storage = [first, second]
	}
	
/// Initialize from a Vector2.
///
/// - Parameters:
///   - vector: The two component vector used to initialize this vector.
///
	public init(_ vector: Vector2<Component>) {
		self = Vector(vector[0], vector[1])
	}
	
/// Get the vector as a SIMD compatible object.
///
	public var simd: Vector2<Component>.SIMDRepresentation {
		Vector2<Component>.SIMDRepresentation(self[0], self[1])
	}
	
/// Get the vector as a Vector2.
///
	public var fixed: Vector2<Component> {
		Vector2(self[0], self[1])
	}
	
/// Initialize from a SIMD representation.
///
/// - Parameters:
///   - simd: The SIMD2 representation used to initialize this vector.
///
	public init(simd: Vector2<Component>.SIMDRepresentation) {
		self.storage = [simd[0], simd[1]]
	}
	
/// The first component of the vector.
///
	public var first: Component {
		get {
			storage[0]
		}
		set {
			storage[0] = newValue
		}
	}

/// The second component of the vector.
///
	public var second: Component {
		get {
			storage[1]
		}
		set {
			storage[1] = newValue
		}
	}
	
/// The first component of the vector.
///
	public var x: Component {
		get {
			storage[0]
		}
		set {
			storage[0] = newValue
		}
	}

/// The second component of the vector.
///
	public var y: Component {
		get {
			storage[1]
		}
		set {
			storage[1] = newValue
		}
	}
	
/// The first component of the vector.
///
	public var u: Component {
		get {
			storage[0]
		}
		set {
			storage[0] = newValue
		}
	}
	
/// The second component of the vector.
///
	public var v: Component {
		get {
			storage[1]
		}
		set {
			storage[1] = newValue
		}
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector where numberOfComponents == 3 {
/// Initialize the vector using individual X, Y and Z components.
///
/// - Parameters:
///   - x: The first component of the vector.
///   - y: The second component of the vector.
///   - z: The third component of the vector.
///
	public init(x: Component, y: Component, z: Component) {
		self.storage = [x, y, z]
	}
	
/// Initialize the vector using individual components.
///
/// - Parameters:
///   - first: The first component of the vector.
///   - second: The second component of the vector.
///   - third: The third component of the vector.
///
	public init(_ first: Component, _ second: Component, _ third: Component) {
		self.storage = [first, second, third]
	}
	
/// Initialize from a Vector3.
///
/// - Parameters:
///   - vector: The three component vector used to initialize this vector.
///
	public init(_ vector: Vector3<Component>) {
		self = Vector(vector[0], vector[1], vector[2])
	}
	
/// Get the vector as a SIMD compatible object.
///
	public var simd: Vector3<Component>.SIMDRepresentation {
		Vector3<Component>.SIMDRepresentation(self[0], self[1], self[2])
	}
	
/// Get the vector as a Vector3.
///
	public var fixed: Vector3<Component> {
		Vector3(self[0], self[1], self[2])
	}
	
/// Initialize from a SIMD representation.
///
/// - Parameters:
///   - simd: The SIMD3 representation used to initialize this vector.
///
	public init(simd: Vector3<Component>.SIMDRepresentation) {
		self.storage = [simd[0], simd[1], simd[2]]
	}
	
/// The first component of the vector.
///
	public var first: Component {
		get {
			storage[0]
		}
		set {
			storage[0] = newValue
		}
	}

/// The second component of the vector.
///
	public var second: Component {
		get {
			storage[1]
		}
		set {
			storage[1] = newValue
		}
	}
	
/// The third component of the vector.
///
	public var third: Component {
		get {
			storage[2]
		}
		set {
			storage[2] = newValue
		}
	}
	
/// The first component of the vector.
///
	public var x: Component {
		get {
			storage[0]
		}
		set {
			storage[0] = newValue
		}
	}

/// The second component of the vector.
///
	public var y: Component {
		get {
			storage[1]
		}
		set {
			storage[1] = newValue
		}
	}
	
/// The third component of the vector.
///
	public var z: Component {
		get {
			storage[2]
		}
		set {
			storage[2] = newValue
		}
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector where numberOfComponents == 4 {
/// Initialize the vector using individual X, Y, Z and W components.
///
/// - Parameters:
///   - x: The first component of the vector.
///   - y: The second component of the vector.
///   - z: The third component of the vector.
///   - w: The fourth component of the vector.
///
	public init(x: Component, y: Component, z: Component, w: Component) {
		self.storage = [x, y, z, w]
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
		self.storage = [first, second, third, fourth]
	}
	
/// Initialize from a Vector4.
///
/// - Parameters:
///   - vector: The four component vector used to initialize this vector.
///
	public init(_ vector: Vector4<Component>) {
		self = Vector(vector[0], vector[1], vector[2], vector[3])
	}

/// Get the vector as a SIMD compatible object.
///
	public var simd: Vector4<Component>.SIMDRepresentation {
		Vector4<Component>.SIMDRepresentation(self[0], self[1], self[2], self[3])
	}
	
/// Get the vector as a Vector4.
///
	public var fixed: Vector4<Component> {
		Vector4(self[0], self[1], self[2], self[3])
	}

/// Initialize from a SIMD representation.
///
/// - Parameters:
///   - simd: The SIMD4 representation used to initialize this vector.
///
	public init(simd: Vector4<Component>.SIMDRepresentation) {
		self.storage = [simd[0], simd[1], simd[2], simd[3]]
	}

/// The first component of the vector.
///
	public var first: Component {
		get {
			storage[0]
		}
		set {
			storage[0] = newValue
		}
	}

/// The second component of the vector.
///
	public var second: Component {
		get {
			storage[1]
		}
		set {
			storage[1] = newValue
		}
	}
	
/// The third component of the vector.
///
	public var third: Component {
		get {
			storage[2]
		}
		set {
			storage[2] = newValue
		}
	}
	
/// The fourth component of the vector.
///
	public var fourth: Component {
		get {
			storage[3]
		}
		set {
			storage[3] = newValue
		}
	}
	
/// The first component of the vector.
///
	public var x: Component {
		get {
			storage[0]
		}
		set {
			storage[0] = newValue
		}
	}

/// The second component of the vector.
///
	public var y: Component {
		get {
			storage[1]
		}
		set {
			storage[1] = newValue
		}
	}
	
/// The third component of the vector.
///
	public var z: Component {
		get {
			storage[2]
		}
		set {
			storage[2] = newValue
		}
	}
	
/// The fourth component of the vector.
///
	public var w: Component {
		get {
			storage[3]
		}
		set {
			storage[3] = newValue
		}
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector {
/// Returns a vector where each component is the lesser of the corresponding
/// components in the two vectors.
///
/// - Parameters:
///   - a: The first vector.
///   - b: The second vector.
///
/// - Returns: A vector containing the component-wise minimum values.
///
	public static func min(_ a: Self, _ b: Self) -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result[i] = Swift.min(a[i], b[i])
		}
		return result
	}

/// Returns a vector where each component is the greater of the
/// corresponding components in the two vectors.
///
/// - Parameters:
///   - a: The first vector.
///   - b: The second vector.
///
/// - Returns: A vector containing the component-wise maximum values.
///
	public static func max(_ a: Self, _ b: Self) -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result[i] = Swift.max(a[i], b[i])
		}
		return result
	}

/// Returns a vector where each component is the absolute value of the
/// corresponding component in this vector.
///
/// - Returns: A vector with all components made non-negative.
///
	public func abs() -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result[i] = Swift.abs(self[i])
		}
		return result
	}
}


@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: AngleMeasurable where Component: BinaryFloatingPoint {
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

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: Blendable {
	public static func blend(from: Self, to: Self, by amount: Component) -> Self {
		from + (to - from) * amount
	}
	
	public mutating func blend(to other: Self, by amount: Component) {
		self += (other - self) * amount
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: Codable {
	public init(from decoder: Decoder) throws {
		precondition(numberOfComponents > 0, "numberOfComponents must be greater than zero.")
		let values = try Array<Component>(from: decoder)
		if values.count != Self.count {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid number of values to decode"))
		}
		
		var storage = Storage(repeating: .zero)
		for (i, value) in values.enumerated() {
			storage[i] = value
		}
		self.storage = storage
	}

	public func encode(to encoder: Encoder) throws {
		var values: [Component] = []
		for i in 0..<Self.count {
			values.append(storage[i])
		}
		try values.encode(to: encoder)
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: CrossProduct where numberOfComponents == 3 {
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
	public func cross(_ other: Self) -> Self {
		var result = Self()
		result[0] = storage[1] * other[2] - storage[2] * other[1]
		result[1] = storage[2] * other[0] - storage[0] * other[2]
		result[2] = storage[0] * other[1] - storage[1] * other[0]
		return result
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: CustomStringConvertible where Component: CVarArg {
	public var description: String {
		var values: [String] = []
		for i in 0..<Self.count {
			values.append(String(format: "%.3f", storage[i]))
		}
		
		return """
		[ \(values.joined(separator: "  ")) ]
		"""
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: DotProduct {
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
		var result: Component = .zero
		for i in 0..<Self.count {
			result += self[i] * other[i]
		}
		return result
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: Equatable {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		for i in 0..<lhs.storage.count {
			if lhs.storage[i] != rhs.storage[i] {
				return false
			}
		}
		return true
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: EuclideanDistanceMeasurable {
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
		var result: Component = .zero
		for i in 0..<Self.count {
			result += Component.pow((storage[i] - other.storage[i]), 2)
		}
		return result
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: ExpressibleByArrayLiteral {
/// Initialize the vector from an array literal.
///
/// For example, the vector can be initialized as follows:
/// ```swift
/// let vector: Vector<5, Double> = [1.0, 2.0, 3.0, 4.0, 5.0]
/// ```
///
/// If a shorter array is provided than the size of the vector, any
/// remaining space will be padded with zeros.
///
	public init(arrayLiteral elements: Component...) {
		var vector = Self()
		for i in 0..<Swift.min(Self.count, elements.count) {
			vector[i] = elements[i]
		}
		self = vector
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: MagnitudeAdjustable {
/// The magnitude or length of the vector.
///
	public var magnitude: Component {
		get {
			var total: Component = .zero
			for i in 0..<Self.count {
				total += Component.pow(storage[i], 2)
			}
			return Component.sqrt(total)
		}
		set {
			var total: Component = .zero
			for i in 0..<Self.count { total += Component.pow(storage[i], 2) }
			let length = Component.sqrt(total)
			if length.isApproximatelyEqual(to: .zero) {
				return
			}
			let factor = newValue / length
			for i in 0..<Self.count { storage[i] *= factor }
		}
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: MagnitudeMeasurable {
	
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: Normalizable {
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

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: QuaternionRotatable where numberOfComponents == 3 {
/// Rotates the vector by a quaternion returning a rotated vector.
///
/// - Parameters:
///   - quaternion: The quaternion to rotate the vector by.
///
/// - Returns: A vector storing the result of the rotation.
///
	public func rotated(by quaternion: Quaternion<Component>) -> Self {
		Self(quaternion.rotate(vector: self.fixed))
	}

/// Rotates the vector by a quaternion.
///
/// - Parameters:
///   - quaternion: The quaternion to rotate the vector by.
///
	public mutating func rotate(by quaternion: Quaternion<Component>) {
		self = Self(quaternion.rotate(vector: self.fixed))
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: Sendable where Storage: Sendable {
	
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: Vector2Like where numberOfComponents == 2 {

}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: Vector3Like where numberOfComponents == 3 {

}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: Vector4Like where numberOfComponents == 4 {

}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: VectorMath {
	public func min() -> Component {
		var minimum: Component = storage[0]
		for i in 1..<Self.count {
			minimum = Swift.min(storage[i], minimum)
		}
		return minimum
	}
	
	public func max() -> Component {
		var maximum: Component = storage[0]
		for i in 1..<Self.count {
			maximum = Swift.max(storage[i], maximum)
		}
		return maximum
	}
	
	public func average() -> Component {
		self.sum() / Component(Self.count)
	}
	
	public func sum() -> Component {
		var total: Component = .zero
		for i in 0..<Self.count {
			total += storage[i]
		}
		return total
	}
	
	public static func + (lhs: Self, rhs: Self) -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result.storage[i] = lhs.storage[i] + rhs.storage[i]
		}
		return result
	}

	public static func += (lhs: inout Self, rhs: Self) {
		for i in 0..<Self.count {
			lhs.storage[i] += rhs.storage[i]
		}
	}

	public static func + (lhs: Self, rhs: Component) -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result.storage[i] = lhs.storage[i] + rhs
		}
		return result
	}

	public static func + (lhs: Component, rhs: Self) -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result.storage[i] = lhs + rhs.storage[i]
		}
		return result
	}

	public static func += (lhs: inout Self, rhs: Component) {
		for i in 0..<Self.count {
			lhs.storage[i] += rhs
		}
	}

	public static func - (lhs: Self, rhs: Self) -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result.storage[i] = lhs.storage[i] - rhs.storage[i]
		}
		return result
	}

	public static func -= (lhs: inout Self, rhs: Self) {
		for i in 0..<Self.count {
			lhs.storage[i] -= rhs.storage[i]
		}
	}

	public static func - (lhs: Self, rhs: Component) -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result.storage[i] = lhs.storage[i] - rhs
		}
		return result
	}

	public static func - (lhs: Component, rhs: Self) -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result.storage[i] = lhs - rhs.storage[i]
		}
		return result
	}

	public static func -= (lhs: inout Self, rhs: Component) {
		for i in 0..<Self.count {
			lhs.storage[i] -= rhs
		}
	}

	public static prefix func - (vector: Self) -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result.storage[i] = -vector.storage[i]
		}
		return result
	}

	public static func * (lhs: Self, rhs: Self) -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result.storage[i] = lhs.storage[i] * rhs.storage[i]
		}
		return result
	}

	public static func *= (lhs: inout Self, rhs: Self) {
		for i in 0..<Self.count {
			lhs.storage[i] *= rhs.storage[i]
		}
	}

	public static func * (lhs: Self, rhs: Component) -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result.storage[i] = lhs.storage[i] * rhs
		}
		return result
	}

	public static func * (lhs: Component, rhs: Self) -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result.storage[i] = lhs * rhs.storage[i]
		}
		return result
	}
	
	public static func *= (lhs: inout Self, rhs: Component) {
		for i in 0..<Self.count {
			lhs.storage[i] *= rhs
		}
	}

	public static func / (lhs: Self, rhs: Self) -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result.storage[i] = lhs.storage[i] / rhs.storage[i]
		}
		return result
	}

	public static func /= (lhs: inout Self, rhs: Self) {
		for i in 0..<Self.count {
			lhs.storage[i] /= rhs.storage[i]
		}
	}

	public static func / (lhs: Self, rhs: Component) -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result.storage[i] = lhs.storage[i] / rhs
		}
		return result
	}

	public static func /= (lhs: inout Self, rhs: Component) {
		for i in 0..<Self.count {
			lhs.storage[i] /= rhs
		}
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: VectorProtocol {
	public static var count: Int {
		numberOfComponents
	}

	public init() {
		precondition(numberOfComponents > 0, "numberOfComponents must be greater than zero.")
		self.storage = Storage(repeating: .zero)
	}
	
	public init<C>(_ collection: C) where C : Collection, Component == C.Element {
		precondition(numberOfComponents > 0, "numberOfComponents must be greater than zero.")
		var storage = Storage(repeating: .zero)
		for (i, value) in collection.prefix(Self.count).enumerated() {
			storage[i] = value
		}
		self.storage = storage
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
		self.storage = Storage(repeating: .zero)
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: VectorReflectable {
	public func reflection(withNormal normal: Self) -> Self {
		let normal = normal.normalized
		return self - (2 * dot(normal) * normal)
	}
}

@available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *)
extension Vector: VectorRefractable {
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
