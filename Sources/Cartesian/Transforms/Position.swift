//
//  Position.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import Units

/// A ``Vector`` storing a position in N dimensions.
///
/// The underlying vector must be provided, which will be used for storage
/// of the unit-less components
///
public struct Position<V: Vector> where V.Component: BinaryFloatingPoint {
	private var vector: V
	
/// Initialize the position using a vector representing angles in the
/// specified unit of measurement.
///
/// - Parameters:
///   - vector: The vector containing the positions.
///   - unit: The unit of measurement for the position.
///
	public init(_ vector: V, unit: Distance<V.Component>.MeasurementUnit = .base) {
		var components: [V.Component] = []
		for i in 0..<V.dimensions {
			components.append(Distance(vector[i], unit: unit).get(unit: .base))
		}
		self.vector = V(components)
	}
}

extension Position: Blendable where V: Blendable {
	public static func blend(from: Self, to: Self, by amount: V.BlendAmount) -> Self {
		Self(V.blend(from: from.vector, to: to.vector, by: amount))
	}
	
	public mutating func blend(to other: Self, by amount: V.BlendAmount) {
		self.vector.blend(to: other.vector, by: amount)
	}
}

extension Position: Vector {
	public typealias Component = Distance<V.Component>

	public static var dimensions: Int {
		V.dimensions
	}
	
	public init() {
		self.vector = V()
	}
	
	public init<C: Collection>(_ collection: C) where C.Element == Component {
		self.vector = V(collection.map {
			$0.get(unit: .base)
		})
	}
	
	public subscript(index: Int) -> Component {
		get {
			Distance(vector[index], unit: .base)
		}
		set {
			vector[index] = newValue.get(unit: .base)
		}
	}
	
	public mutating func clear() {
		vector.clear()
	}
}

extension Position: Vector2 where V: Vector2 {
	
}

extension Position: Vector2Rotatable where V: Vector2Rotatable {
	public func rotated(by angle: Angle<V.AngleRepresentation>) -> Self {
		Self(vector.rotated(by: angle))
	}
	
	public mutating func rotate(by angle: Angle<V.AngleRepresentation>) {
		vector.rotate(by: angle)
	}
}

extension Position: Vector3 where V: Vector3 {
	
}

extension Position: Vector3Rotatable where V: Vector3Rotatable {
	public func rotated(x: Angle<V.AngleRepresentation>, y: Angle<V.AngleRepresentation>, z: Angle<V.AngleRepresentation>, order: RotationOrder) -> Self {
		Self(vector.rotated(x: x, y: y, z: z, order: order))
	}

	public func rotated<T: Vector3>(by rotation: Rotation<T>, order: RotationOrder) -> Self where T.Component == V.AngleRepresentation {
		Self(vector.rotated(by: rotation, order: order))
	}

	public mutating func rotate(x: Angle<V.AngleRepresentation>, y: Angle<V.AngleRepresentation>, z: Angle<V.AngleRepresentation>, order: RotationOrder) {
		vector.rotate(x: x, y: y, z: z, order: order)
	}

	public mutating func rotate<T: Vector3>(by rotation: Rotation<T>, order: RotationOrder) where T.Component == V.AngleRepresentation {
		vector.rotate(by: rotation, order: order)
	}
}

extension Position: Vector4 where V: Vector4 {
	
}

extension Position: VectorAngle where V: VectorAngle {
	public static func angle(from: Self, to: Self, by: Self?) -> Angle<V.AngleRepresentation> {
		V.angle(from: from.vector, to: to.vector, by: by?.vector)
	}
}

extension Position: VectorCross where V: VectorCross {
	public func cross(_ other: Self) -> Self {
		Self(vector.cross(other.vector))
	}
	
	public static func ⨯= (lhs: inout Self, rhs: Self) {
		lhs.vector ⨯= rhs.vector
	}
}

extension Position: VectorDot where V: VectorDot {
	public func dot(_ other: Self) -> V.Dot {
		vector.dot(other.vector)
	}
}

extension Position: VectorEuclidianDistance where V: VectorEuclidianDistance {
	public func squaredDistance(to other: Self) -> Component {
		Component(vector.squaredDistance(to: other.vector), unit: .base)
	}
}

extension Position: VectorMagnitude where V: VectorMagnitude {
	public var magnitude: Component {
		get {
			Component(vector.magnitude, unit: .base)
		}
		set {
			vector.magnitude = newValue.value
		}
	}
}

extension Position: VectorMath where V: VectorMath {
	public func min() -> Component {
		Distance(vector.min(), unit: .base)
	}
	
	public func max() -> Component {
		Distance(vector.max(), unit: .base)
	}
	
	public func average() -> Component {
		Distance(vector.average(), unit: .base)
	}
	
	public func sum() -> Component {
		Distance(vector.sum(), unit: .base)
	}

	public static func + (lhs: Self, rhs: Self) -> Self {
		Self(lhs.vector + rhs.vector)
	}

	public static func += (lhs: inout Self, rhs: Self) {
		lhs.vector += rhs.vector
	}

	public static func + (lhs: Self, rhs: Component) -> Self {
		Self(lhs.vector + rhs.value)
	}

	public static func + (lhs: Component, rhs: Self) -> Self {
		Self(lhs.value + rhs.vector)
	}

	public static func += (lhs: inout Self, rhs: Component) {
		lhs.vector += rhs.value
	}

	public static func - (lhs: Self, rhs: Self) -> Self {
		Self(lhs.vector - rhs.vector)
	}

	public static func -= (lhs: inout Self, rhs: Self) {
		lhs.vector -= rhs.vector
	}

	public static func - (lhs: Self, rhs: Component) -> Self {
		Self(lhs.vector - rhs.value)
	}

	public static func - (lhs: Component, rhs: Self) -> Self {
		Self(lhs.value + rhs.vector)
	}

	public static func -= (lhs: inout Self, rhs: Component) {
		lhs.vector -= rhs.value
	}

	public static prefix func - (vector: Self) -> Self {
		Self(-vector.vector)
	}

	public static func * (lhs: Self, rhs: Self) -> Self {
		Self(lhs.vector * rhs.vector)
	}

	public static func *= (lhs: inout Self, rhs: Self) {
		lhs.vector *= rhs.vector
	}

	public static func * (lhs: Self, rhs: Component) -> Self {
		Self(lhs.vector * rhs.value)
	}

	public static func * (lhs: Component, rhs: Self) -> Self {
		Self(lhs.value * rhs.vector)
	}
	
	public static func *= (lhs: inout Self, rhs: Component) {
		lhs.vector *= rhs.value
	}

	public static func / (lhs: Self, rhs: Self) -> Self {
		Self(lhs.vector / rhs.vector)
	}

	public static func /= (lhs: inout Self, rhs: Self) {
		lhs.vector /= rhs.vector
	}

	public static func / (lhs: Self, rhs: Component) -> Self {
		Self(lhs.vector / rhs.value)
	}

	public static func /= (lhs: inout Self, rhs: Component) {
		lhs.vector /= rhs.value
	}
}

extension Position: VectorNormalizable where V: VectorNormalizable {
	public var normalized: Self {
		Self(vector.normalized)
	}
	
	public mutating func normalize() {
		vector.normalize()
	}
}

extension Position: VectorReflection where V: VectorReflection {
	public func reflection(withNormal normal: Self) -> Self {
		Self(vector.reflection(withNormal: normal.vector))
	}
	
	public func refraction(withNormal normal: Self, indexOfRefraction: V.IndexOfRefraction) -> Self {
		Self(vector.refraction(withNormal: normal.vector, indexOfRefraction: indexOfRefraction))
	}
}
