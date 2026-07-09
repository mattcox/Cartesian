//
//  Position+VectorProtocol.swift
//  Cartesian
//
//  Created by Matt Cox on 22/04/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import Foundation
import RealModule
import Units

extension Position: AngleMeasurable where Component.Value: Real {
	@inlinable
	public static func angle(from: Self, to: Self, by: Self?) -> Angle<Component.Value> {
		let by = by ?? Self.zero
		
		let fromNormalized = (from - by).normalized
		let toNormalized = (to - by).normalized
		
		let dotProduct = fromNormalized.dot(toNormalized)
		
		return Angle(radians: Component.Value.acos(dotProduct))
	}
}

extension Position: Blendable {
	@inlinable
	public static func blend(from: Self, to: Self, by amount: Component.Value) -> Self {
		var componentTotals: [Component] = []
		for index in 0..<Self.count {
			componentTotals.append(from[index] + (to[index] - from[index]) * amount)
		}
		return Self(componentTotals)
	}
	
	@inlinable
	public mutating func blend(to other: Self, by amount: Component.Value) {
		self = Self.blend(from: self, to: other, by: amount)
	}
}

extension Position: DotProduct {
	@inlinable
	public func dot(_ other: Self) -> Component.Value {
		var componentProducts: [Component] = []
		for index in 0..<Self.count {
			componentProducts.append(self[index] * other[index])
		}
		
		return componentProducts
			.reduce(Component.zero) {
				$0 + $1
			}
			.value
	}
}

extension Position: EuclideanDistanceMeasurable {
	@inlinable
	public func distance(to other: Self) -> Component {
		sqrt(squaredDistance(to: other))
	}

	@inlinable
	public func squaredDistance(to other: Self) -> Component {
		var componentTotals: [Component] = []
		for index in 0..<Self.count {
			componentTotals.append(self[index] - other[index])
		}
		
		return componentTotals
			.map {
				$0 * $0
			}
			.reduce(Component.zero) {
				$0 + $1
			}
	}
}

extension Position: @retroactive ExpressibleByArrayLiteral {
/// Initialize the position from an array literal.
///
/// For example, the position can be initialized as follows:
/// ```swift
/// let position: Position<SIMD2<Double>> = [.meters(1.0), .meters(2.0)]
/// ```
///
	@inlinable
	public init(arrayLiteral elements: Component...) {
		var vector = Self()
		for index in 0..<Swift.min(Self.count, elements.count) {
			vector[index] = elements[index]
		}
		self = vector
	}
}

extension Position: MagnitudeMeasurable {
	
}

extension Position: MagnitudeAdjustable {
	@inlinable
	public var magnitude: Component {
		get {
			var components: [Component] = []
			for index in 0..<Self.count {
				components.append(self[index])
			}
			
			let total = components
				.map {
					$0 * $0
				}
				.reduce(Component.zero) {
					$0 + $1
				}
				
			return sqrt(total)
		}
		set {
			let factor = Component(1.0) / self.magnitude
			for index in 0..<Self.count {
				self[index] *= factor * newValue
			}
		}
	}
}

extension Position: Normalizable {
	@inlinable
	public var normalized: Self {
		self / magnitude
	}

	@inlinable
	public mutating func normalize() {
		self /= magnitude
	}
}

extension Position: VectorMath {
	@inlinable
	public static func min(_ a: Self, _ b: Self) -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result[i] = Swift.min(a[i], b[i])
		}
		return result
	}

	@inlinable
	public static func max(_ a: Self, _ b: Self) -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result[i] = Swift.max(a[i], b[i])
		}
		return result
	}

	@inlinable
	public func abs() -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result[i] = Swift.abs(self[i])
		}
		return result
	}
}

extension Position: VectorProtocol {
	@inlinable
	public static var count: Int {
		Value.scalarCount
	}
	
	@inlinable
	public init() {
		self = .zero
	}
	
	@inlinable
	public init<C>(_ collection: C) where C : Collection, Component == C.Element {
		var value: Self = .zero
		for enumerator in collection.prefix(Self.count).enumerated() {
			value[enumerator.offset] = enumerator.element
		}
		self = value
	}
	
	@inlinable
	public mutating func clear() {
		self = .zero
	}
}
