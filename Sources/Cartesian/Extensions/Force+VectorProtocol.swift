//
//  Force+VectorProtocol.swift
//  Cartesian
//
//  Created by Matt Cox on 02/05/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import RealModule
import Units

extension Force: Blendable {
	public static func blend(from: Self, to: Self, by amount: Component.Value) -> Self {
		var componentTotals: [Component] = []
		for index in 0..<Self.count {
			componentTotals.append(from[index] + (to[index] - from[index]) * amount)
		}
		return Self(componentTotals)
	}
	
	public mutating func blend(to other: Self, by amount: Component.Value) {
		self = Self.blend(from: self, to: other, by: amount)
	}
}

extension Force: @retroactive ExpressibleByArrayLiteral {
/// Initialize the force from an array literal.
///
/// For example, the force can be initialized as follows:
/// ```swift
/// let force: Force<SIMD2<Double>> = [.newtons(1.0), .newtons(2.0)]
/// ```
///
	public init(arrayLiteral elements: Component...) {
		var vector = Self()
		for index in 0..<Swift.min(Self.count, elements.count) {
			vector[index] = elements[index]
		}
		self = vector
	}
}

extension Force: MagnitudeMeasurable {
	
}

extension Force: MagnitudeAdjustable {
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
				
			return total.squareRoot()
		}
		set {
			let factor = Component(1.0) / self.magnitude
			for index in 0..<Self.count {
				self[index] *= factor * newValue
			}
		}
	}
}

extension Force: Normalizable {
	public var normalized: Self {
		self / magnitude
	}

	public mutating func normalize() {
		self /= magnitude
	}
}

extension Force: VectorMath {
	public static func min(_ a: Self, _ b: Self) -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result[i] = Swift.min(a[i], b[i])
		}
		return result
	}

	public static func max(_ a: Self, _ b: Self) -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result[i] = Swift.max(a[i], b[i])
		}
		return result
	}

	public func abs() -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result[i] = Swift.abs(self[i])
		}
		return result
	}
}

extension Force: VectorProtocol {
	public static var count: Int {
		Value.scalarCount
	}
	
	public init() {
		self = .zero
	}

	public init<C>(_ collection: C) where C : Collection, Component == C.Element {
		var value: Self = .zero
		for enumerator in collection.prefix(Self.count).enumerated() {
			value[enumerator.offset] = enumerator.element
		}
		self = value
	}

	public mutating func clear() {
		self = .zero
	}
}
