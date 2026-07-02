//
//  Rotation+VectorProtocol.swift
//  Cartesian
//
//  Created by Matt Cox on 02/05/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import RealModule
import Units

extension Rotation: @retroactive ExpressibleByArrayLiteral {
/// Initialize the rotation from an array literal.
///
/// For example, the rotation can be initialized as follows:
/// ```swift
/// let rotation: Rotation<SIMD2<Double>> = [.degrees(45.0), .degrees(90.0)]
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

extension Rotation: Normalizable {
	
}

extension Rotation: VectorMath {
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

extension Rotation: VectorProtocol {
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
