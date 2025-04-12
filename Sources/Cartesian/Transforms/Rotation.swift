//
//  Rotation.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import Units

/// A ``Vector`` storing a rotation in N dimensions.
///
/// The underlying vector must be provided, which will be used for storage
/// of the unit-less components
///
public struct Rotation<V: Vector> where V.Component: BinaryFloatingPoint {
	private var vector: V
	
/// Initialize the rotation using a vector representing angles in the
/// specified unit of measurement.
///
/// - Parameters:
///   - vector: The vector containing the rotation angles.
///   - unit: The unit of measurement for the angles.
///
	public init(_ vector: V, unit: Angle<V.Component>.MeasurementUnit = .base) {
		var components: [V.Component] = []
		for i in 0..<V.count {
			components.append(Angle(vector[i], unit: unit).get(unit: .base))
		}
		self.vector = V(components)
	}
}

extension Rotation: Blendable where V: Blendable {
	public static func blend(from: Self, to: Self, by amount: V.BlendAmount) -> Self {
		Self(V.blend(from: from.vector, to: to.vector, by: amount))
	}
	
	public mutating func blend(to other: Self, by amount: V.BlendAmount) {
		self.vector.blend(to: other.vector, by: amount)
	}
}

extension Rotation: Vector {
	public typealias Component = Angle<V.Component>

	public static var count: Int {
		V.count
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
			Angle(vector[index], unit: .base)
		}
		set {
			vector[index] = newValue.get(unit: .base)
		}
	}
	
	public mutating func clear() {
		vector.clear()
	}
}

extension Rotation: Vector2 where V: Vector2 {
	
}

extension Rotation: Vector3 where V: Vector3 {
	
}

extension Rotation: Vector4 where V: Vector4 {
	
}

extension Rotation: VectorMath where V: VectorMath {
	public func min() -> Component {
		Angle(vector.min(), unit: .base)
	}
	
	public func max() -> Component {
		Angle(vector.max(), unit: .base)
	}
	
	public func average() -> Component {
		Angle(vector.average(), unit: .base)
	}
	
	public func sum() -> Component {
		Angle(vector.sum(), unit: .base)
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
